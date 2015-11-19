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
#include <sys/wait.h>
#include <signal.h>
#include "server.h"

#define BACKLOG 10     // how many pending connections queue will hold




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

int get_connections(int server_fd) {
    int client_fd; //return
    socklen_t sin_size;
    char s[INET6_ADDRSTRLEN];
    struct sockaddr_storage their_addr; // connector's address information

    sin_size = sizeof their_addr;
    client_fd = accept(server_fd, (struct sockaddr *)&their_addr, &sin_size);
    if (client_fd == -1) {
        perror("accept");
        return -1;
    }

    inet_ntop(their_addr.ss_family, get_in_addr((struct sockaddr *)&their_addr), s, sizeof s);
    printf("server: got connection from %s\n", s);

    return client_fd;
}

char *recvMessage(int client_fd){
    ssize_t numbytes = -1;
    char *buf = malloc(MAXDATASIZE * sizeof(char));

    if ((numbytes = recv(client_fd, buf, MAXDATASIZE-1, 0)) == -1) {
        perror("recv");
        exit(1);
    }
    buf[numbytes] = '\0';
    return buf;
}

void sendMessage(int client_fd, char *message) {
    if (send(client_fd, message, strlen(message), 0) == -1)
        perror("send");
}

void do_shit(int server_fd) {

    while(1) {  // main accept() loop
        int client_fd;
        char *buf;



        client_fd = get_connections(server_fd);
        if (client_fd == -1) {
            continue;
        }



        while(1) {
            buf = recvMessage(client_fd);
            printf("Recieved String: %s\n", buf);
            if (strcmp(buf, "quit") == 0)
                break;
        }


        if (!fork()) { // this is the child process
            sendMessage(client_fd, "Hello, world!");

            close(server_fd); // child doesn't need the listener
            close(client_fd);
            exit(0);
        }
        close(client_fd);  // parent doesn't need this
    }
}

int main(void) {
    int server_fd = -1;  // listen for connection on server_fd, communicates on client_fd
    struct addrinfo hints, *servinfo, *p;
    struct sigaction sa;
    int yes = 1;
    int rv;

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
        fprintf(stderr, "server: failed to bind\n");
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

    printf("server: waiting for connections...\n");

    do_shit(server_fd);
    return 0;
}


