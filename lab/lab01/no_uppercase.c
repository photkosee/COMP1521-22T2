// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX2
// on 30/05/2022
// A C program transforming all uppercase to lowercase.

#include <stdio.h>
#include <ctype.h>

#define MAX_STRING 1000

int main(void) {
    char word[MAX_STRING];
    int c = 0;
    int i = 0;
    while ((c = getchar()) != EOF) {
        word[i] = tolower(c);
        putchar(word[i]);
        i++;
    }
    return 0;
}
