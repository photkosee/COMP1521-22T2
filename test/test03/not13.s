# Phot Koseekrainiramon (z5387411)
# on 21/06/2022

main:
    li   $v0, 5         #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

    li   $v0, 5         #   scanf("%d", &y);
    syscall             #
    move $t1, $v0
    addi $t2, $t0, 0    #   i = x;

loop:

    addi $t2, $t2, 1    #   i = i + 1;
    bge  $t2, $t1, end  #   if i >= y, go end
    beq  $t2, 13, loop  #   if i == 13, go loop

    move $a0, $t2        #   printf("%d\n", i);
    li   $v0, 1
    syscall
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    b    loop
    
end:

    li   $v0, 0         # return 0
    jr   $ra
