#  Phot Koseekrainiramon (z5387411)
#  on 03/07/2022
# Reads a line and prints whether it is a palindrome or not

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0: int i
	#   - $t1: int j
	#   - $t2: int k

	li	$v0, 4				# syscall 4: print_string
	la	$a0, line_prompt_str		#
	syscall					# printf("Enter a line of input: ");

	li	$v0, 8				# syscall 8: read_string
	la	$a0, line			#
	la	$a1, LINE_LEN			#
	syscall					# fgets(buffer, LINE_LEN, stdin)

line_i_bne_0_init:
	li	$t0, 0

line_i_bne_0_cond:
	lb	$t3, line($t0)
	beq	$t3, 0, line_i_bne_0_false

line_i_bne_0_body:
line_i_bne_0_step:
	addi	$t0, $t0, 1
	b	line_i_bne_0_cond

line_i_bne_0_false:
j_lt_k_init:
	li	$t1, 0
	addi	$t2, $t0, -2

j_lt_k_cond:
	bge	$t1, $t2, j_lt_k_false

j_lt_k_body:
	lb	$t3, line($t1)
	lb	$t4, line($t2)
	beq	$t3, $t4, line_j_bne_line_k_f
	
line_j_bne_line_k:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_not_palindrome_str	#
	syscall					# printf("not palindrome\n");

	b	end

line_j_bne_line_k_f:
j_lt_k_step:
	addi	$t1, $t1, 1
	addi	$t2, $t2, -1
	b	j_lt_k_cond

j_lt_k_false:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_palindrome_str	#
	syscall					# printf("palindrome\n");

end:
	li	$v0, 0
	jr	$ra				# return 0;


########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_not_palindrome_str:
	.asciiz	"not palindrome\n"
result_palindrome_str:
	.asciiz	"palindrome\n"

# Line of input stored here
line:
	.space	LINE_LEN

