# Phot Koseekrainiramon (z5387411)
# COMP1521 lab02 EX 2
# on 06/06/2022
# a MIPS read a number n and print the integers 1..n one per line

main:                 # int main(void)
    la   $a0, prompt  # printf("Enter a number: ");
    li   $v0, 4
    syscall

    li   $v0, 5       # scanf("%d", number);
    syscall
    move $t2, $v0

    li $t0, 1         # sum = 1;
    li $t1, 1         # i = 1;    
    
loop:
    bgt $t1, $t2, end
    move   $a0, $t0     # printf("%d", sum);
    li   $v0, 1
    syscall

    li   $a0, '\n'    # printf("%c", '\n');
    li   $v0, 11
    syscall
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    b loop 

end:
    
    li   $v0, 0
    jr   $ra          # return 0

.data
    prompt: .asciiz "Enter a number: "
