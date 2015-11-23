/* CMPT 332 - Fall 2015
 * Assignment 4, Question 1
 *
 * Jordaen Graham - jhg257
 * Jennifer Rospad - jlr247
 *
 * File: server.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <signal.h>
#include "server.h"
#include <ifaddrs.h>


#define BACKLOG 10     // how many pending connections queue will hold


struct clients{
    int fd;
    char *address;
    struct clients *next;
}*clients_list;
int list_size=0;
pthread_mutex_t list_mutex;


void sigchld_handler(int s) {
    // waitpid() might overwrite errno, so we save and restore it:
    int saved_errno = errno;

    while(waitpid(-1, NULL, WNOHANG) > 0);

    errno = saved_errno;
}

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa) {
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }

    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

struct clients *get_connections(int server_fd) {
    int client_fd; //return
    socklen_t sin_size;
    char s[INET6_ADDRSTRLEN];
    struct sockaddr_storage their_addr; // connector's address information
    struct clients *client;

    sin_size = sizeof their_addr;
    client_fd = accept(server_fd, (struct sockaddr *)&their_addr, &sin_size);
    if (client_fd == -1) {
        perror("accept");
        return NULL;
    }

    inet_ntop(their_addr.ss_family, get_in_addr((struct sockaddr *)&their_addr), (char *) s, INET6_ADDRSTRLEN);

    printf("server: got connection from %s\n", s);
    fflush(stdout);
    client = malloc(sizeof(struct clients));
    client->fd = client_fd;
    client->address = malloc(INET6_ADDRSTRLEN* sizeof(char));
    snprintf(client->address, INET6_ADDRSTRLEN, "%s", s);
    client->next = NULL;
    return client;
}

char *recvMessage(int client_fd){
    ssize_t numbytes;
    char *buf = malloc(MAXDATASIZE * sizeof(char));

    if ((numbytes = recv(client_fd, buf, MAXDATASIZE-1, 0)) == -1) {
        perror("recv");
        exit(1);
    }
    else if (numbytes == 0){
        buf = "abort";
    }
    else
        buf[numbytes] = '\0';
    return buf;
}

int sendMessage(int client_fd, char *message) {
    if (send(client_fd, message, strlen(message), 0) == -1) {
        perror("send");
        return -1;
    }
    return 0;
}

int *sendToAllClients(struct clients *client, char *buf) {
    pthread_mutex_lock(&list_mutex);
    struct clients *cursor;
    int *bad_list = malloc(list_size*sizeof(int)), bad_size = 0;

    char *message = malloc(MAXDATASIZE*sizeof(char));
    snprintf(message, MAXDATASIZE, "%s, %d: %s", client->address, atoi(PORT), buf);
    cursor = clients_list;
    for(; cursor != NULL; cursor = cursor->next) {
        if (sendMessage(cursor->fd, message) == -1) {
            bad_list[bad_size] = client->fd;
            bad_size++;
        }
    }
    if (bad_size > 0) {
        bad_list[bad_size] = -1;
    } else
        bad_list = NULL;
    pthread_mutex_unlock(&list_mutex);
    return bad_list;
}

void addThreadToList(int client_fd, char *address) {
    pthread_mutex_lock(&list_mutex);

    struct clients *client = (struct clients *)malloc(sizeof(struct clients));
    client->fd = client_fd;
    client->address = address;
    if (clients_list == NULL)
    {
        clients_list = client;
        clients_list->next=NULL;
    }
    else
    {
        client->next = clients_list;
        clients_list = client;
    }

    pthread_mutex_unlock(&list_mutex);
}

void removeThreadFromList(int client_fd) {
    pthread_mutex_lock(&list_mutex);
    struct clients *cursor, *prev=NULL;
    cursor = clients_list;
    while(cursor != NULL)
    {
        if(cursor->fd == client_fd)
        {
            if(cursor == clients_list)
            {
                clients_list = cursor->next;
                free(cursor);
            }
            else
            {
                prev->next = cursor->next;
                free(cursor);
            }
            break;
        }
        else
        {
            prev = cursor;
            cursor = cursor->next;
        }
    }
    pthread_mutex_unlock(&list_mutex);
}

void *entry_func(void *args) {
    int i, client_fd, *bad_list=NULL;
    char *buf=NULL;

    struct clients *client = (struct clients*) args;
    client_fd = client->fd;

    while(1) {
        buf = recvMessage(client_fd);
        if (strcmp(buf, "/quit") == 0)
            break;
        else if (strcmp(buf, "abort") == 0){
            removeThreadFromList(client_fd);
            pthread_exit(NULL);
        }
        bad_list = sendToAllClients(client, ++buf);
        if(bad_list != NULL)
            for(i=0; i < list_size; i++) {
                if(bad_list[i] == -1)
                    break;
                fprintf(stderr, "Send error in client: %d\n", bad_list[i]);
                removeThreadFromList(bad_list[i]);
            }
    }
    sendMessage(client_fd, "Goodbye Server!!");

    removeThreadFromList(client_fd);
    close(client_fd);
    pthread_exit(NULL);
}

int run_server(int server_fd) {
    // Pointer to the location of all client thread
    pthread_t client_thread;
    int fd_set[2];
    struct clients *client;
    fd_set[0] = server_fd;

    // allocate space for the client_thread
    client_thread = (pthread_t) malloc(sizeof(pthread_t));
    if (client_thread == 0){
        perror("create thread");
        return -1;
    }

    while(1) {  // main accept() loop
        client = get_connections(server_fd);
        if (client->fd == -1) {
            continue;
        }
        fd_set[1] = client->fd;

        // Create and start thread
        if (pthread_create(&client_thread, NULL, entry_func, client) == -1){
            perror("start pthread");
            return -1;
        }
        addThreadToList(client->fd, client->address);
    }
}

int main(void) {
    int rv, yes = 1, server_fd = -1;  // listen for connection on server_fd, communicates on client_fd
    struct addrinfo hints, *servinfo, *p;
    struct sigaction sa;
    struct ifaddrs *addrs, *tmp;
    struct sockaddr_in *pAddr = NULL;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE; // use my IP

    if ((rv = getaddrinfo(NULL, PORT, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and bind to the first we can
    for (p = servinfo; p != NULL; p = p->ai_next) {
        if ((server_fd = socket(p->ai_family, p->ai_socktype,
                                p->ai_protocol)) == -1) {
            perror("server: socket");
            continue;
        }

        if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &yes,
                       sizeof(int)) == -1) {
            perror("setsockopt");
            exit(1);
        }

        if (bind(server_fd, p->ai_addr, p->ai_addrlen) == -1) {
            close(server_fd);
            perror("server: bind");
            continue;
        }

        break;
    }

    freeaddrinfo(servinfo); // all done with this structure

    if (p == NULL) {
        perror("server: failed to bind");
        exit(1);
    }

    if (listen(server_fd, BACKLOG) == -1) {
        perror("listen");
        exit(1);
    }

    sa.sa_handler = sigchld_handler; // reap all dead processes
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;
    if (sigaction(SIGCHLD, &sa, NULL) == -1) {
        perror("sigaction");
        exit(1);
    }

    getifaddrs(&addrs);
    tmp = addrs;

    while (tmp)
    {
        if (tmp->ifa_addr && tmp->ifa_addr->sa_family == AF_INET && strcmp(tmp->ifa_name, "en0") == 0)
        {
            pAddr = (struct sockaddr_in *)tmp->ifa_addr;
            break;
        }
        tmp = tmp->ifa_next;
    }
    freeifaddrs(addrs);

    if (0 != pthread_mutex_init(&list_mutex, NULL)) {
        perror("init list_mutex");
        exit(1);
    }

    clients_list = NULL;

    printf("Address: %s, Port: %s\nserver: waiting for connections...\n", inet_ntoa(pAddr->sin_addr), PORT);
    fflush(stdout);
    run_server(server_fd);

    if (pthread_mutex_destroy(&list_mutex)) {
        perror("destroy list_mutex");
        exit(1);
    }

    return 0;
}
