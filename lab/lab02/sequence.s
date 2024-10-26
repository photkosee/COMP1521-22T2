# Phot Koseekrainiramon (z5387411)
# COMP1521 lab02 EX 4
# on 06/06/2022
# a MIPS reading three numbers `start`, `stop`, `step`
# Print the integers bwtween `start` and `stop` moving in increments of size `step`

main:                 # int main(void)
    la   $a0, prompt1 # printf("Enter the starting number: ");
    li   $v0, 4
    syscall

    li   $v0, 5       # scanf("%d", number);
    syscall
    move $t0, $v0     # $t0 = start
    
    la $a0, prompt2
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    move $t1, $v0     # $t1 = stop
    
    la $a0, prompt3
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0     # $t2 = step
    
    blt $t1, $t0, event1
    bgt $t1, $t0, event2
    
    b end
    
event1:
    bltz $t2, loop1
    b end
    
event2:
    bgtz $t2, loop2
    b end
    
loop1:
    blt $t0, $t1, end
    
    move   $a0, $t0      # printf("%d", start);
    li   $v0, 1
    syscall

    li   $a0, '\n'    # printf("%c", '\n');
    li   $v0, 11
    syscall
    
    add $t0, $t0, $t2
    b loop1
    
loop2:
    bgt $t0, $t1, end

    move   $a0, $t0      # printf("%d", start);
    li   $v0, 1
    syscall

    li   $a0, '\n'    # printf("%c", '\n');
    li   $v0, 11
    syscall
    
    add $t0, $t0, $t2
    b loop2

end:
    li   $v0, 0
    jr   $ra          # return 0

.data
    prompt1: .asciiz "Enter the starting number: "
    prompt2: .asciiz "Enter the stopping number: "
    prompt3: .asciiz "Enter the step size: "
