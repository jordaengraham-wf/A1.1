#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

int execute_pipes(char **wordArray, int wordArray_length){
    int j, childPID, return_value;

    childPID = fork();
    if ( -1 == childPID ) {
        fprintf(stderr, "Error in forking.\n");
        exit(1);
    }
    else if ( 0 == childPID ) { /* Child process to execute */
        printf("Im a child! (PID: %d)\n", getpid());
        printf("CMD: %s, Args: ", wordArray[0]);
        for(j = 1; j < wordArray_length; j++ )
            printf("%s, ", wordArray[j]);
        printf("\n");

        if(execvp(wordArray[0], wordArray) == -1){
            fprintf(stderr, "Execution failed: CMD: %s, Args: ", wordArray[0]);
            for(j = 1; j < wordArray_length -1; j++)
                fprintf(stderr, "%s, ", wordArray[j]);
            fprintf(stderr, "%s\n", wordArray[j]);
            fprintf(stderr, "Child %d exited\n", getpid());
            exit(1);
        }
    }
    else { /* Parent process waits for child to complete */
        wait(NULL);
        printf("I'm the Parent! (PID: %d)\n", getpid());
    }
}


int odd_shell(){
    char *input_str, *cmd_args, **wordArray, **pipesArray;
    size_t max_str_length = 128; /* max length of command typed after osh prompt */
    ssize_t nchar_read, length;
    int cmd_index, pipes_count, wordArray_length = 0, max_num_args = 64; /* max number of words types after osh prompt */
    /* This will be the unchanging first node */
    struct LinkedList *root;
    /* This will point to each node as it traverses the list */
    struct LinkedList *cursor;


    /* Continue prompting until user types "exit" */
    while(1){

        /* Now root points to a node struct */
        root = (struct LinkedList *) malloc( sizeof(struct LinkedList) );
        /* The node root points to has its next pointer equal to a null pointer set */
        root->length = 0;
        root->next = NULL;
        root->wordArray = NULL;
        cursor = root;

        printf("(PID: %d) osh> ", getpid());
        fflush(stdout);
    	/* Get command line input */
    	input_str = ( char* ) malloc( max_str_length * sizeof(char) );
    	nchar_read = getline( &input_str, &max_str_length, stdin );

    	/* Check for getline() error */
    	if( -1 == nchar_read ){
    		return EXIT_FAILURE;
    	}

    	/* Delete /n character at end of line */
    	length = (strlen(input_str) -1);
    	input_str[length] = '\0';

        /* get pipes */
        cmd_args = strtok (input_str, "|");
        pipesArray = (char **) malloc(max_num_args * sizeof(char));
        pipes_count = 0;

        while((cmd_args != NULL) && (pipes_count < max_num_args))
        {
            pipesArray[pipes_count] = malloc(strlen(cmd_args) + 1);
            strcpy(pipesArray[pipes_count], cmd_args);
            cmd_args = strtok(NULL, "|");
            pipes_count += 1;
        }

        for (int k = pipes_count-1; k >= 0; k--) {
            cmd_args = strtok (pipesArray[k], " ");
            wordArray = (char **) malloc(max_num_args * sizeof(char));
            wordArray_length = 0;

            while((cmd_args != NULL) && (wordArray_length < max_num_args))
            {
                wordArray[wordArray_length] = malloc(strlen(cmd_args) + 1);
                strcpy(wordArray[wordArray_length], cmd_args);
                cmd_args = strtok(NULL, " ");
                wordArray_length += 1;
            }
            if (wordArray_length == 0) /* handle blank line entered */
                continue;

            /* Check if command was an exit message */
            if(strcmp( wordArray[0], "exit" ) == 0){
                return EXIT_SUCCESS;
            }

//            int pipefd[2];
//            pipe(pipefd);
//            dup2(pipefd[0], 0)

//            dup2(pipefd[1], 1)
            execute_pipes(wordArray, wordArray_length);

            for( wordArray_length = wordArray_length - 1; wordArray_length > -1; wordArray_length--){
                free (wordArray[wordArray_length]);
            }
        }

    	/* Free allocated memory */
    	free (input_str);
        /* Decrement i to the highest index number */

    	for( pipes_count = pipes_count - 1; pipes_count > -1; pipes_count--){
    		free (pipesArray[pipes_count]);
    	}
    }

    /* Return because error has occurred if this
       code has been reached. */
    return EXIT_FAILURE;   
}

int main(int argc, char* argv[]) {
    return odd_shell();
}



