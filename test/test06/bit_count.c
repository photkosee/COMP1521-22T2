// Phot Koseekrainiramon (z5387411)
// on 13/07/2022
// count bits in a uint64_t

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return how many 1 bits value contains
int bit_count(uint64_t value) {
    uint64_t mask = value;
    int count = 0;
    while (mask != 0) {
        if ((mask & 0x1) == 0x1) {
            count++;
        }
        mask >>= 1;
    }

    return count;
}
