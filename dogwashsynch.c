/* CMPT 332 - Fall 2015
 * Assignment 3, Question 3
 *
 * Jordaen Graham - jhg257
 * Jennifer Rospad - jlr247
 *
 * File dogwashsynch.c */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "dogwashsynch.h"
#include <semaphore.h>
#include <pthread.h>

/* DA_sem: semaphore to synchronize the number of DA dogs
 * DB_sem: semaphore to synchronize the number of DB dogs
 * Bays_sem: sempaphore to ensure mutual exclusion of DA and DB dogs in bays
 * Bay_avail_sem: semaphore to ensure mutual exclusion on num bays available
 * Wait_sem: sempaphore for threads to wait on when they cannot enter a bay */
sem_t DA_sem, DB_sem, Bays_sem, Bays_avail_sem, Wait_sem;

/* DA_count: pointer to the number of DA dogs currently being washed
 * DB_count: pointer to the number of DB dogs currently being washed */
int *DA_count, *DB_count;


/* Start routine for a DA dog */
void DA_start(){
    /* Wait until the bays are DB dog free and increment number of DA dogs */
    sem_wait(&Wait_sem);
    sem_wait(&DA_sem);
    *DA_count = *DA_count + 1;
    if (*DA_count == 1){
        sem_wait(&Bays_sem);
        printf("======= DA dogs in the bay -- no DB dogs may enter =======\n");
    }
    sem_post(&Wait_sem);
    sem_post(&DA_sem);
}

/* Start routine for a DB dog */
void DB_start(){
    /* Wait until the bays are DA dog free and increment the number of DB dogs */
    sem_wait(&Wait_sem);
    sem_wait(&DB_sem);
    *DB_count = *DB_count + 1;
    if (*DB_count == 1){
        sem_wait(&Bays_sem);
        printf("======= DB dogs in the bay -- no DA dogs may enter =======\n");
    }
    sem_post(&Wait_sem);
    sem_post(&DB_sem);
}

/* End routine for a DA dog */
void DA_done(){
    /* Decrement number of DA dogs and signal that DB dogs can run if
     * this is the last DA dog in the dogwash */
    sem_wait(&DA_sem);
    *DA_count = *DA_count - 1;
    if (*DA_count == 0){
        printf("======= DA dogs done -- DB dogs may now enter =======\n");
        sem_post(&Bays_sem);
    }
    sem_post(&DA_sem);
}

/* End routine for a DB dog */
void DB_done(){
    /* Decrement number of DB dogs and signal that DA dogs can run if
     * this is the last DB dog in the dogwash */
    sem_wait(&DB_sem);
    *DB_count = *DB_count - 1;
    if (*DB_count == 0){
        printf("======= DB dogs done -- DA dogs may now enter =======\n");
        sem_post(&Bays_sem);
    }
    sem_post(&DB_sem);
}

/* Function to initialize a dogwash system */
int dogwash_init(int numbays) {
    int rv;
    
    /* Check number of bays */
    if(0 >= numbays){
        printf("Invalid number of bays.\n");
        return -1;
    }

    /* Initialize global variables */
    DA_count = (int *)malloc(sizeof(int));
    if (0 == DA_count){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate DA_count.\n");
        return -1;
    }
    *DA_count = 0;


    DB_count = (int *)malloc(sizeof(int));
    if (0 == DB_count){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate DB_count.\n");
        return -1;
    }
    *DB_count = 0;

    /* Initialize semaphores */
    rv = sem_init(&Bays_sem, 0, 1);
    if (0 != rv){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate Bays_sem.\n");
        return -1;
    }

    rv = sem_init(&Bays_avail_sem, 0, (unsigned int) numbays);
    if (0 != rv){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate Bays_avail_sem.\n");
        return -1;
    }

    rv = sem_init(&DA_sem, 0, 1);
    if (0 != rv){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate DA_sem.\n");
        return -1;
    }

    rv = sem_init(&DB_sem, 0, 1);
    if (0 != rv){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate DB_sem.\n");
        return -1;
    }

    rv = sem_init(&Wait_sem, 0, 1);
    if (0 != rv){
        fprintf(stderr, "ERROR: Out of memory. Could not allocate Wait_sem.\n");
        return -1;
    }

    return 0;
}

/* Function to end the dogwash system */
int dogwash_done() {
    int rv;

    printf("Sem dogwash done\n");
    
    /* Free the global variables */
    free(DA_count);
    DA_count = NULL;

    free(DB_count);
    DB_count = NULL;

    /* Destroy the semaphores */
    rv = sem_destroy(&Bays_sem);
    if (0 != rv){
        fprintf(stderr, "Failed to close Bays_sem.\n");
        return -1;
    }
    rv = sem_destroy(&Bays_avail_sem);
    if (0 != rv){
        fprintf(stderr, "Failed to close Bays_avail_sem.\n");
        return -1;
    }
    rv = sem_destroy(&DA_sem);
    if (0 != rv){
        fprintf(stderr, "Failed to close DA_sem.\n");
        return -1;
    }
    rv = sem_destroy(&DB_sem);
    if (0 != rv){
        fprintf(stderr, "Failed to close DB_sem.\n");
        return -1;
    }
    rv = sem_destroy(&Wait_sem);
    if (0 != rv){
        fprintf(stderr, "Failed to close Wait_sem.\n");
        return -1;
    }

    return 0;
}


/* Initialization of dog thread for all types of dogs */
int newdog(dogtype dog){
    int value;
    printf("Dog, %s Arrived\n", DA == dog ? "A" : DB == dog ? "B" : "O");

    /* If dog is a DA or DB dog, run the specialized starting function */
    if (DA == dog) {
        DA_start();
    }
    else if (DB == dog) {
        DB_start();
    }

    /* Wait for an available bay and decrement the number of available bays */
    sem_wait(&Bays_avail_sem);
    sem_getvalue(&Bays_avail_sem, &value);
    printf("\nDog, %s washing.\nBays Remaining: %d\n\n", 
            DA == dog ? "A" : DB == dog ? "B" : "O", value);

    return 0;
}

/* Finishing function for a dog thread */
int dogdone(dogtype dog) {
    int value;
    sem_getvalue(&Bays_avail_sem, &value);

    /* Decrement the number of bays available */
    sem_post(&Bays_avail_sem);
    sem_getvalue(&Bays_avail_sem, &value);
    printf("\nFinished dog %s.\nBays avail: %d\n\n", 
            DA == dog ? "A" : DB == dog ? "B" : "O", value);

    /* If DA or DB dogtype, run the appropriate closing function */
    if ( DA == dog ){
        DA_done();
    }else if ( DB == dog ){
        DB_done();
    }

    /* End thread */
    pthread_exit(NULL);
    return 0;
}

