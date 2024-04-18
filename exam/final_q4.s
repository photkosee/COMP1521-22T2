        .data
numbers:
        .word 0:10	# int numbers[10] = { 0 };

        .text
main:
        li	$t0, 0		# i = 0;

main__input_loop:
        bge	$t0, 10, main__input_finished	# while (i < 10) {

        li	$v0, 5			# syscall 5: read_int
        syscall
        mul	$t1, $t0, 4
        sw	$v0, numbers($t1)	#	scanf("%d", &numbers[i]);
        
        addi	$t0, 1			#	i++;
        b	main__input_loop	# }

main__input_finished:
        li      $t0, 1          # int max_run = 1;
        li      $t1, 1          # int current_run = 1;
        li      $t2, 1          # int i = 1;

loop:
        bge     $t2, 10, main__end      # while (i < 10) {
        add     $t3, $t2, -1            # $t3 = i - 1
        mul     $t6, $t2, 4
        mul     $t7, $t3, 4
        lw      $t4, numbers($t6)       # numbers[i]
        lw      $t5, numbers($t7)       # numbers[i - 1]

        ble     $t4, $t5, reset_current_run     # if (numbers[i] > numbers[i - 1]) {
        add     $t1, $t1, 1                     # current_run++; }
        j       second_if

reset_current_run:
        li      $t1, 1          # current_run = 1;

second_if:
        ble     $t1, $t0, loop_count            # if (current_run > max_run) {
        move    $t0, $t1                        # max_run = current_run; }

loop_count:
        add     $t2, $t2, 1     # i++ }
        b       loop

main__end:
        li	$v0, 1		# syscall 1: print_int
        move    $a0, $t0
        syscall			# printf("%d", max_run);

        li	$v0, 11		# syscall 11: print_char
        li	$a0, '\n'
        syscall			# printf("\n");

        li	$v0, 0
        jr	$ra		# return 0;
