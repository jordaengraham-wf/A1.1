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
    
    // Allocate space to save input from command line
    char* input_str;
    size_t max_length = 128;
    size_t nchar_read;
    
    // Continue prompting until user types "exit"
    while(1){
    	printf("osh> ");
    	input_str = ( char* ) malloc( max_length * sizeof(char) );
    	nchar_read = getline( &input_str, &max_length, stdin );
    	    	   	
    	// Check if stdin was an exit message
    	if(strcmp( input_str, "exit\n" ) == 0){
    		return EXIT_SUCCESS;
    	}
    	
    	// Do work with the input 
    	// *** HAVING TROUBLE FIGURING OUT STRTOK: It only takes in
    	// the first word in the command line!   	
		char* cmd = strtok (input_str, " ");
		//execvp( cmd, &input_str );
		printf("The cmd is: %s and the args are:\n", cmd);
		char* next_arg = strtok(input_str, " \n");
		while(next_arg != NULL)
		{
			printf("%s\n",next_arg);
			next_arg = strtok(NULL, " ,.\n");
		}
		
    }
    
    // Return because error has occurred if this
    // code has been reached.
    return EXIT_FAILURE;   
}

int main(int argc, char* argv[]) {
    return odd_shell();
}



