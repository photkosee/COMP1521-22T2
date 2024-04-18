// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX7
// on 02/06/2022
// A C program printing corresponding fibonacci number from given input.

#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 30

int fibonacci(int num) {
    if (num <= 1) {
        return num;
    } 
    return fibonacci(num - 1) + fibonacci(num - 2);
}


int main(void) {
    int num;
    while (scanf("%d", &num) != EOF) {
        printf("%d\n", fibonacci(num));
    }
    return 0;
}
