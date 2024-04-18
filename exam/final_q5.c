// COMP1521 22T2 ... final exam, question 5

#include <stdio.h>

void print_bytes(FILE *file, long n) {
  fseek(file, 0, SEEK_END);
  int len = ftell(file);
  if (n < 0) {
    len += n;
    for (int i = 0; i < len; i++) {
      fseek(file, i, SEEK_SET);
      int c = getc(file);
      putchar(c);
    }
  } else {
    for (int i = 0; i < n && i < len; i++) {
      fseek(file, i, SEEK_SET);
      int c = getc(file);
      putchar(c);
    }
  }

  return;
}
