// Phot Koseekrainiramon (z5387411)
// COMP1521 lab01 EX5
// on 30/05/2022
// A C program analysing stats of command line arguments.

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {

    if (argc == 1) {
        printf("Usage: %s NUMBER [NUMBER ...]\n", argv[0]);
    } else {
        int min = atoi(argv[1]); 
        int max = atoi(argv[1]);
        int sum = 0;
        int prod = 1;
        for (int i = 1; i < argc; i++) {
            int integer = atoi(argv[i]);
            if (integer < min) {
                min = integer;
            }
            if (integer > max) {
                max = integer;
            }
            sum += integer;
            prod *= integer;
        }
        int mean = sum / (argc - 1);
        printf("MIN:  %d\n", min);
        printf("MAX:  %d\n", max);
        printf("SUM:  %d\n", sum);
        printf("PROD: %d\n", prod);
        printf("MEAN: %d\n", mean);
    }
    return 0;
}
