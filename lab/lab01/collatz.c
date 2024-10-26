// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX6
// on 02/06/2022
// A C program printing collatz chain from integer as a command line arguments.

#include <stdio.h>
#include <stdlib.h>

void collatz(int num) {
    if (num <= 1) {
        return;
    }
    if (num % 2 == 0) {
        num /= 2;
    } else {
        num = (num * 3) + 1;
    }
    printf("%d\n", num);
    collatz(num);
}

int main(int argc, char **argv)
{
    int num = atoi(argv[1]);
    printf("%d\n", num);
    collatz(num);
    
    return 0;
}
