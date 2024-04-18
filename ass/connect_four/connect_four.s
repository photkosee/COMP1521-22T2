########################################################################
# COMP1521 22T2 -- Assignment 1 -- Connect Four!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/22T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Phot Koseekrainiramon (z5387411)
# on 29/06/2022 - 03/07/2022
#
# Version 1.0 (05-06-2022): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# DO NOT CHANGE THESE DEFINITIONS

# MIPS doesn't have true/false by default
true  = 1
false = 0

# How many pieces we're trying to connect
CONNECT = 4

# The minimum and maximum board dimensions
MIN_BOARD_DIMENSION = 4
MAX_BOARD_WIDTH     = 9
MAX_BOARD_HEIGHT    = 16

# The three cell types
CELL_EMPTY  = '.'
CELL_RED    = 'R'
CELL_YELLOW = 'Y'

# The winner conditions
WINNER_NONE   = 0
WINNER_RED    = 1
WINNER_YELLOW = 2

# Whose turn is it?
TURN_RED    = 0
TURN_YELLOW = 1

########################################################################
# .DATA
# YOU DO NOT NEED TO CHANGE THE DATA SECTION
	.data

# char board[MAX_BOARD_HEIGHT][MAX_BOARD_WIDTH];
board:		.space  MAX_BOARD_HEIGHT * MAX_BOARD_WIDTH

# int board_width;
board_width:	.word 0

# int board_height;
board_height:	.word 0


enter_board_width_str:	.asciiz "Enter board width: "
enter_board_height_str: .asciiz "Enter board height: "
game_over_draw_str:	.asciiz "The game is a draw!\n"
game_over_red_str:	.asciiz "Game over, Red wins!\n"
game_over_yellow_str:	.asciiz "Game over, Yellow wins!\n"
board_too_small_str_1:	.asciiz "Board dimension too small (min "
board_too_small_str_2:	.asciiz ")\n"
board_too_large_str_1:	.asciiz "Board dimension too large (max "
board_too_large_str_2:	.asciiz ")\n"
red_str:		.asciiz "[RED] "
yellow_str:		.asciiz "[YELLOW] "
choose_column_str:	.asciiz "Choose a column: "
invalid_column_str:	.asciiz "Invalid column\n"
no_space_column_str:	.asciiz "No space in that column!\n"


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################


########################################################################
#
# Implement the following 7 functions,
# and check these boxes as you finish implementing each function
#
#  - [X] main
#  - [X] assert_board_dimension
#  - [X] initialise_board
#  - [X] play_game
#  - [X] play_turn
#  - [X] check_winner
#  - [X] check_line
#  - [X] is_board_full	(provided for you)
#  - [X] print_board	(provided for you)
#
########################################################################


########################################################################
# .TEXT <main>
	.text
main:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0, $a1, $a2, $t0]
	# Clobbers: [$v0, $a0, $a1, $a2, $t0]
	#
	# Locals:
	#   - []
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

main__prologue:
	begin							        # begin a new stack frame
	push	$ra						        # | $ra

main__body:
	la      $a0, enter_board_width_str				#
	li      $v0, 4                                                  # printf("Enter board width: ");
	syscall
	
	li      $v0, 5                                                  # scanf("%d", &board_width);
	syscall

	lw      $t0, board_width					#
	add     $t0, $t0, $v0						#
	sw      $t0, board_width                                        # save &board_width

	move    $a0, $v0						#
	li      $a1, MIN_BOARD_DIMENSION				#
	li      $a2, MAX_BOARD_WIDTH					#
	jal     assert_board_dimension                                  # assert_board_dimension(board_width, MIN_BOARD_DIMENSION, MAX_BOARD_WIDTH);

	la      $a0, enter_board_height_str				#
	li      $v0, 4                                                  # printf("Enter board height: ");
	syscall
	
	li      $v0, 5                                                  # scanf("%d", &board_height);
	syscall

	lw      $t0, board_height					#
	add     $t0, $t0, $v0						#
	sw      $t0, board_height                                       # save &board_height

	move    $a0, $v0						#
	li      $a1, MIN_BOARD_DIMENSION				#
	li      $a2, MAX_BOARD_HEIGHT					#
	jal     assert_board_dimension                                  # assert_board_dimension(board_height, MIN_BOARD_DIMENSION, MAX_BOARD_HEIGHT);
	jal     initialise_board                                        # initialise_board();
	jal     print_board                                             # print_board();
	jal     play_game                                               # play_game();
	
main__epilogue:
	pop	$ra						        # | $ra  
	end							        # ends the current stack frame
	li	$v0, 0
	jr	$ra						        # return 0;


########################################################################
# .TEXT <assert_board_dimension>
	.text
assert_board_dimension:
	# Args:
	#   - $a0: int dimension
	#   - $a1: int min
	#   - $a2: int max
	# Returns:  void
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $a1, $a2]
	# Clobbers: [$v0, $a0, $a1, $a2]
	#
	# Locals:
	#   - []
	#
	# Structure:
	#   assert_board_dimension
	#   -> [prologue]
	#   -> body
	#   -> assert_board_dimension_lt_min
	#   -> assert_board_dimension_lt_min_f
	#   -> assert_board_dimension_gt_max
	#   -> assert_board_dimension_gt_max_f
	#   -> [epilogue]

assert_board_dimension__prologue:
assert_board_dimension__body:
	bge     $a0, $a1, assert_board_dimension_lt_min_f               # if (dimension < min) goto assert_board_dimension_lt_min
									# if not, goto assert_board_dimension_lt_min_f
assert_board_dimension_lt_min:
	la      $a0, board_too_small_str_1				#
	li      $v0, 4							#
	syscall

	move    $a0, $a1						#
	li      $v0, 1  						#				
	syscall

	la      $a0, board_too_small_str_2				#
	li      $v0, 4							#
	syscall                                                         # printf("Board dimension too small (min %d)\n", min);
	
	li      $a0, 1							#
	li      $v0, 17 					        # exit(1);
	syscall

assert_board_dimension_lt_min_f:
	ble     $a0, $a2, assert_board_dimension_gt_max_f               # if (dimension > max) goto assert_board_dimension_gt_max
									# if not, goto assert_board_dimension_gt_max_f
assert_board_dimension_gt_max:
	la      $a0, board_too_large_str_1				#
	li      $v0, 4							#
	syscall
	
	move    $a0, $a2						#
	li      $v0, 1  						#			
	syscall

	la      $a0, board_too_large_str_2				#
	li      $v0, 4                                                  # printf("Board dimension too large (max %d)\n", max);
	syscall
	
	li      $a0, 1							#
	li      $v0, 17 					        # exit(1);
	syscall

assert_board_dimension_gt_max_f:
assert_board_dimension__epilogue:
	jr	$ra						        # return;


########################################################################
# .TEXT <initialise_board>
	.text
initialise_board:
	# Args:     void
	# Returns:  void
	#
	# Frame:    []
	# Uses:     [$v0, $t1, $t2, $t3, $t4, $t5]
	# Clobbers: [$v0, $t1, $t2, $t3, $t4, $t5]
	#
	# Locals:
	#   - `int row` in $t0
	#   - `int col` in $t2
	#
	# Structure:
	#   initialise_board
	#   -> [prologue]
	#   -> body
	#   -> initialise_board_row_init
	#   -> initialise_board_row_cond
	#   -> initialise_board_row_body
	#       -> initialise_board_col_init
	#       -> initialise_board_col_cond
	#       -> initialise_board_col_body
	#       -> initialise_board_col_step
	#       -> initialise_board_col_false
	#   -> initialise_board_row_step
	#   -> initialise_board_row_false
	#   -> [epilogue]

initialise_board__prologue:
initialise_board__body:
initialise_board_row_init:
	li      $t0, 0                  			        # int row = 0;
	lw      $t1, board_height       				#			

initialise_board_row_cond:
	bge     $t0, $t1, initialise_board_row_false                    # while (row < board_height) goto initialise_board_row_body
									# if not, goto initialise_board_row_false
initialise_board_row_body:
initialise_board_col_init:
	li      $t2, 0                  			        # int col = 0;                  
	lw      $t3, board_width        				#		

initialise_board_col_cond:
	bge     $t2, $t3, initialise_board_col_false                    # while (col < board_width) goto initialise_board_col_body
									# if not, goto initialise_board_col_false
initialise_board_col_body:
	mul     $t4, $t0, MAX_BOARD_WIDTH                               # row * MAX_BOARD_WIDTH
	add     $t4, $t4, $t2                                           # (row * MAX_BOARD_WIDTH) + col
	li      $t5, CELL_EMPTY						#
	sb      $t5, board($t4)  				        # board[row][col] = CELL_EMPTY;
	
initialise_board_col_step:
	addi    $t2, $t2, 1             			        # col++;
	b       initialise_board_col_cond				# goto initialise_board_col_cond
	
initialise_board_col_false:
initialise_board_row_step:
	addi    $t0, $t0, 1             			        # row++;
	b       initialise_board_row_cond				# goto initialise_board_row_cond

initialise_board_row_false:
initialise_board__epilogue:
	jr	$ra						        # return;


########################################################################
# .TEXT <play_game>
	.text
play_game:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0, $s2, $s3]
	# Clobbers: [$v0, $a0, $s2, $s3]
	#
	# Locals:
	#   - `int whose_turn`  in $s2
	#   - `int winner`      in $s3
	#
	# Structure:
	#   play_game
	#   -> [prologue]
	#   -> body
	#   -> play_game_loop_winner_beq_none
	#   -> play_game_loop_winner_beq_none_body
	#   -> play_game_loop_winner_beq_none_cond
	#   -> play_game_loop_winner_beq_none_f
	#   -> play_game_winner_beq_none
	#   -> play_game_winner_beq_none_f
	#   -> play_game_winner_beq_red
	#   -> play_game_winner_beq_red_f
	#   -> [epilogue]

play_game__prologue:
	begin							        # begin a new stack frame
	push	$ra						        # | $ra
	
play_game__body:
	li      $s2, TURN_RED                                           # int whose_turn = TURN_RED;

play_game_loop_winner_beq_none:
play_game_loop_winner_beq_none_body:
	move    $a0, $s2						#
	jal     play_turn						#
	move    $s2, $v0                                                # whose_turn = play_turn(whose_turn);
	jal     print_board                                             # print_board();
	jal     check_winner						#
	move    $s3, $v0                                                # winner = check_winner();

play_game_loop_winner_beq_none_cond:
	jal     is_board_full						#
	bne     $v0, WINNER_NONE, play_game_loop_winner_beq_none_f      # while (!is_board_full()) goto play_game_loop_winner_beq_none
	bne     $s3, WINNER_NONE, play_game_loop_winner_beq_none_f      # while (winner == WINNER_NONE) goto play_game_loop_winner_beq_none
	b       play_game_loop_winner_beq_none				# if not, goto play_game_loop_winner_beq_none_f

play_game_loop_winner_beq_none_f:
	bne     $s3, WINNER_NONE, play_game_winner_beq_none_f           # if (winner == WINNER_NONE)

play_game_winner_beq_none:
	la      $a0, game_over_draw_str					#
	li      $v0, 4                                                  # printf("The game is a draw!\n");
	syscall
	
	b       play_game__epilogue					# goto play_game__epilogue

play_game_winner_beq_none_f:
	bne     $s3, WINNER_RED, play_game_winner_beq_red_f             # if (winner == WINNER_RED) goto play_game_winner_beq_red
									# if not, goto play_game_winner_beq_red_f
play_game_winner_beq_red:
	la      $a0, game_over_red_str					#
	li      $v0, 4                                                  # printf("Game over, Red wins!\n");
	syscall
	
	b       play_game__epilogue					# goto play_game__epilogue

play_game_winner_beq_red_f:
	la      $a0, game_over_yellow_str				#
	li      $v0, 4                                                  # printf("Game over, Yellow wins!\n");
	syscall
	
play_game__epilogue:
	pop	$ra						        # | $ra  
	end							        # ends the current stack frame
	jr	$ra						        # return;


########################################################################
# .TEXT <play_turn>
	.text
play_turn:
	# Args:
	#   - $a0: int whose_turn
	# Returns:  void
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t1, $t2, $t3, $t4]
	# Clobbers: [$v0, $a0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - `int target_col` in $t1
	#   - `int target_row` in $t2
	#
	# Structure:
	#   play_turn
	#   -> [prologue]
	#   -> body
	#   -> play_turn_whose_beq_red
	#   -> play_turn_whose_beq_red_f
	#   -> play_turn_print_choose
	#   -> play_turn_col_lt_0_or_col_bge_width
	#   -> play_turn_col_lt_0_f
	#   -> play_turn_col_lt_0_or_col_bge_width_f
	#   -> play_turn_row_init
	#   -> play_turn_row_cond
	#   -> play_turn_row_step
	#   -> play_turn_row_body
	#       -> play_turn_row_lt_0
	#       -> play_turn_row_lt_0_f
	#   -> play_turn_row_false
	#   -> play_turn_whose_beq_red_post
	#   -> play_turn_whose_beq_red_post_f
	#   -> [epilogue]

play_turn__prologue:
play_turn__body:
	move    $t0, $a0						#
	bne     $t0, TURN_RED, play_turn_whose_beq_red_f     	        # if (whose_turn == TURN_RED) goto play_turn_whose_beq_red
									# if not, goto play_turn_whose_beq_red_f
play_turn_whose_beq_red:
	la      $a0, red_str						#
	li      $v0, 4  					        # printf("[RED] ");
	syscall
	
	b       play_turn_print_choose					# goto play_turn_print_choose
	
play_turn_whose_beq_red_f:
	la      $a0, yellow_str						#
	li      $v0, 4  					        # printf("[YELLOW] ");
	syscall

play_turn_print_choose:
	la      $a0, choose_column_str					#
	li      $v0, 4  					        # printf("Choose a column: ");
	syscall
	
	li	$v0, 5  					        # scanf("%d", &target_col);
	syscall
	
	move    $t1, $v0        				        # int targer_col;
	addi    $t1, $t1, -1    				        # target_col--;
	bge     $t1, 0, play_turn_col_lt_0_f                            # if (target_col < 0) goto play_turn_col_lt_0_or_col_bge_width
									# if not, goto play_turn_col_lt_0_f
play_turn_col_lt_0_or_col_bge_width:
	la      $a0, invalid_column_str					#
	li      $v0, 4  					        # printf("Invalid column\n");
	syscall

	move    $v0, $t0        				        # return whose_turn;
	b       play_turn__epilogue					# goto play_turn__epilogue

play_turn_col_lt_0_f:        
	lw      $t2, board_width					#
	bge     $t1, $t2, play_turn_col_lt_0_or_col_bge_width           # if (target_col >= board_width) goto play_turn_col_lt_0_or_col_bge_width
									# if not, goto play_turn_col_lt_0_or_col_bge_width_f
play_turn_col_lt_0_or_col_bge_width_f:
play_turn_row_init:
	lw      $t2, board_height					#
	addi    $t2, $t2, -1    				        # int target_row = board_height - 1;

play_turn_row_cond:
	blt     $t2, 0, play_turn_row_false       		        # while (target_row >= 0) goto play_turn_row_step
									# if not, goto play_turn_row_false
	mul     $t3, $t2, MAX_BOARD_WIDTH                               # target_row * MAX_BOARD_WIDTH
	add     $t3, $t3, $t1                                           # (target_row * MAX_BOARD_WIDTH) + target_col
	lb      $t3, board($t3)                                         # board[target_row][target_col]
	beq     $t3, CELL_EMPTY, play_turn_row_false     	        # while (board[target_row][target_col] != CELL_EMPTY) goto play_turn_row_step
									# if not, goto play_turn_row_false
play_turn_row_step:
	addi    $t2, $t2, -1    				        # target_row--;

play_turn_row_body:
	bge     $t2, 0, play_turn_row_lt_0_f     		        # if (target_row < 0) goto play_turn_row_lt_0
									# if not, goto play_turn_row_lt_0_f

play_turn_row_lt_0:
	la      $a0, no_space_column_str				#
	li      $v0, 4  					        # printf("No space in that column!\n");
	syscall
	
	move    $v0, $t0        				        # return whose_turn;
	b       play_turn__epilogue					# goto play_turn__epilogue

play_turn_row_lt_0_f:
	b       play_turn_row_cond					# goto play_turn_row_cond

play_turn_row_false:
	bne     $t0, TURN_RED, play_turn_whose_beq_red_post_f           # if (whose_turn == TURN_RED) goto play_turn_whose_beq_red_post
									# if not, goto play_turn_whose_beq_red_post_f
play_turn_whose_beq_red_post:
	mul     $t3, $t2, MAX_BOARD_WIDTH                               # target_row * MAX_BOARD_WIDTH
	add     $t3, $t3, $t1                                           # (target_row * MAX_BOARD_WIDTH) + target_col
	li      $t4, CELL_RED						#
	sb      $t4, board($t3) 				        # board[target_row][target_col] = CELL_RED;
	li      $v0, TURN_YELLOW           			        # return TURN_YELLOW;
	b       play_turn__epilogue					# goto play_turn__epilogue
	
play_turn_whose_beq_red_post_f:
	mul     $t3, $t2, MAX_BOARD_WIDTH                               # target_row * MAX_BOARD_WIDTH
	add     $t3, $t3, $t1                                           # (target_row * MAX_BOARD_WIDTH) + target_col
	li      $t4, CELL_YELLOW					#
	sb      $t4, board($t3)    				        # board[target_row][target_col] = CELL_YELLOW;
	li      $v0, TURN_RED        			                # return TURN_RED;
	
play_turn__epilogue:
	jr	$ra						        # return;


########################################################################
# .TEXT <check_winner>
	.text
check_winner:
	# Args:	    void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra, $s2]
	# Uses:     [$v0, $a1, $a2, $a3, $s0, $s1, $t0]
	# Clobbers: [$v0, $a1, $a2, $a3, $s0, $s1, $t0]
	#
	# Locals:
	#   - `int row`         in $s0
	#   - `int col`         in $s1
	#   - `int check`       in $v0
	#
	# Structure:
	#   check_winner
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

check_winner__prologue:
	begin                                                           # begin a stack framee
	push    $ra                                                     # | $ra
	push    $s2                                                     # | $s2       
	
check_winner__body:
check_winner_row_init:
	li      $s0, 0  					        # int row = 0;
	
check_winner_row_cond:
	lw      $t0, board_height					#
	bge     $s0, $t0, check_winner_row_false    		        # while (row < board_height) goto check_winner_row_body
									# if not, goto check_winner_row_false
check_winner_row_body:
check_winner_col_init:
	li      $s1, 0  					        # int col = 0;
	
check_winner_col_cond:
	lw      $t1, board_width					#
	bge     $s1, $t1, check_winner_col_false    	                # while (col < board_width) goto check_winner_col_body
									# if not, goto check_winner_col_false
check_winner_col_body:
	move    $a0, $s0						#
	move    $a1, $s1						#
	li      $a2, 1							#
	li      $a3, 0							#
	jal     check_line      				        # check = check_line(row, col, 1, 0);
	beq     $v0, WINNER_NONE, check_winner_check_bne_none_1_f       # if (check != WINNER_NONE) goto check_winner_check_bne_none_1
									# if not, goto check_winner_check_bne_none_1_f
check_winner_check_bne_none_1:
	b       check_winner__epilogue                                  # return check;
									# goto check_winner__epilogue
check_winner_check_bne_none_1_f:
	move    $a0, $s0						#
	move    $a1, $s1						#
	li      $a2, 0							#
	li      $a3, 1							#
	jal     check_line      				        # check = check_line(row, col, 0, 1);
	beq     $v0, WINNER_NONE, check_winner_check_bne_none_2_f       # if (check != WINNER_NONE) goto check_winner_check_bne_none_2
									# if not, goto check_winner_check_bne_none_2_f
check_winner_check_bne_none_2:
	b       check_winner__epilogue                                  # return check;
									# goto check_winner__epilogue									
check_winner_check_bne_none_2_f:
	move    $a0, $s0						#
	move    $a1, $s1						#
	li      $a2, 1							#
	li      $a3, 1							#
	jal     check_line      				        # check = check_line(row, col, 1, 1);
	beq     $v0, WINNER_NONE, check_winner_check_bne_none_3_f       # if (check != WINNER_NONE) goto check_winner_check_bne_none_3
									# if not, goto check_winner_check_bne_none_3_f
check_winner_check_bne_none_3:
	b       check_winner__epilogue                                  # return check;
									# goto check_winner__epilogue
check_winner_check_bne_none_3_f:
	move    $a0, $s0						#
	move    $a1, $s1						#
	li      $a2, 1							#
	li      $a3, -1							# 
	jal     check_line      				        # check = check_line(row, col, 1, -1);
	beq     $v0, WINNER_NONE, check_winner_check_bne_none_4_f       # if (check != WINNER_NONE) goto check_winner_check_bne_none_4
									# if not, goto check_winner_check_bne_none_4_f
check_winner_check_bne_none_4:
	b       check_winner__epilogue                                  # return check;
									# goto check_winner__epilogue
check_winner_check_bne_none_4_f:
check_winner_col_step:
	addi    $s1, 1  					        # col++;
	b       check_winner_col_cond					# goto check_winner_col_cond

check_winner_col_false:
check_winner_row_step:
	addi    $s0, 1  					        # row++;
	b       check_winner_row_cond					# goto check_winner_row_cond
	
check_winner_row_false:
check_winner__winner_none:
	li      $v0, WINNER_NONE        			        # return WINNER_NONE;

check_winner__epilogue:
	pop     $s2                                                     # | $s2
	pop     $ra                                                     # | $ra   
	end							        # ends the current stack frame
	jr	$ra						        # return;


########################################################################
# .TEXT <check_line>
	.text
check_line:
	# Args:
	#   - $a0: int start_row
	#   - $a1: int start_col
	#   - $a2: int offset_row
	#   - $a3: int offset_col
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$s0, $s1]
	# Uses:     [$v0, $a0, $a1, $t1, $t2, $t3, $t4, $t5]
	# Clobbers: [$v0, $a0, $a1, $t1, $t2, $t3, $t4, $t5]
	#
	# Locals:
	#   - `char first_cell` in $t0
	#   - `int row`         in $t1
	#   - `int col`         in $t2
	#   - `char cell`       in $t5
	#
	# Structure:
	#   check_line
	#   -> [prologue]
	#   -> body
	#   -> check_line_first_cell_beq_empty_f
	#   -> check_line_i_init
	#   -> check_line_i_cond
	#   -> check_line_i_body
	#       -> check_line_row_lt_0_or_col_lt_0_f
	#       -> check_line_row_bge_height_or_col_bge_width_f
	#       -> check_line_cell_bne_first_cell_f
	#   -> check_line_i_step
	#   -> check_line_i_false
	#   -> check_line_first_cell_beq_red
	#   -> check_line_first_cell_beq_red_f
	#   -> check_line_return_winner_none
	#   -> [epilogue]

check_line__prologue:
	begin                                                           # begin a stack framee
	push    $s0                                                     # | $s0 
	push    $s1                                                     # | $s1

check_line__body:
	mul     $t0, $a0, MAX_BOARD_WIDTH                               # start_row * MAX_BOARD_WIDTH
	add	$t0, $t0, $a1                                           # (start_row * MAX_BOARD_WIDTH) + start_col
	lb      $t0, board($t0) 				        # char first_cell = board[start_row][start_col];
	beq     $t0, CELL_EMPTY, check_line_return_winner_none          # if (first_cell == CELL_EMPTY) goto check_line_return_winner_none
									# if not, goto check_line_first_cell_beq_empty_f
check_line_first_cell_beq_empty_f:
	add     $t1, $a0, $a2   				        # int row = start_row + offset_row;
	add     $t2, $a1, $a3   				        # int col = start_col + offset_col;

check_line_i_init:
	li      $t3, CONNECT						#
	addi    $t3, $t3, -1        					#
	li      $t4, 0          				        # int i = 0;
	
check_line_i_cond:
	bge     $t4, $t3, check_line_i_false        	                # while (i < CONNECT - 1) goto check_line_i_body
									# if not, goto check_line_i_false
check_line_i_body:
	blt     $t1, 0, check_line_return_winner_none
	blt     $t2, 0, check_line_return_winner_none 		        # if (row < 0 || col < 0) goto check_line_return_winner_none
									# if not, goto check_line_row_lt_0_or_col_lt_0_f
check_line_row_lt_0_or_col_lt_0_f:
	lw      $t5, board_height					#
	bge     $t1, $t5, check_line_return_winner_none			#
	lw      $t5, board_width					#
	bge     $t2, $t5, check_line_return_winner_none       	        # if (row >= board_height || col >= board_width) goto check_line_return_winner_none
									# if not, goto check_line_row_bge_height_or_col_bge_width_f
check_line_row_bge_height_or_col_bge_width_f:
	mul     $t5, $t1, MAX_BOARD_WIDTH                               # row * MAX_BOARD_WIDTH
	add	$t5, $t5, $t2                                           # (row * MAX_BOARD_WIDTH) + col
	lb      $t5, board($t5) 				        # char cell = board[row][col];
	bne     $t5, $t0, check_line_return_winner_none       	        # if (cell != first_cell) goto

check_line_cell_bne_first_cell_f:
check_line_i_step:
	add     $t1, $t1, $a2   				        # row += offset_row;
	add     $t2, $t2, $a3   				        # col += offset_col;
	addi    $t4, $t4, 1                                             # i++;
	b       check_line_i_cond					# goto check_line_i_cond
	
check_line_i_false:
	bne     $t0, CELL_RED, check_line_first_cell_beq_red_f          # if (first_cell == CELL_RED) goto check_line_first_cell_beq_red
									# if not, goto check_line_first_cell_beq_red_f
check_line_first_cell_beq_red:
	li      $v0, WINNER_RED      			                # return WINNER_RED;
	b       check_line__epilogue					# goto check_line__epilogue
	
check_line_first_cell_beq_red_f:
	li      $v0, WINNER_YELLOW 				        # return WINNER_YELLOW;
	b       check_line__epilogue					# goto check_line__epilogue
	
check_line_return_winner_none:
	li      $v0, WINNER_NONE        			        # return WINNER_NONE;
	
check_line__epilogue:
	pop     $s1                                                     # | $s1
	pop     $s0                                                     # | $s0
	end							        # ends the current stack frame
	jr	$ra						        # return;


########################################################################
# .TEXT <is_board_full>
# YOU DO NOT NEED TO CHANGE THE IS_BOARD_FULL FUNCTION
	.text
is_board_full:
	# Args:     void
	# Returns:
	#   - $v0: bool
	#
	# Frame:    [$s2]
	# Uses:     [$v0, $t0, $t1, $t2, $t3]
	# Clobbers: [$v0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - `int row` in $t0
	#   - `int col` in $t1
	#
	# Structure:
	#   is_board_full
	#   -> [prologue]
	#   -> body
	#   -> loop_row_init
	#   -> loop_row_cond
	#   -> loop_row_body
	#     -> loop_col_init
	#     -> loop_col_cond
	#     -> loop_col_body
	#     -> loop_col_step
	#     -> loop_col_end
	#   -> loop_row_step
	#   -> loop_row_end
	#   -> [epilogue]

is_board_full__prologue:
	begin                                                           # begin a stack framee
	push    $s2                                                     # | $s2 
	
is_board_full__body:
	li	$v0, true

is_board_full__loop_row_init:
	li	$t0, 0						        # int row = 0;

is_board_full__loop_row_cond:
	lw	$t2, board_height
	bge	$t0, $t2, is_board_full__epilogue		        # if (row >= board_height) goto is_board_full__loop_row_end;

is_board_full__loop_row_body:
is_board_full__loop_col_init:
	li	$t1, 0						        # int col = 0;

is_board_full__loop_col_cond:
	lw	$t2, board_width
	bge	$t1, $t2, is_board_full__loop_col_end		        # if (col >= board_width) goto is_board_full__loop_col_end;

is_board_full__loop_col_body:
	mul	$t2, $t0, MAX_BOARD_WIDTH			        # row * MAX_BOARD_WIDTH
	add	$t2, $t2, $t1					        # row * MAX_BOARD_WIDTH + col
	lb	$t3, board($t2)					        # board[row][col];
	bne	$t3, CELL_EMPTY, is_board_full__loop_col_step	        # if (cell != CELL_EMPTY) goto is_board_full__loop_col_step;

	li	$v0, false
	b	is_board_full__epilogue				        # return false;

is_board_full__loop_col_step:
	addi	$t1, $t1, 1					        # col++;
	b	is_board_full__loop_col_cond			        # goto is_board_full__loop_col_cond;

is_board_full__loop_col_end:
is_board_full__loop_row_step:
	addi	$t0, $t0, 1					        # row++;
	b	is_board_full__loop_row_cond			        # goto is_board_full__loop_row_cond;

is_board_full__loop_row_end:
is_board_full__epilogue:
	pop     $s2                                                     # | $s2
	end							        # ends the current stack frame
	jr	$ra						        # return;


########################################################################
# .TEXT <print_board>
# YOU DO NOT NEED TO CHANGE THE PRINT_BOARD FUNCTION
	.text
print_board:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$s2]
	# Uses:     [$v0, $a0, $t0, $t1, $t2]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2]
	#
	# Locals:
	#   - `int col` in $t0
	#   - `int row` in $t0
	#   - `int col` in $t1
	#
	# Structure:
	#   print_board
	#   -> [prologue]
	#   -> body
	#   -> for_header_init
	#   -> for_header_cond
	#   -> for_header_body
	#   -> for_header_step
	#   -> for_header_post
	#   -> for_row_init
	#   -> for_row_cond
	#   -> for_row_body
	#     -> for_col_init
	#     -> for_col_cond
	#     -> for_col_body
	#     -> for_col_step
	#     -> for_col_post
	#   -> for_row_step
	#   -> for_row_post
	#   -> [epilogue]

print_board__prologue:
	begin                                                           # begin a stack framee
	push    $s2                                                     # | $s2 

print_board__body:
	li	$v0, 11						        # syscall 11: print_int
	la	$a0, '\n'
	syscall							        # printf("\n");

print_board__for_header_init:
	li	$t0, 0						        # int col = 0;

print_board__for_header_cond:
	lw	$t1, board_width
	blt	$t0, $t1, print_board__for_header_body		        # col < board_width;
	b	print_board__for_header_post

print_board__for_header_body:
	li	$v0, 1						        # syscall 1: print_int
	addiu	$a0, $t0, 1					        # col + 1
	syscall							        # printf("%d", col + 1);

	li	$v0, 11						        # syscall 11: print_character
	li	$a0, ' '
	syscall							        # printf(" ");

print_board__for_header_step:
	addiu	$t0, 1						        # col++
	b	print_board__for_header_cond

print_board__for_header_post:
	li	$v0, 11
	la	$a0, '\n'
	syscall							        # printf("\n");

print_board__for_row_init:
	li	$t0, 0						        # int row = 0;

print_board__for_row_cond:
	lw	$t1, board_height
	blt	$t0, $t1, print_board__for_row_body		        # row < board_height
	b	print_board__for_row_post

print_board__for_row_body:
print_board__for_col_init:
	li	$t1, 0						        # int col = 0;

print_board__for_col_cond:
	lw	$t2, board_width
	blt	$t1, $t2, print_board__for_col_body		        # col < board_width
	b	print_board__for_col_post

print_board__for_col_body:
	mul	$t2, $t0, MAX_BOARD_WIDTH
	add	$t2, $t1
	lb	$a0, board($t2)					        # board[row][col]

	li	$v0, 11						        # syscall 11: print_character
	syscall							        # printf("%c", board[row][col]);
	
	li	$v0, 11						        # syscall 11: print_character
	li	$a0, ' '
	syscall							        # printf(" ");

print_board__for_col_step:
	addiu	$t1, 1						        # col++;
	b	print_board__for_col_cond

print_board__for_col_post:
	li	$v0, 11						        # syscall 11: print_character
	li	$a0, '\n'
	syscall							        # printf("\n");

print_board__for_row_step:
	addiu	$t0, 1
	b	print_board__for_row_cond

print_board__for_row_post:
print_board__epilogue:
	pop     $s2                                                     # | $s2
	end							        # ends the current stack frame
	jr	$ra						        # return;
