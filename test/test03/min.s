# Phot Koseekrainiramon (z5387411)
# on 21/06/2022
#  print the minimum of two integers
main:
    li   $v0, 5         #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

    li   $v0, 5         #   scanf("%d", &y);
    syscall             #
    move $t1, $v0

    ble  $t1, $t0, print_y # if y <= x, go print_y

print_x:

    move $a0, $t0        #   printf("%d\n", x);
    li   $v0, 1
    syscall
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    j    end

print_y:

    move $a0, $t1        #   printf("%d\n", y);
    li   $v0, 1
    syscall
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

end:

    li   $v0, 0         # return 0
    jr   $ra
