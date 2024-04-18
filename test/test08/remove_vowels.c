// Phot Koseekrainiramon (z5387411)
// on 25/07/2022

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *output_stream = fopen(argv[1], "r");
  if (output_stream == NULL) {
    perror(argv[1]);
    return 1;
  }
  FILE *input_stream = fopen(argv[2], "w");
  if (input_stream == NULL) {
    perror(argv[2]);
    return 1;
  }
  
  int c;
  while ((c = fgetc(output_stream)) != EOF) {
    if (!(c == 'a' || c == 'e' || c == 'i' || c == 'o' ||
        c == 'u' || c == 'A' || c == 'E' || c == 'I' ||
        c == 'O' || c == 'U')) {
      fputc(c, input_stream);
    }
  }
  return 0;
}