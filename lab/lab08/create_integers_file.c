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
  int start = atoi(argv[2]);
  int end = atoi(argv[3]);
  for (int i = start; i <= end; i++) {
    fprintf(output_stream, "%d\n", i);
  }

  return 0;
}