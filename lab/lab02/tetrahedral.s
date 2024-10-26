# Phot Koseekrainiramon (z5387411)
# COMP1521 lab02 EX 5
# on 06/06/2022
# a MIPS reading a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number

main:                  # int main(void) {

    la   $a0, prompt   # printf("Enter how many: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", number);
    syscall
    move $t0, $v0
    
    li $t1, 1           # $t1 = n;
    li $t2, 0           # $t2 = total;
    li $t3, 1           # $t3 = i;
    li $t4, 1           # $t4 = j;
    
    ble $t1, $t0, loop1
    b end

loop1:
    bgt $t1, $t0, end
    ble $t4, $t1, loop2
    
    move   $a0, $t2        #   printf("%d", total);
    li   $v0, 1
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall
    
    li $t2, 0           # $t2 = total;
    li $t4, 1           # $t4 = j;
    addi $t1, $t1, 1
    b loop1
    
loop2:
    bgt $t4, $t1, loop1
    ble $t3, $t4, loop3
    li $t3, 1           # $t3 = i;
    addi $t4, $t4, 1
    b loop2
    
loop3:
    bgt $t3, $t4, loop2
    add $t2, $t2, $t3
    addi $t3, $t3, 1
    b loop3

end:
    li   $v0, 0
    jr   $ra           # return 0

.data
    prompt: .asciiz "Enter how many: "
