#  Phot Koseekrainiramon (z5387411)
#  on 03/07/2022
#  Reads a line from stdin and an integer n,
#  and then prints the character in the nth-position

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0: int n

	li	$v0, 4			# syscall 4: print_string
	la	$a0, line_prompt_str	#
	syscall				# printf("Enter a line of input: ");

	li	$v0, 8			# syscall 8: read_string
	la	$a0, line		#
	la	$a1, LINE_LEN		#
	syscall				# fgets(buffer, LINE_LEN, stdin)

	li	$v0, 4			# syscall 4: print_string
	la	$a0, pos_prompt_str	#
	syscall				# printf("Enter a position: ");

	li	$v0, 5			# syscall 5: read_int
	syscall				#
	move	$t0, $v0		# scanf("%d", &n);

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str		#
	syscall				# printf("Character is: ");


	li	$v0, 11			# syscall 11: print_char
	lb	$a0, line($t0)		#
	syscall				# putchar(line[n]);

	# You shouldn't need to modify anything below here.

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
pos_prompt_str:
	.asciiz	"Enter a position: "
result_str:
	.asciiz	"Character is: "

# Line of input stored here
line:
	.space	LINE_LEN

