# Phot Koseekrainiramon (z5387411), 25/06/2022

########################################################################
# .DATA
# Here are some handy strings for use in your code.

	.data
prompt_str:
	.asciiz "Enter a random seed: "
result_str:
	.asciiz "The random result is: "

########################################################################
# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[$a0]
	# Uses: 	[$a0]
	# Clobbers:	[]
	#
	# Locals:
	#   - $a0: int value
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:

	addi $sp, $sp, -4
	sw   $ra, 0($sp)

main__body:

	la	 $a0, prompt_str
	li	 $v0, 4
	syscall
	li	 $v0, 5
	syscall
	move $a0, $v0
	jal  seed_rand
	li   $a0, 100
	jal  rand
	move $a0, $v0
	jal  add_rand
	move $a0, $v0
	jal  sub_rand
	move $a0, $v0
	jal  seq_rand
	
	move $t0, $v0
	la   $a0, result_str
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	li   $a0, '\n'    # printf("%c", '\n');
    li   $v0, 11
    syscall

main__epilogue:

	lw	 $ra, 0($sp)
	addi $sp, $sp, 4

	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .TEXT <add_rand>
	.text
add_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[$a0]
	# Uses: 	[$a0]
	# Clobbers:	[]
	#
	# Locals:
	#   - $a0: int value
	#
	# Structure:
	#   - add_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

add_rand__prologue:

	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)

add_rand__body:
	
	li	 $a0, 0xFFFF
	jal  rand

add_rand__epilogue:
	
	lw	 $a0, 0($sp)
	lw	 $ra, 4($sp)
	addi $sp, $sp, 8
	add	 $v0, $a0, $v0

	jr	$ra


########################################################################
# .TEXT <sub_rand>
	.text
sub_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[$a0]
	# Uses: 	[$a0]
	# Clobbers:	[]
	#
	# Locals:
	#   - $a0: int value
	#
	# Structure:
	#   - sub_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

sub_rand__prologue:
	
	move $t0, $a0
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	move $a0, $t0

sub_rand__body:

	jal  rand

sub_rand__epilogue:
	
	lw   $a0, 0($sp)
	lw	 $ra, 4($sp)
	addi $sp, $sp, 8
	sub	 $v0, $a0, $v0

	jr	$ra

########################################################################
# .TEXT <seq_rand>
	.text
seq_rand:
	# Args:
	#   - $a0: int value
	# Returns: int
	#
	# Frame:	[$a0]
	# Uses: 	[$s1, $s0, $t2]
	# Clobbers:	[$s1, $s0, $t2]
	#
	# Locals:
	#   - $s1 int limit
	#   - $s0 int i
	#   - $t2 int value
	#
	# Structure:
	#   - seq_rand
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

seq_rand__prologue:

	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)

	li	 $a0, 100
	jal  rand
	move $s1, $v0

	lw   $a0, 0($sp)
	lw	 $ra, 4($sp)
	addi $sp, $sp, 8

	li	 $s0, 0
	move $t2, $a0
	bge  $s0, $s1, seq_rand__epilogue

seq_rand__body:

	addi $sp, $sp, -12
	sw   $ra, 8($sp)
	sw	 $s0, 4($sp)
	sw	 $s1, 0($sp)
	move $a0, $t2
	jal  add_rand
	move $t2, $v0
	lw	 $s1, 0($sp)
	lw	 $s0, 4($sp)
	lw   $ra, 8($sp)
	addi $sp, $sp, 12
	addi $s0, 1
	blt  $s0, $s1, seq_rand__body

seq_rand__epilogue:
	
	move $v0, $t2	
	jr	 $ra



##
## The following are two utility functions, provided for you.
##
## You don't need to modify any of the following,
## but you may find it useful to read through.
## You'll be calling these functions from your code.
##

OFFLINE_SEED = 0x7F10FB5B

########################################################################
# .DATA
	.data
	
# int random_seed;
	.align 2
random_seed:
	.space 4


########################################################################
# .TEXT <seed_rand>
	.text
seed_rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int seed
	# Returns: void
	#
	# Frame:	[]
	# Uses:		[$a0, $t0]
	# Clobbers:	[$t0]
	#
	# Locals:
	#   - $t0: offline_seed
	#
	# Structure:
	#   - seed_rand

	li	$t0, OFFLINE_SEED		# const unsigned int offline_seed = OFFLINE_SEED;
	xor	$t0, $a0			# random_seed = seed ^ offline_seed;
	sw	$t0, random_seed

	jr	$ra				# return;

########################################################################
# .TEXT <rand>
	.text
rand:
# DO NOT CHANGE THIS FUNCTION

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: int
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0]
	# Clobbers: [$v0, $t0]
	#
	# Locals:
	#   - $t0: int rand
	#
	# Structure:
	#   - rand

	lw	$t0, random_seed 		# unsigned int rand = random_seed;
	multu	$t0, 0x5bd1e995  		# rand *= 0x5bd1e995;
	mflo	$t0
	addiu	$t0, 12345       		# rand += 12345;
	sw	$t0, random_seed 		# random_seed = rand;

	remu	$v0, $t0, $a0    
	jr	$ra              		# return rand % n;
