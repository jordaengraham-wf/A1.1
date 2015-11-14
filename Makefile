# CMPT 332 - Fall 2015
# Assignment 3, Question 3
#
# Jordaen Graham - jhg257
# Jennifer Rospad - jlr247
#
# File: Makefile

CC := gcc
CCFLAGS := -Wall -Wextra -pthread -g

all: clean Test_Sem

clean:
	@rm *.o* &> /dev/null || true
	@rm *~ &> /dev/null || true
	@rm Test* &> /dev/null || true

Test_Sem: dogwashsynch.c dogwashsynch.h test_sem.c
	$(CC) $(CCFLAGS) -o Test_Sem dogwashsynch.c test_sem.c
	
