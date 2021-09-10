# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         
#     op_sub,         
#     op_mul,         
#     op_div,         
#     op_rem,         
#     op_neg,         
#     op_paren,
#     constant
# } node_type_t;

# typedef struct {
#     node_type_t type;
#     bool computed;
#     int value;
#     ast_node* left;
#     ast_node* right;
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:

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

		move $s0, $a0			#contains ast_node ptr
		bne $s0, 0, next_If		#branch if ast_node != NULL
		li $v0, 0
		j done
	
next_If:	lw $t0, 4($s0)		 	# node->computed
		bne $t0, 1, assignment
		lw $v0, 8($s0)
		j done
		
assignment:	lw $a0, 12($s0)			# node->left
		jal value
		move $s1, $v0			# int left = value(node->left)
	
		lw $a0, 16($s0)			# node->right
		jal value
		move $s2, $v0			# int right = value(node->right)

switches:	lw $t3, 0($s0)			# node->type
	
		bne $t3, 7, case1
		lw $v0, 8($s0)			# return node->value
		j done
	
case1:		bne $t3, 0, case2
		add $t4, $s1, $s2
		sw $t4, 8($s0)
		j broken

case2:		bne $t3, 1, case3
		sub $t4, $s1, $s2
		sw $t4, 8($s0)
		j broken

case3:		bne $t3, 2, case4
		mul $t4, $s1, $s2
		sw $t4, 8($s0)
		j broken
	
case4:		bne $t3, 3, case5
		div $t4, $s1, $s2
		sw $t4, 8($s0)
		j broken

case5:		bne $t3, 4, case6
		rem $t4, $s1, $s2
		sw $t4, 8($s0)
		j broken

case6:		bne $t3, 5, case7
		li $t6, 0
		sub $t4, $t6, $s1
		sw $t4, 8($s0)
		j broken

case7:		bne $t3, 6, broken
		sw $s1, 8($s0)
		j broken

broken:		li $t5, 1
		sw $t5, 4($s0)
		lw $v0, 8($s0)
	
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
