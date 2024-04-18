#include <stdio.h>

// read two integers and print all the integers which have their bottom 2 bits set.

int main(void) {
    int x, y;

    scanf("%d", &x);
    scanf("%d", &y);

    for (int i = x + 1; i < y; i++) {
        int tmp = i;
        if (tmp % 2 == 1) {
            tmp /= 2;
            if (tmp % 2 == 1) {
                printf("%d\n", i);
            }
        } 
    }

    return 0;
}
