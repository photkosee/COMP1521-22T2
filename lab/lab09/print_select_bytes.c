// Phot Koseekrainiramon (z5387411)
// on 31/07/2022

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  FILE *stream = fopen(argv[1], "r");
  if (stream == NULL) {
    perror(argv[1]);
    return 1;
  }
  
  fseek(stream, 0, SEEK_END);
  for (int i = 2; i < argc; i++) {
    int index = atoi(argv[i]);
    fseek(stream, index, SEEK_SET);
    int c = getc(stream);
    printf("%d - 0x%X - '%c'\n", c, c, c);
  }

  fclose(stream);
  return 0;
}