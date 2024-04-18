// Phot Koseekrainiramon (z5387411)
// on 17/07/2022

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char *argv[]) {
  FILE *output_stream = fopen(argv[1], "w");
  if (output_stream == NULL) {
    perror(argv[1]);
    return 1;
  }
  int start = atoi(argv[2]);
  int end = atoi(argv[3]);
  if (start < 0) {
    perror(argv[2]);
    return 1;
  }
  if (end > 65535) {
    perror(argv[3]);
    return 1;
  }
  for (int i = start; i <= end; i++) {
    uint16_t num = (uint16_t)i;
    uint8_t byte0 = (num >> 8) & 0xff;
    uint8_t byte1 = (num >> 0) & 0xff;
    fputc(byte0, output_stream);
    fputc(byte1, output_stream);
  }

  return 0;
}