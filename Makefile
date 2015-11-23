# CMPT 332 - Fall 2015
# Assignment 3, Question 3
#
# Jordaen Graham - jhg257
# Jennifer Rospad - jlr247
#
# File: Makefile

CC := gcc
CCFLAGS := -Wall -Wextra -pedantic -pthread -g

all: clean Server Client

clean:
	@rm *.o* &> /dev/null || true
	@rm *~ &> /dev/null || true
	@rm Client &> /dev/null || true
	@rm Server &> /dev/null || true

run_server: Server
	@./Server

run_client: Client
	@./Client

Server: server.c server.h
	$(CC) $(CCFLAGS) -o Server server.c


Client: client.c server.h
	$(CC) $(CCFLAGS) -o Client client.c


