# Phot Koseekrainiramon (z5387411)
# on 12/06/2022
# COMP1521 Lab03 EX 2
# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0

main:

    li   $t0, 0         # i = 0
loop0:
    bge  $t0, 10, end0  # while (i < 10) {

    li   $v0, 5         #   scanf("%d", &numbers[i]);
    syscall             #

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    sw   $v0, ($t3)     #   store entered number in array

    addi $t0, $t0, 1    #   i++;
    j    loop0          # }
end0:

    li   $t0, 0         # i = 0 
    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   
    add  $t3, $t1, $t2  
    lw   $t5, 0($t3)    #   $t5 = first number
    li   $t0, 1         # i = 1
loop1:

    bge  $t0, 10, print0  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t6, 0($t3)    #   current number

    blt  $t6, $t5, print1  # compare current number with next number, 
                           # go to printing 1 part if the next is less than
    
    lw   $t5, 0($t3)    #   assigned current as a previous number
    addi $t0, $t0, 1    #   i++
    j    loop1          # }

print1:
    li   $t0, 1
    move $a0, $t0       #   printing 1
    li   $v0, 1
    syscall
    
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall
    
    j    end
    
print0:
    li   $t0, 0
    move $a0, $t0       #   printing 0
    li   $v0, 1
    syscall
    
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

end:
    jr   $ra            #   return

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # int numbers[10] = {0};
