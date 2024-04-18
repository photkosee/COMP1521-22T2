# Phot Koeekrainiramon (z5387411)
# COMP 1521 EX 8
# on 01/06/2022

main:
    la $a0, string
    li $v0, 4
    syscall
    li $v0, 0
    jr $ra
    .data
string:
.asciiz "Well, this was a MIPStake!\n"