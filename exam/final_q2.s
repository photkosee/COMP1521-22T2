# COMP1521 22T2 ... final exam, question 2

main:
	li	$v0, 5		# syscall 5: read_int
	syscall
	move	$t0, $v0	# read integer into $t0

        li      $t1, 0          # int count = 0;
        li      $t2, 0          # int i = 0;
        nor     $t3, $v0, $v0   # $t3 = ~x
	
loop:
        bge     $t2, 32, main__end      # for (int i = 0; i < 32; i++)
        sllv    $t4, 0x1, $t2           # mask = 1u << i;
        and     $t5, $t4, $t3           # ~x & mask;

        beqz    $t5, loop_count         # if ((~x & mask) != 0) {
        add     $t1, $t1, 1             # count++; }

loop_count:
        add     $t2, $t2, 1             # i++; }
        b       loop
	
main__end:
        move    $a0, $t1
        li      $v0, 1
        syscall                 # printf("%d", count);

        li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'
	syscall			# printf("\n");

	li	$v0, 0		# return 0;
	jr	$ra
