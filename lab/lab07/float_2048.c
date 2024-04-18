// Phot Koseekrainiramon (z5387411)
// on 17/07/2022
// Multiply a float by 2048 using bit operations only

#include <stdio.h>
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

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -inf, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    uint32_t sign_bit = extract_bit_range(f, SIGN_BIT, SIGN_BIT);
    uint32_t fraction_bits = extract_bit_range(f, FRACTION_HIGH_BIT, FRACTION_LOW_BIT);
    uint32_t exponent_bits = extract_bit_range(f, EXPONENT_HIGH_BIT, EXPONENT_LOW_BIT);
    float_components_t x;
    x.sign = sign_bit;
    x.fraction = fraction_bits;
    x.exponent = exponent_bits;
    if (is_nan(x) || is_positive_infinity(x) || is_negative_infinity(x) || is_zero(x)) {
        return f;
    }
    if (exponent_bits >= 0xf4) {
        return (sign_bit << 31) | (0xff << 23);
    }
    exponent_bits += 11;
    uint32_t new = (sign_bit << 31) | (exponent_bits << 23) | fraction_bits;
    return new;
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

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    if (f.exponent == EXPONENT_INF_NAN) {
        if (f.fraction == 0 && f.sign == 0) {
            return 1;
        }
    }
    return 0;
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    if (f.exponent == EXPONENT_INF_NAN) {
        if (f.fraction == 0 && f.sign  == 1) {
            return 1;
        }
    }
    return 0;
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    if (f.exponent == 0) {
        return 1;
    }
    return 0;
}
