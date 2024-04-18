# Phot Koseekrainiramon (z5387411)
# on 27/06/2022

########################################################################
# .DATA
# Here are some handy strings for use in your code.
	.data
prompt_m_str:	.asciiz	"Enter m: "
prompt_n_str:	.asciiz	"Enter n: "
result_str_1:	.asciiz	"Ackermann("
result_str_2:	.asciiz	", "
result_str_3:	.asciiz	") = "

########################################################################
# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[]
	# Uses: 	[$s0, $s1]
	# Clobbers:	[]
	#
	# Locals:
	#   - $s0: int m
	#	- $s1: int n
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:

	push $ra

main__body:

	la	 $a0, prompt_m_str
	li	 $v0, 4
	syscall
	li	 $v0, 5
	syscall
	move $s0, $v0

	la	 $a0, prompt_n_str
	li	 $v0, 4
	syscall
	li	 $v0, 5
	syscall
	move $s1, $v0

	move $a0, $s0
	move $a1, $s1
	push $s0
	push $s1
	jal  ackermann
	move $t0, $v0

	pop  $s1
	pop  $s0
	la   $a0, result_str_1
	li   $v0, 4
	syscall
	move $a0, $s0
	li   $v0, 1
	syscall
	la   $a0, result_str_2
	li   $v0, 4
	syscall
	move $a0, $s1
	li   $v0, 1
	syscall
	la   $a0, result_str_3
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	li   $a0, '\n'    # printf("%c", '\n');
    li   $v0, 11
    syscall


main__epilogue:

	pop $ra

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .TEXT <ackermann>
	.text
ackermann:

	# Args:
	#   - $a0: int m
	#   - $a1: int n
	# Returns: int
	#
	# Frame:	[]
	# Uses: 	[$a0, $a1]
	# Clobbers:	[]
	#
	# Locals:
	#   - $a0: int m
	#	- $a1: int n
	#
	# Structure:
	#   - ackermann
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

ackermann__prologue:

	push $ra

ackermann__body:

	bnez $a0, ackermann__n
	addi $v0, $a1, 1
	pop  $ra
	jr	 $ra

ackermann__n:

	bnez $a1, ackermann__epilogue
	sub  $a0, $a0, 1
	li   $a1, 1
	jal  ackermann

	pop  $ra
	jr	 $ra

ackermann__epilogue:

	push $a0
	sub  $a1, $a1, 1
	jal  ackermann

	pop  $a0
	sub  $a0, $a0, 1
	move $a1, $v0
	jal  ackermann
	
	pop  $ra

	jr	$ra
