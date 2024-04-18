// Phot Koseekrainiramon (z5387411)
// on 17/07/2022
// Compare 2 floats using bit operations only

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

#define N_BITS             32
#define SIGN_BIT           31
#define EXPONENT_HIGH_BIT  30
#define EXPONENT_LOW_BIT   23
#define FRACTION_HIGH_BIT  22
#define FRACTION_LOW_BIT    0

#define EXPONENT_OFFSET   127
#define EXPONENT_INF_NAN  255

uint32_t extract_bit_range(uint32_t value, int high, int low);

// float_less is given the bits of 2 floats bits1, bits2 as a uint32_t
// and returns 1 if bits1 < bits2, 0 otherwise
// 0 is return if bits1 or bits2 is Nan
// only bit operations and integer comparisons are used
uint32_t float_less(uint32_t bits1, uint32_t bits2) {
    uint32_t sign_bit = extract_bit_range(bits1, SIGN_BIT, SIGN_BIT);
    uint32_t fraction_bits = extract_bit_range(bits1, FRACTION_HIGH_BIT, FRACTION_LOW_BIT);
    uint32_t exponent_bits = extract_bit_range(bits1, EXPONENT_HIGH_BIT, EXPONENT_LOW_BIT);
    float_components_t bit1;
    bit1.sign = sign_bit;
    bit1.fraction = fraction_bits;
    bit1.exponent = exponent_bits;

    uint32_t sign_bit2 = extract_bit_range(bits2, SIGN_BIT, SIGN_BIT);
    uint32_t fraction_bits2 = extract_bit_range(bits2, FRACTION_HIGH_BIT, FRACTION_LOW_BIT);
    uint32_t exponent_bits2 = extract_bit_range(bits2, EXPONENT_HIGH_BIT, EXPONENT_LOW_BIT);
    float_components_t bit2;
    bit2.sign = sign_bit2;
    bit2.fraction = fraction_bits2;
    bit2.exponent = exponent_bits2;
    if (is_nan(bit2) || is_nan(bit1) || sign_bit2 > sign_bit) {
        return 0;
    }

    if (sign_bit2 < sign_bit) {
        return 1;
    } else if (sign_bit == 0) {
        if (exponent_bits2 < exponent_bits) {
            return 0;
        } else if (exponent_bits2 == exponent_bits) {
            if (fraction_bits2 < fraction_bits || fraction_bits2 == fraction_bits) {
                return 0;
            }
        }
    } else if (sign_bit == 1) {
        if (exponent_bits2 > exponent_bits) {
            return 0;
        } else if (exponent_bits2 == exponent_bits) {
            if (fraction_bits2 > fraction_bits || fraction_bits2 == fraction_bits) {
                return 0;
            }
        }
    }

    return 1;
}

// extract a range of bits from a value
uint32_t extract_bit_range(uint32_t value, int high, int low) {
    uint32_t mask = (((uint32_t)1) << (high - low + 1)) - 1;
    return (value >> low) & mask;
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    if (f.exponent == EXPONENT_INF_NAN) {
        if (f.fraction == 0) {
            return 0;
        } else {
            return 1;
        }
    }
    return 0;
}
