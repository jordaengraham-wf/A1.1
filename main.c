#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

/*void exec(char** word_list, int word_count){
    char** args;	// Arguments accompanying the command
    char* cmd;		// Command to execute
    int* pipe_indexes = (int *) malloc(word_count * sizeof(int));
    int pipe_count = 0;
    int i, j, k, return_value;

    for(i = 0; i < word_count; i++) {
        printf("Word: %s\n", word_list[i]);
        if (strcmp(word_list[i], "|") == 0){
            pipe_indexes[pipe_count] = i;
            pipe_count++;
        }
    }

    for (j = 0; j < pipe_count; j++)
        printf("pipe index: %i\n", pipe_indexes[j]);

    cmd = word_list[0];
    printf("CMD: %s\n", cmd);
    for (k = 1; k < word_count; k++) {
        printf("Word: %s\n", word_list[k]);
        args[k -1] = word_list[k];
        printf("Arg: %s\n", args[k -1]);
    }

    return_value = execvp(cmd, args);
    printf("Result: %i\n", return_value);


}
// compile code with (-g enables gdb debugging)
//gcc -Wall -pedantic -g -o main main.c */


int odd_shell(){

    /* char c = '\0';
    char *word = (char *) malloc(128 * sizeof(char));
    char** word_list = (char **) malloc(128 * sizeof(sizeof(char)));
    int count = 0;
    int word_length= 0;

    printf("osh> ");
    while(c != EOF) {
        c = getchar();
        switch(c) {
            case '\n': // parse and execute.
                // add last word to list
                word_list[count] = word;
                count++;
                if (strcmp(word_list[0], "exit") == 0)
                    return 0;
                exec(word_list, count);
                count = 0;
                word_length=0;
                printf("osh> ");
                break;
            case ' ':
                word_list[count] = word;
                count++;
                word_length=0;
                break;
            default:
                asprintf(&word, "%s%c", word, c);
                word[word_length] = c;
                word_length++;
                break;
        }
    }
    exit(EXIT_SUCCESS);*/
    
    size_t max_str_length = 128; /* max length of command typed after osh prompt */
    int max_num_args = 64; /* max number of words types after osh prompt */
    
    // Continue prompting until user types "exit"
    while(1){
    	printf("osh> ");
    	
    	// Get command line input
    	char* input_str = ( char* ) malloc( max_str_length * sizeof(char) );
    	size_t nchar_read = getline( &input_str, &max_str_length, stdin );
    	    	   	
    	// Check if command was an exit message
    	if(strcmp( input_str, "exit\n" ) == 0){
    		return EXIT_SUCCESS;
    	}
    	
    	// Check for getline() error
    	if( -1 == nchar_read ){
    		return EXIT_FAILURE;
    	}
    	
    	// Delete /n character at end of line
    	size_t length = (strlen(input_str) -1);
    	input_str[length] = '\0';
    	
    	// Get all words from command line into an array of words
		char* cmd_args = strtok (input_str, " ");
		int i = 0;
		char* wordArray[max_num_args];
		while((cmd_args != NULL) && (i < max_num_args))
		{
			wordArray[i] = malloc(strlen(cmd_args) + 1);
			strcpy(wordArray[i], cmd_args);
			cmd_args = strtok(NULL, " ");
			i += 1;
		}	
		
		// ** TEST CODE ** to test the that array saved correctly:    
    	//i -= 1; // Decrement i to the highest index number
    	//printf("The words in reverse order are:\n");
    	//for ( ; i > -1 ; i--){
    	//	printf("---%s----\n", wordArray[i]);
    	//}
    	
    	int rc = fork();
    	if ( -1 == rc ) {
    		printf("Error in forking.");
    		return EXIT_FAILURE;
    	}
    	else if ( 0 == rc ) { // Child process to execute
    		execvp(wordArray[0], wordArray);
    	}
    	else { //Parent process waits for child to complete
    		wait(NULL);
    	}
    	
    	// Free allocated memory
    	free (input_str);
    	i -= 1; // Decrement i to the highest index number
    	for( ; i > -1; i--){
    		free (wordArray[i]);
    	}
    }

    
    // Return because error has occurred if this
    // code has been reached.
    return EXIT_FAILURE;   
}

int main(int argc, char* argv[]) {
    return odd_shell();
}



