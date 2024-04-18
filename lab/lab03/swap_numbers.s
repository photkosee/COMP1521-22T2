# Phot Koseekrainiramon (z5387411)
# on 12/06/2022
# COMP1521 Lab03 EX 3
# read 10 numbers into an array
# swap any pairs of of number which are out of order
# then print the 10 numbers

# i in register $t0,
# registers $t1 - $t3 used to hold temporary results

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

    bge  $t0, 10, print  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t6, 0($t3)    #   current number

    blt  $t6, $t5, swap # compare current number with next number, 
                        # go to swap if the next is less than
                        
    lw   $t5, 0($t3)
    addi $t0, $t0, 1    #   i++
    j    loop1          # }

swap:
    sw   $t5, ($t3)
    sub  $t7, $t1, 4
    la   $t2, numbers   
    add  $t3, $t7, $t2
    sw   $t6, ($t3)
    
    addi $t0, $t0, 1
    j    loop1

print:
    li   $t0, 0
print2:
    bge  $t0, 10, end  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #

    lw   $a0, ($t3)     #   load numbers[i] into $a0
    li   $v0, 1         #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1    #   i++
    j    print2          # }
end:

    jr   $ra            # return

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # int numbers[10] = {0};
