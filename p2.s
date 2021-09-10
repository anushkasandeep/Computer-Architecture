# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:
	bge $a0, $a1, else			# dots1 < dots2
	mul $t0, $a2, $a0
	add $t0, $t0, $a1
	addi $t0, $t0, 1
	move $v0, $t0
	j doneFr
	
else:
	mul $t0, $a2, $a1
	add $t0, $t0, $a0
	addi $t0, $t0, 1
	move $v0, $t0
	j doneFr
doneFr:	
        jr      $ra

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];

	
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
	
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
			sub $sp, $sp, 36
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $s2, 8($sp)
			sw $s3, 12($sp)
			sw $s4, 16($sp)
			sw $s5, 20($sp)
			sw $s6, 24($sp)
			sw $s7, 28($sp)
			sw $ra, 32($sp)
		
			
			move $s0, $a0			# stores puzzle
			move $s1, $a1			# solution
			move $s2, $a2			# row
			move $s3, $a3 			# col
			lw $t0, 0($s0)			# num_rows
			lw $t1, 4($s0)			# num_cols
			lw $t2, 8($s0)			# max_dots

			mul $s7, $s2, $t1
			add $s7, $s7, $s3		# row * num_cols + col

			addi $t6, $t1, -1		# num_cols-1
			bne $s3, $t6, noRow
			addi $s4, $s2, 1		# next_row = row + 1
			j contAss
	
noRow:			move $s4, $s2			# next_row = row
	
contAss:		addi $s5, $s3, 1
			rem $s5, $s5, $t1		# next_col

			li $t7, 256
			addi $t7, $t7, 12
			add $t7, $t7, $s0
			lbu $t3, 0($t7)			# dominos_used

			blt $s2, $t0, nextCondition
			li $v0, 1
			j done
	
nextCondition:		blt $s3, $t1, nextIf
			li $v0, 1
			j done
	
nextIf:			add $t6, $s7, $s1
			lbu $t6, 0($t6)
			beq $t6, 0, noRecurse
			move $a0, $s0
			move $a1, $s1
			move $a2, $s4
			move $a3, $s5
			jal solve

			j done
	
noRecurse:		
			addi $t4, $s7, 12
			add $t4, $t4, $s0
			lbu $t4, 0($t4)			# curr_dots

rowRecurse:		sub $t6, $t0, 1
			bge $s2, $t6, colRecurse
			addi $t5, $s2, 1
			mul $t5, $t5, $t1
			add $t5, $t5, $s3		# (row + 1)*num_cols + col
	
			add $t7, $s1, $t5
			lbu $t7, 0($t7)
			bne $t7, 0, colRecurse

			addi $t5, $t5, 12
			add $t5, $s0, $t5
			lbu $t6, 0($t5)			# CLEAR		

			move $a0, $t4
			move $a1, $t6
			move $a2, $t2

			jal encode_domino
			move $s6, $v0			# domino_code

			addi $t3, $s6, 268
			add $t3, $t3, $s0
			lbu $t6, 0($t3)			# dominos_used[domino_code]

			bne $t6, 0, colRecurse		# dom_used[dom_code] = 1
			li $t7, 1
			sb $t7, 0($t3)
			
			add $t0, $s7, $s1
			sb $s6, 0($t0)
	
			addi $t7, $s2, 1		# row + 1
			lw $t1, 4($s0)			# num_cols
			mul $t1, $t7, $t1
			add $t5, $t1, $s3		# (row+1)*num_cols + col
			add $t4, $t5, $s1
			sb $s6, 0($t4)

			move $a0, $s0
			move $a1, $s1
			move $a2, $s4
			move $a3, $s5
			jal solve
			move $t6, $v0
			bne $t6, 1, newAss
			li $v0, 1
			j done
	
newAss:			addi $t3, $s6, 268
			add $t3, $t3, $s0		# dominos_used[domino_code]
			li $t0, 0
			sb $t0, 0($t3)			

			add $t5, $s1, $s7
			sb $t0, 0($t5)

			addi $t2, $s2, 1
			lw $t4, 4($s0)
			mul $t1, $t4, $t2
			add $t1, $t1, $s3
			add $t1, $s1, $t1
			sb $t0, 0($t1)
			j colRecurse
			
colRecurse:		lw $t1, 4($s0)			# num_cols
			sub $t6, $t1, 1
			bge $s3, $t6, return0
			mul $t5, $s2, $t1
			add $t5, $t5, $s3
			addi $t5, $t5, 1		# row*num_cols + (col + 1)
			add $t6, $t5, $s1
			lbu $t6, 0($t6)
			bne $t6, 0, return0

			addi $t4, $s7, 12
			add $t4, $t4, $s0
			lbu $t4, 0($t4)			# curr_dots
			move $a0, $t4

			add $t3, $t5, 12
			add $t3, $t3, $s0
			lbu $t3, 0($t3)			# puzzle->board[row*num_cols+col+1
			move $a1, $t3
	
			lw $a2, 8($s0)
			jal encode_domino
			move $s6, $v0			# domino_code

			addi $t3, $s6, 268
			add $t3, $t3, $s0
			lbu $t6, 0($t3)			# dominos_used[domino_code]
	
			bne $t6, 0, return0
			li $t7, 1
			sb $t7, 0($t3)
	
			add $t0, $s7, $s1
			sb $s6, 0($t0)

			lw $t1, 4($s0)
			mul $t5, $s2, $t1
			add $t5, $t5, $s3
			addi $t5, $t5, 1		# row*num_cols + (col + 1)
			add $t4, $t5, $s1
			sb $s6, 0($t4)

			move $a0, $s0
			move $a1, $s1
			move $a2, $s4
			move $a3, $s5
			jal solve
			move $t6, $v0
			bne $t6, 1, lastAss
			li $v0, 1
			j done
		
lastAss:		addi $t3, $s6, 268
			add $t3, $t3, $s0		# dominos_used[domino_code]
			li $t0, 0
			sb $t0, 0($t3)			

			add $t5, $s1, $s7
			sb $t0, 0($t5)
			
			lw $t1, 4($s0)
			mul $t1, $t1, $s2
			add $t1, $t1, $s3
			addi $t1, $t1, 1
			add $t1, $t1, $s1
			sb $t0, 0($t1)
					
return0:		li $v0, 0
			j done
			
						
done:
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			lw $s6, 24($sp)
			lw $s7, 28($sp)
			lw $ra, 32($sp)
			add $sp, $sp, 36
        		jr      $ra
