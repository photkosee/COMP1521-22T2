# Phot Koseekrainiramon (z5387411)
# COMP1521 lab02 EX 1
# on 06/06/2022
# a MIPS using if-else statements

# read a mark and print the corresponding UNSW grade

main:
    la   $a0, prompt    # printf("Enter a mark: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", mark);
    syscall

    blt $v0, 50, odd1    # if (mark < 50) {
    blt $v0, 65, odd2
    blt $v0, 75, odd3
    blt $v0, 85, odd4

    la   $a0, hd        # printf("HD\n");
    li   $v0, 4
    syscall
    
    b end

odd1:
    la $a0, fl
    li $v0, 4
    syscall
    
    b end
    
odd2:
    la $a0, ps
    li $v0, 4
    syscall
    
    b end
    
odd3:
    la $a0, cr
    li $v0, 4
    syscall
    
    b end
    
odd4:
    la $a0, dn
    li $v0, 4
    syscall
    
    b end    
    
end:
    li   $v0, 0
    jr   $ra            # return 0

.data
    prompt: .asciiz "Enter a mark: "
    fl: .asciiz "FL\n"
    ps: .asciiz "PS\n"
    cr: .asciiz "CR\n"
    dn: .asciiz "DN\n"
    hd: .asciiz "HD\n"
