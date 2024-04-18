// Phot Koseekrainiramon (z5387411)
// on 31/07/2022

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  char *home_pathname = getenv("HOME");
  if (home_pathname == NULL) {
    home_pathname = ".";
  }
  char home_filepath[1000];
  snprintf(home_filepath, 1000, "%s/.diary", home_pathname);

  FILE *stream = fopen(home_filepath, "a");
  if (stream == NULL) {
    perror(home_filepath);
    return 1;
  }
  for (int i = 1; i < argc; i++) {
    fprintf(stream, "%s ", argv[i]);
  }
  fprintf(stream, "%s", "\n");
  return 0;
}