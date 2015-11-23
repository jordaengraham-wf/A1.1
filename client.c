/* CMPT 332 - Fall 2015
 * Assignment 4, Question 1
 *
 * Jordaen Graham - jhg257
 * Jennifer Rospad - jlr247
 *
 * File: client.c 
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <netdb.h>
#include "server.h"
#include <arpa/inet.h>
#include <pthread.h>

int loop, failure=0;

char *recvMessage(int socket_fd){
    char *buf = malloc(MAXDATASIZE * sizeof(char));
    ssize_t numbytes = -1;
    if ((numbytes = recv(socket_fd, buf, MAXDATASIZE-1, 0)) == -1) {
        perror("recv");
        exit(1);
    } else if (numbytes == 0)
        buf = "abort";
    else
        buf[numbytes] = '\0';
    return buf;
}

void sendMessage(int socket_fd, char *message) {
    if(send(socket_fd, message, strlen(message), 0) == -1)
        perror("sending message");
}

void *reading_func(void *args){
    int *ptr_socket_fd = (int*) args;
    int socket_fd =  *ptr_socket_fd;
    char *buf;

    while(loop){
        buf = recvMessage(socket_fd);
        if (strcmp(buf, "abort") == 0) {
            failure = 1;
            perror("Server went away");
            break;
        }
        printf("%s\n", buf);
    }
    pthread_exit(NULL);
}

int run_client(int socket_fd){
    char *buf = malloc(MAXDATASIZE * sizeof(char)), *message = malloc(MAXDATASIZE * sizeof(char));
    size_t end;
    pthread_t reading_thread;

    // allocate space for the client_thread
    reading_thread = (pthread_t) malloc(sizeof(pthread_t));
    if (reading_thread == 0){
        perror("create thread");
        return -1;
    }

    // Create and start thread
    printf("Create thread for socket: %d\n", socket_fd);
    if (pthread_create(&reading_thread, NULL, reading_func, &socket_fd) == -1){
        perror("start pthread");
        return -1;
    }

    loop = 1;
    while(!failure){


        buf = fgets(buf, MAXDATASIZE-2, stdin);
        end = strlen(buf) - 1;
        if (buf[end] == '\n')
            buf[end] = '\0';
        snprintf(message, MAXDATASIZE, "/%s", buf);
        sendMessage(socket_fd, message);
            if(strcmp(buf, "quit") == 0)
                break;
    }

    loop = 0;
    fflush(stdout);

    // Join thread
    if (pthread_join(reading_thread, NULL) == -1){
        perror("join pthread");
        return -1;
    }
    close(socket_fd);
    return 0;
}

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa)  {
    if (sa->sa_family == AF_INET)
        return &(((struct sockaddr_in*)sa)->sin_addr);

    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

int main(int argc, char *argv[]) {
    int socket_fd = -1, rv;
    char s[INET6_ADDRSTRLEN], *host;
    struct addrinfo hints, *servinfo, *p;

    if (argc != 2)
        host = "localhost";
    else
        host = argv[1];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if ((rv = getaddrinfo(host, PORT, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and connect to the first we can
    for (p = servinfo; p != NULL; p = p->ai_next) {
        if ((socket_fd = socket(p->ai_family, p->ai_socktype,
                                p->ai_protocol)) == -1) {
            perror("client: socket");
            continue;
        }

        if (connect(socket_fd, p->ai_addr, p->ai_addrlen) == -1) {
            close(socket_fd);
            perror("client: connect");
            continue;
        }

        break;
    }

    if (p == NULL) {
        perror("client: failed to connect");
        exit(2);
    }

    inet_ntop(p->ai_family, get_in_addr((struct sockaddr *) p->ai_addr),
              s, sizeof s);
    printf("client: connecting to %s\n", s);

    freeaddrinfo(servinfo); // all done with this structure

    return run_client(socket_fd);
}

