// Phot Koseekrainiramon (z5387411)
// on 17/07/2022
#include "float_exp.h"

#define EXPONENT_HIGH_BIT  30
#define EXPONENT_LOW_BIT   23

// given the 32 bits of a float return the exponent
uint32_t float_exp(uint32_t f) {
    uint32_t mask = (((uint32_t)1) << (EXPONENT_HIGH_BIT - EXPONENT_LOW_BIT + 1)) - 1;
    return (f >> EXPONENT_LOW_BIT) & mask;
}
