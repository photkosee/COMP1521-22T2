// Phot Koseekrainiramon (z5387411)
// on 17/07/2022
#include "bit_rotate.h"

uint16_t extract_bit_range(uint16_t value, int high, int low);

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    if (n_rotations >= 0) {
        n_rotations %= 16;
        uint32_t mask = extract_bit_range(bits, 16, (16 - n_rotations));
        return (bits << n_rotations) | mask;
    } else {
        n_rotations *= -1;
        n_rotations %= 16;
        uint32_t mask = extract_bit_range(bits, n_rotations, 0);
        return (bits >> n_rotations) | (mask << (16 - n_rotations));
    }
}

// extract a range of bits from a value
uint16_t extract_bit_range(uint16_t value, int high, int low) {
    uint16_t mask = (((uint16_t)1) << (high - low + 1)) - 1;
    return (value >> low) & mask;
}
