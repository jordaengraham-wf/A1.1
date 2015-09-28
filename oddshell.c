#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "unistd.h"

int odd_shell(){    
    size_t max_str_length = 128; /* max length of command typed after osh prompt */
    int max_num_args = 64; /* max number of words types after osh prompt */
    
    // Continue prompting until user types "exit"
    while(1){
    	printf("osh> (PID: %d)", getpid());
    	
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
    	
    	int rc = fork();
    	if ( -1 == rc ) {
    		printf("Error in forking.");
    		return EXIT_FAILURE;
    	}
    	else if ( 0 == rc ) { // Child process to execute
    		printf("Im a child! (PID: %d)\n", getpid());
    		execvp(wordArray[0], wordArray);
    	}
    	else { //Parent process waits for child to complete
    		wait(NULL);
    		printf("I'm the parent! (PID: %d)\n", getpid());
    	}
    	
    	// Free allocated memory
    	free (input_str);
    	i = i - 1; // Decrement i to the highest index number
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



