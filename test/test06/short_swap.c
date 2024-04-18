// Phot Koseekrainiramon (z5387411)
// on 13/07/2022
// Swap bytes of a short

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

// given uint16_t value return the value with its bytes swapped
uint16_t short_swap(uint16_t value) {
    return (value << 8) | (value >> 8);
}
