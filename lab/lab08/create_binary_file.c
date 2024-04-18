// Phot Koseekrainiramon (z5387411)
// on 17/07/2022

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *output_stream = fopen(argv[1], "w");
  if (output_stream == NULL) {
    perror(argv[1]);
    return 1;
  }
  
  int i = 2;
  while (argv[i] != NULL) {
    int binary = atoi(argv[i]);
    fputc(binary, output_stream);
    i++;
  }

  return 0;
}