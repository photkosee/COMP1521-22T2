# Recursive implementation of a factorial calculator.
# You will need to complete the factorial function at the bottom of this file.
# Your program should yield n! = 1 for any n < 1.
# Phot Koseekrainiramon, 25/06/2022

########################################################################
# .DATA
	.data
prompt_str:	.asciiz	"Enter n: "
result_str:	.asciiz	"! = "

########################################################################
# .TEXT <main>
	.text
main:
	# DO NOT MODIFY THIS FUNCTION.

	# Args: void
	# Returns: int
	#
	# Frame:	[$ra, $s0]
	# Uses: 	[$v0, $a0, $s0, $t0]
	# Clobbers:	[$v0, $a0, $t0]
	#
	# Locals:
	#   - $s0: int n
	#   - $t0: int f
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:
	begin
	push	$ra
	push	$s0

main__body:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, prompt_str			#
	syscall					# printf("%s", "Enter n: ");

	li	$v0, 5				# syscall 5: read_int
	syscall					#
	move	$s0, $v0			# scanf("%d", &n);

	move	$a0, $s0			
	jal	factorial			
	move	$t0, $v0			# int f = factorial(n);

	li	$v0, 1				# syscall 1: print_int
	move	$a0, $s0			#
	syscall					# printf("%d", n);

	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_str			#
	syscall					# printf("%s", "! = ")

	li	$v0, 1				# syscall 1: print_int
	move	$a0, $t0			#
	syscall					# printf("%d", f)

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'			#
	syscall					# printf("%c", '\n');

main__epilogue:
	pop	$s0
	pop	$ra
	end

	li	$v0, 0
	jr	$ra				# return 0;

	# DO NOT MODIFY THE ABOVE CODE.

########################################################################
# .TEXT <factorial>
	.text
factorial:

	# Args:
	#   - $a0: int n
	# Returns: int
	#
	# Frame:	[$a0]
	# Uses: 	[$a0, $v0]
	# Clobbers:	[$v0]
	#
	# Locals:
	#   - $a0: int result
	#
	# Structure:
	#   - factorial
	#     -> [prologue]
	#     -> [body]
	#	  -> [n_bigger_than_one]
	#     -> [epilogue]

factorial__prologue:
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)

factorial__body:
	
	bgt  $a0, 1, n_bigger_than_one
	addi $v0, $zero, 1
	addi $sp, $sp, 8
	jr	 $ra

n_bigger_than_one:

	sub  $a0, $a0, 1
	jal  factorial

factorial__epilogue:
	
	lw   $a0, 0($sp)
	lw	 $ra, 4($sp)
	addi $sp, $sp, 8
	mul  $v0, $a0, $v0 
	jr	 $ra
