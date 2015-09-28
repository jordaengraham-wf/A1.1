#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

int odd_shell(){    
    size_t max_str_length = 128; /* max length of command typed after osh prompt */
    int max_num_args = 64; /* max number of words types after osh prompt */
    char* input_str;
    char* cmd_args;
    ssize_t nchar_read, length;
    int wordArray_length, j, rc, return_value;
    char** wordArray;

    /* Continue prompting until user types "exit" */
    while(1){
    	printf("osh> (PID: %d)", getpid());

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

    	/* Get all words from command line into an array of words */
		cmd_args = strtok (input_str, " ");
        wordArray = (char **) malloc(max_num_args * sizeof(char));
        wordArray_length = 0;

		while((cmd_args != NULL) && (wordArray_length < max_num_args))
		{
			wordArray[wordArray_length] = malloc(strlen(cmd_args) + 1);
			strcpy(wordArray[wordArray_length], cmd_args);
			cmd_args = strtok(NULL, " ");
			wordArray_length += 1;
		}

        /* Check if command was an exit message */
        if(strcmp( wordArray[0], "exit" ) == 0){
            return EXIT_SUCCESS;
        }

        /* Parse by pipes */
        

    	rc = fork();
    	if ( -1 == rc ) {
    		printf("Error in forking.\n");
    		return EXIT_FAILURE;
    	}
    	else if ( 0 == rc ) { /* Child process to execute */
    		printf("Im a child! (PID: %d)\n", getpid());
            printf("CMD: %s, Args: ", wordArray[0]);
            for(j=1; j < wordArray_length; j++ )
                printf("%s, ", wordArray[j]);
            printf("\n");
            if(execvp(wordArray[0], wordArray) == -1){
                printf("Execution failed: CMD: %s, Args: ", wordArray[0]);
                for(j=1; j< wordArray_length -1; j++)
                    printf("%s, ", wordArray[j]);
                printf("%s\n", wordArray[j]);
                printf("Child %d exited\n", getpid());
                exit(1);
    	    }
        }
    	else { /* Parent process waits for child to complete */
    		wait(NULL);
    		printf("I'm the parent! (PID: %d)\n", getpid());
    	}

    	/* Free allocated memory */
    	free (input_str);
    	wordArray_length = wordArray_length - 1; /* Decrement i to the highest index number */
    	for( ; wordArray_length > -1; wordArray_length--){
    		free (wordArray[wordArray_length]);
    	}
    }

    /* Return because error has occurred if this
       code has been reached. */
    return EXIT_FAILURE;   
}

int main(int argc, char* argv[]) {
    return odd_shell();
}



