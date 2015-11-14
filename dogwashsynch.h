/* CMPT 332 - Fall 2015
 * Assignment 3, Question 3
 *
 * Jordaen Graham - jhg257
 * Jennifer Rospad - jlr247
 *
 * File: dogwashsynch.h */

#ifndef DOGWASHSYNCH_H
#define DOGWASHSYNCH_H

typedef enum {DA, DB, DO} dogtype;

int dogwash_init(int);
int newdog(dogtype);
int dogdone(dogtype);
int dogwash_done();

#endif /*DOGWASHSYNCH_H*/

