# Phot Koseekrainiramon (z5387411)
# on 12/06/2022
# COMP1521 Lab03 EX 1
# Read 10 numbers into an array
# then print the numbers which are
# larger than the final number read.

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

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

    lw   $t5, 0($t3)    # final number
    li   $t0, 0         # i = 0 
loop1:
    bge  $t0, 10, end1  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t6, 0($t3)    # current number

    blt  $t6, $t5, loop2  # compare current number with final number, 
                          # skip the printing part if it's lower than the final number

    lw   $a0, ($t3)     #   load numbers[i] into $a0
    li   $v0, 1         #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

loop2:
    addi $t0, $t0, 1    #   i++
    j    loop1          # }
end1:

    jr   $ra              # return

.data

numbers:
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # int numbers[10] = {0};
