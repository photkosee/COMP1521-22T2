# Phot Koseekrainiramon (z5387411)
# on 21/06/2022

main:
    li   $v0, 5         #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

    li   $t1, 0         #   i = 0;

loop1:

    bge  $t1, $t0, end  #   if i >= x, go end
    li   $t2, 0         #   j = 0;

loop2:

    bge  $t2, $t0, i_add #   if j >= x, go i_add

    li   $a0, '*'       #   printf("%c", '*');
    li   $v0, 11
    syscall

    addi $t2, 1         #   j++
    b    loop2

i_add:

    addi $t1, 1         #   i++
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    b    loop1

end:

    li   $v0, 0         # return 0
    jr   $ra
