// Phot Koseekrainiramon (z5387411)
// on 06/07/2022
// Convert a 16-bit signed integer to a string of binary digits

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BITS 16

char *sixteen_out(int16_t value);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= INT16_MIN && l <= INT16_MAX);
        int16_t value = l;

        char *bits = sixteen_out(value);
        printf("%s\n", bits);

        free(bits);
    }

    return 0;
}

// given a signed 16 bit integer
// return a null-terminated string of 16 binary digits ('1' and '0')
// storage for string is allocated using malloc
char *sixteen_out(int16_t value) {

    char *string = malloc(17);
    int index = 0;
    int16_t tmp = value;
    int16_t mask = 1;
    mask <<= 15;
    int result;
    while (index < 16) {
        result = tmp & mask;
        if (result == 0) {
            string[index] = '0';
        } else {
            string[index] = '1';
        }
        index++;
        mask >>= 1;
    }
    string[16] = '\0';

    return string;
}

