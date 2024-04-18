# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# Phot Koseekrainiramon (z5387411), 20/06/2022

# Constants
ARRAY_LEN = 1000

main:

	li  $t0, 2		# i = 2;
	blt $t0, ARRAY_LEN, loop1 
	j   end

loop1_add:
	addi $t0, $t0, 1
	
loop1:
	bge $t0, ARRAY_LEN, end
	mul $t2, $t0, 1
	la  $t3, prime
	add $t6, $t2, $t3
	lb  $t7, ($t6)
	bnez $t7, print
	j   loop1_add

print:

	move  $a0, $t0	
	li	$v0, 1		
	syscall			

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'	# 
	syscall			# printf("%c", '\n');

	mul $t1, $t0, 2

loop2:
	bge $t1, ARRAY_LEN, loop1_add
	mul $t4, $t1, 1
	la  $t3, prime
	add $t3, $t3, $t4
	li  $t5, 0
	sb  $t5, ($t3)
	add $t1, $t1, $t0
	b   loop2

end:
	li	$v0, 0
	jr	$ra			# return 0;

	.data
prime:
	.byte	1:ARRAY_LEN		# uint8_t prime[ARRAY_LEN] = {1, 1, ...};
