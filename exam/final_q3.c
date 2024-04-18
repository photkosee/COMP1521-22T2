#include <stdint.h>

/**
 * Return the provided value but with its bytes reversed.
 *
 * For example, final_q3(0x12345678) => 0x78563412
 * 
 * *Note* that your task is to
 * reverse the order of *bytes*,
 * *not* to reverse the order of bits.
**/

int final_q3(uint32_t value) {
    return ((value & 0xFF000000) >> 24) | ((value & 0x00FF0000) >> 8) |
            ((value & 0x0000FF00) << 8) | ((value & 0x000000FF) << 24);
}
