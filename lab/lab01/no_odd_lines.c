// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX3
// on 30/05/2022
// A C program printing only lines with an even number of characters.

#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 1024

char *remove_white_spaces(char *str) {
    int i = 0;
    int j = 0;
    while (str[i]) {
        if (str[i] != ' ') {
            str[j++] = str[i];
        }
        i++;
    }
    return str;
}

int main(void) {
    char word[MAX_LENGTH];
    char word_spaces[MAX_LENGTH];
    while (fgets(word, MAX_LENGTH, stdin) != NULL) {
        strcpy(word_spaces, word);
        int word_length = strlen(remove_white_spaces(word));
        if (word_length % 2 == 0) {
            char *pStr = word_spaces;
            fputs(pStr, stdout);
        }
    }

    return 0;
}
