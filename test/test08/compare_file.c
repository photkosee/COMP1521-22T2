// Phot Koseekrainiramon (z5387411)
// on 25/07/2022

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  FILE *input_stream1 = fopen(argv[1], "r");
  if (input_stream1 == NULL) {
    perror(argv[1]);
    return 1;
  }
  FILE *input_stream2 = fopen(argv[2], "r");
  if (input_stream2 == NULL) {
    perror(argv[2]);
    return 1;
  }
  
  int c1 = fgetc(input_stream1);
  int c2 = fgetc(input_stream2);
  int i = 0;
  while (c1 != EOF && c2 != EOF) {
    if (c1 != c2) {
      printf("Files differ at byte %d\n", i);
      return 0;
    }
    i++;
    c1 = fgetc(input_stream1);
    c2 = fgetc(input_stream2);
  }
  if (c1 != EOF) {
    printf("EOF on %s\n", argv[2]);
  } else if (c2 != EOF) {
    printf("EOF on %s\n", argv[1]);
  } else {
    printf("Files are identical\n");
  }
  return 0;
}