#  Phot Koseekrainiramon (z5387411)
#  on 03/07/2022
# Reads a line and print its length

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0: int i

	li	$v0, 4			# syscall 4: print_string
	la	$a0, line_prompt_str	#
	syscall				# printf("Enter a line of input: ");

	li	$v0, 8			# syscall 8: read_string
	la	$a0, line		#
	la	$a1, LINE_LEN		#
	syscall				# fgets(buffer, LINE_LEN, stdin)

line_i_bne_0_init:
	li	$t0, 0

line_i_bne_0_cond:
	lb	$t1, line($t0)
	beq	$t1, 0, line_i_bne_0_false

line_i_bne_0_body:
line_i_bne_0_step:
	addi	$t0, $t0, 1
	b	line_i_bne_0_cond

line_i_bne_0_false:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str		#
	syscall				# printf("Line length: ");

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $t0		# 		
	syscall				# printf("%d", i);

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#
	syscall				# putchar('\n');

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_str:
	.asciiz	"Line length: "

# Line of input stored here
line:
	.space	LINE_LEN

