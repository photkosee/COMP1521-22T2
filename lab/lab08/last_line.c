// Phot Koseekrainiramon (z5387411)
// on 18/07/2022

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *input_stream = fopen(argv[1], "r");
  if (input_stream == NULL) {
    perror(argv[1]);
    return 1;
  }

  char line[1024];
  while (!feof(input_stream)) {
    fgets(line, 1024, input_stream);
  }
  printf("%s", line);

  return 0;
}