// Phot Koseekrainiramon (z5387411)
// on 25/07/2022

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *input_stream = fopen(argv[1], "r");
  if (input_stream == NULL) {
    perror(argv[1]);
    return 1;
  }
  int i = 0;
  int c = fgetc(input_stream);
  int array
  while (c != EOF) {
    printf("byte %4d: %3d 0x%02x", i, c, c);
    if (c > 31 && c < 128) {
      printf(" '%c'", c);
    }
    printf("\n");
    c = fgetc(input_stream);
    if (isprint() == 0) {

    }
    i++;
  }

  int array;
  int i = 0;
  while ((ch[i] = ))

  return 0;
}