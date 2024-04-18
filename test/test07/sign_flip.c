// Phot Koseekrainiramon (z5387411)
// on 17/07/2022
#include "sign_flip.h"

#define N_BITS             32
#define SIGN_BIT           31
#define EXPONENT_HIGH_BIT  30
#define EXPONENT_LOW_BIT   23
#define FRACTION_HIGH_BIT  22
#define FRACTION_LOW_BIT    0

#define EXPONENT_OFFSET   127
#define EXPONENT_INF_NAN  255

uint32_t extract_bit_range(uint32_t value, int high, int low);

// given the 32 bits of a float return it with its sign flipped
uint32_t sign_flip(uint32_t f) {
    uint32_t sign_bit = extract_bit_range(f, SIGN_BIT, SIGN_BIT);
    uint32_t fraction_bits = extract_bit_range(f, FRACTION_HIGH_BIT, FRACTION_LOW_BIT);
    uint32_t exponent_bits = extract_bit_range(f, EXPONENT_HIGH_BIT, EXPONENT_LOW_BIT);

    if (sign_bit == 1) {
        return (f & (uint32_t)0) | (exponent_bits << 23) | fraction_bits;
    } else {
        return f | (((uint32_t)1) << 31);
    }
}

// extract a range of bits from a value
uint32_t extract_bit_range(uint32_t value, int high, int low) {
    uint32_t mask = (((uint32_t)1) << (high - low + 1)) - 1;
    return (value >> low) & mask;
}
