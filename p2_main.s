########################################################################
# p2_main.s - Solver for Lights Out puzzle auxillary functions
#             CS 233 Fall 2020
#
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################

# // Constants
# #define MAX_GRIDSIZE = 16
# #define MAX_MAXDOTS = 15
#
# // puzzle question structure
# typedef struct {
#     int num_rows;
#     int num_cols;
#     int max_dots;
#     unsigned char board[MAX_GRIDSIZE * MAX_GRIDSIZE];
#     unsigned char dominos_used[MAX_MAXDOTS * MAX_MAXDOTS];
# } dominosa_question;
PRINT_INT = 1
PRINT_CHAR = 11

.data

puzzle1:
.word 2 1 1 # num_rows, cols, color
.byte 0 0 # board
.space 1000 # "remaining" board and dominos_used
# solution:
# T
# 1  1

puzzle2:
.word 1 2 1 # num_rows, cols, color
.byte 0 # board
.byte 0 
.space 1000
# solution:
# T
# 1 
# 1

puzzle3:
.word 2 3 3 # num_rows, cols, color
.byte 2 0 0 # board
.byte 0 1 1
.space 1000
# solution: 
# T
# 3  1  1  
# 3  5  5  

puzzle4: 
.word 1 12 3 # num_rows, cols, color
.byte 0 0 1 0 1 1 2 1 2 2 2 0 # board
.space 1000
# solution: 
# T
# 1  1  2  2  5  5  6  6  9  9  3  3  

puzzle5: 
.word 12 1 3 # num_rows, cols, color
.byte 0 0 1 0 1 1 2 1 2 2 2 0 # board
.space 1000
# solution: 
# T
# 1  
# 1  
# 2  
# 2  
# 5  
# 5  
# 6  
# 6  
# 9  
# 9  
# 3  
# 3  

puzzle6:
.word 4 5 4  # num_rows, cols, color
.byte 3 2 0 0 0 # board
.byte 1 1 1 1 2  
.byte 2 0 3 3 3 
.byte 1 0 3 2 2
.space 1000
# solution: 
# T
# 8 3 3  1  1  
# 8 2 6  6  12 
# 7 2 16 16 12 
# 7 4 4  11 11 

heap:   # this is actually a place to store solution, not heap
.space 1000

.text
# main function ########################################################
.globl main
main:
        sub         $sp, $sp, 4
        sw          $ra, 0($sp)   # save $ra on stack

# tests for slow_solve_dominosa ###################################
        # TEST 1
        la          $a0, puzzle1
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle1, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle1
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)

        li          $a0, 1000
        la          $a1, heap
        jal         zero

        # TEST 2
        la          $a0, puzzle2
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle2, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle2
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)

        li          $a0, 1000
        la          $a1, heap
        jal         zero

        # TEST 3
        la          $a0, puzzle3
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle3, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle3
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)

        li          $a0, 1000
        la          $a1, heap
        jal         zero

        # TEST 4
        la          $a0, puzzle4
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle4, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle4
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)

        li          $a0, 1000
        la          $a1, heap
        jal         zero

        # TEST 5
        la          $a0, puzzle5
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle5, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle5
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)
    
        li          $a0, 1000
        la          $a1, heap
        jal         zero

        # TEST 6
        la          $a0, puzzle6
        la          $a1, heap
        jal         slow_solve_dominosa  # slow_solve_dominosa(puzzle6, heap)
        move        $a0, $v0
        jal         print_bool_and_newline # Should print T on a single line
        la          $a0, puzzle6
        lw          $a1, 0($a0)
        lw          $a2, 4($a0)
        la          $a0, heap
        jal         print_board    # print_board(heap, #row, #col)

        li          $a0, 1000
        la          $a1, heap
        jal         zero

        lw          $ra, 0($sp)
        add         $sp, $sp, 4
        jr          $ra



# // zero out an array with given number of elements
# void zero(int num_elements, unsigned char* array) {
#     for (int i = 0; i < num_elements; i++) {
#         array[i] = 0;
#     }
# }
.text
.globl zero
zero:
        li      $t0, 0          # i = 0
zero_loop:
        bge     $t0, $a0, zero_end_loop
        add     $t1, $a1, $t0
        sb      $zero, 0($t1)
        add     $t0, $t0, 1
        j       zero_loop
zero_end_loop:
        jr      $ra


# // the slow solve entry function,
# // solution will appear in solution array
# // return value shows if the dominosa is solved or not
# int slow_solve_dominosa(dominosa_question* puzzle, unsigned char* solution) {
#     zero(puzzle->num_rows * puzzle->num_cols, solution);
#     zero(MAX_MAXDOTS * MAX_MAXDOTS, dominos_used);
#     return solve(puzzle, solution, 0, 0);
# }
# // end of solution
# /*** end of the solution to the puzzle ***/
.globl slow_solve_dominosa
slow_solve_dominosa:
        sub     $sp, $sp, 16
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)

        move    $s0, $a0
        move    $s1, $a1
        
#     zero(puzzle->num_rows * puzzle->num_cols, solution);
        lw      $t0, 0($s0)
        lw      $t1, 4($s0)
        mul     $a0, $t0, $t1
        jal     zero

#     zero(MAX_MAXDOTS * MAX_MAXDOTS, dominos_used);
        li      $a0, 255
        la      $a1, 264($s0)
        jal     zero

#     return solve(puzzle, solution, 0, 0);
        move    $a0, $s0
        move    $a1, $s1
        li      $a2, 0
        li      $a3, 0
        jal     solve

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        add     $sp, $sp, 16

        jr      $ra

# print char board ##########################################################
#
# argument $a0: pointer to start of 2d tiles array
# argument $a1: #rows for 2d array
# argument $a2: #cols for 2d array
print_board:
        sub     $sp, $sp, 24
        sw      $ra,  0($sp)        # save $ra on stack
        sw      $s0,  4($sp)        # save $s0 on stack
        sw      $s1,  8($sp)        # save $s1 on stack
        sw      $s2, 12($sp)        # save $s2 on stack
        sw      $s3, 16($sp)        # save $s3 on stack
        sw      $s4, 20($sp)        

        move    $s0, $a0            # base
        move    $s1, $a1            # rows
        move    $s4, $a2            # cols

        mul     $s2, $s4, $s1       # total length
        li      $s3, 0              # i=0
print_board_loop:
        bge     $s3, $s2, print_board_end 
        add     $t0, $s0, $s3       
        lb      $t0, 0($t0)         # tile to be printed

        move    $a0, $t0            
        jal     print_int_and_space # print tile

        addi    $s3, $s3, 1         # increment i
    
        div     $s3, $s4
        mfhi    $t0

        bne     $t0, $0, print_board_loop
        li      $a0, '\n'
        jal     print_char
        j       print_board_loop
print_board_end:
        lw      $ra,  0($sp)        # pop $ra from the stack
        lw      $s0,  4($sp)        # pop $s0 from the stack
        lw      $s1,  8($sp)        # pop $s1 from the stack
        lw      $s2, 12($sp)        # pop $s2 from the stack
        lw      $s3, 16($sp)        # pop $s3 from the stack
        lw      $s4, 20($sp)    
        add     $sp, $sp, 24
        jr      $ra

# argument $a0: number to print
.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print boolean and newline ##################################################
#
# argument $a0: boolean to print
.globl print_bool_and_newline
print_bool_and_newline:
	li      $t0, 'F'				 # FALSE
	beq     $a0, $0, print_char_and_newline_false
	li      $t0, 'T' 			 # TRUE
print_char_and_newline_false:
	move    $a0, $t0
	j       print_char_and_newline # Calling function in a slightly unusual, yet valid way

# print char and newline ##################################################
#
# argument $a0: number to print
.globl print_char_and_newline
print_char_and_newline:
	li	$v0, PRINT_CHAR		# load the syscall option for printing chars
	syscall					# print the number

	li   	$a0, '\n'      	# print a black space
	li	$v0, PRINT_CHAR		# load the syscall option for printing chars
	syscall					# print the char
	
	jr	$ra					# return to the calling procedure

# print char ###########################################################
#
# argument $a0: char to print
.globl print_char
print_char:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure
