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

//#include <errno.h>
//#include <sys/types.h>
//#include <netinet/in.h>
//#include <sys/socket.h>


char *recvMessage(int socket_fd){
    char *buf = malloc(MAXDATASIZE * sizeof(char));
    ssize_t numbytes = -1;
    if ((numbytes = recv(socket_fd, buf, MAXDATASIZE-1, 0)) == -1) {
        perror("recv");
        exit(1);
    }

    buf[numbytes] = '\0';
    return buf;
}

void sendMessage(int socket_fd, char *message) {
    if(send(socket_fd, message, strlen(message), 0) == -1) {
        fprintf(stderr, "error sending the string: %s\n", message);
    }
}

void do_other_shit(int socket_fd){
    char *buf = malloc(MAXDATASIZE * sizeof(char));
    size_t end;

    while(1){
        printf("Enter a string: ");
        buf = fgets(buf, MAXDATASIZE-1, stdin);
        end = strlen(buf) - 1;
        if (buf[end] == '\n')
            buf[end] = '\0';
        sendMessage(socket_fd, buf);
            if(strcmp(buf, "quit") == 0)
                break;
    }


    buf = recvMessage(socket_fd);
    printf("Client: received '%s'\n", buf);

    close(socket_fd);
}

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa)  {
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }

    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

int main(int argc, char *argv[]) {
    int socket_fd, rv;
    char s[INET6_ADDRSTRLEN], *host;
    struct addrinfo hints, *servinfo, *p;

    /* todo */
    if (argc != 2) {
        host = "localhost";
    } else {
        host = argv[1];
    }

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
        fprintf(stderr, "client: failed to connect\n");
        return 2;
    }

    inet_ntop(p->ai_family, get_in_addr((struct sockaddr *) p->ai_addr),
              s, sizeof s);
    printf("client: connecting to %s\n", s);

    freeaddrinfo(servinfo); // all done with this structure






    do_other_shit(socket_fd);
    return 0;
}

