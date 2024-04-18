// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX1
// on 31/05/2022
// A C program removing all vowels from STDIN.

#include <stdio.h>
#include <string.h>

#define VOWEL 10

int check_vowel(char vowel[VOWEL], char str);

int main(void) {
    char vowel[VOWEL] = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'};
    char str = '\0';   
    while (scanf("%c", &str) != EOF) {
        if (check_vowel(vowel, str)) {
            printf("%c", str);
        }      
    }
    return 0;
}

int check_vowel(char vowel[VOWEL], char str) {
    int j = 0;
    while (j < VOWEL) {
        if (str == vowel[j]) {
            return 0;
        }
        j++;
    }
    return 1;
}
