// Phot Koseekrainiramon (z5387411)
// on 04/08/2022
// Delete non ascii

#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *stream = fopen(argv[1], "r");
    FILE *output = fopen("tmp", "w");
    
    int c = fgetc(stream);
    while (c != EOF) {
        if (c >= 0 && c < 128) {
            fputc(c, output);
        }
        c = fgetc(stream);
    }
    fclose(stream);
    fclose(output);
    return 0;
}
