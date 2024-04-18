// COMP1521 22T2 ... final exam, question 1

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int count_zero_bits(uint32_t x) {
	int count = 0;
	for (int i = 0; i < 8 * sizeof (uint32_t); i++) {
		uint32_t mask = 1u << i;
		if ((~x & mask) != 0) {
			count++;
		}
	}
	return count;
}
