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
  int count = 0;
  int c;
  while ((c = fgetc(input_stream)) != EOF) {
    if (c == 'a' || c == 'e' || c == 'i' || c == 'o' ||
        c == 'u' || c == 'A' || c == 'E' || c == 'I' ||
        c == 'O' || c == 'U') {
      count++;
    }
  }
  printf("%d\n", count);
  return 0;
}