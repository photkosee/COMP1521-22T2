// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX4
// on 30/05/2022
// A C program pretty printing 0 or more line arguments.

#include <stdio.h>

int main(int argc, char **argv) {

    printf("Program name: %s\n", argv[0]);
    if (argc == 1) {       
        printf("There are no other arguments\n");
    } else {
        printf("There are %d arguments:\n", (argc - 1));
        for (int i = 1; i < argc; i++) {
            printf("	Argument %d is \"%s\"\n", i, argv[i]);
        }
    }
    return 0;
}
