.data 0x10010000

AST1: .word 0x00000007 0x00000001 0x00000002 0x00000000 0x00000000
      .word 0x00000007 0x00000001 0x00000002 0x00000000 0x00000000
      .word 0x00000000 0x00000000 0x000041a7 0x10010000 0x10010014

AST1_HEAD: .word 0x10010028

AST2: .word 0x00000007 0x00000001 0x00000005 0x00000000 0x00000000
      .word 0x00000005 0x00000000 0x00074071 0x10010040 0x00000000
      .word 0x00000007 0x00000001 0x00000004 0x00000000 0x00000000
      .word 0x00000000 0x00000000 0x0009eb59 0x10010068 0x10010054
      .word 0x00000006 0x00000000 0x000e662a 0x1001007c 0x00000000
      .word 0x00000007 0x00000001 0x00000007 0x00000000 0x00000000
      .word 0x00000004 0x00000000 0x0001a982 0x10010090 0x100100a4
      .word 0x00000007 0x00000001 0x0000000c 0x00000000 0x00000000
      .word 0x00000007 0x00000001 0x00000008 0x00000000 0x00000000
      .word 0x00000003 0x00000000 0x00033948 0x100100cc 0x100100e0
      .word 0x00000007 0x00000001 0x00000009 0x00000000 0x00000000
      .word 0x00000002 0x00000000 0x00006b98 0x10010108 0x100100f4
      .word 0x00000000 0x00000000 0x000cfbbe 0x10010108 0x100100b8

AST2_HEAD: .word 0x10010130

AST3: .word 0x00000007 0x00000001 0x00000001 0x00000000 0x00000000
      .word 0x00000000 0x00000000 0x000bdec3 0x10010148 0x10010148
      .word 0x00000000 0x00000000 0x0003a08d 0x10010148 0x1001015c
      .word 0x00000000 0x00000000 0x00089cd8 0x10010170 0x10010148

AST3_HEAD: .word 0x10010184

AST4: .word 0x00000007 0x00000001 0x00000002 0x00000000 0x00000000
      .word 0x00000007 0x00000001 0x0000000a 0x00000000 0x00000000
      .word 0x00000007 0x00000001 0x00000001 0x00000000 0x00000000
      .word 0x00000000 0x00000000 0x0006af95 0x100101b0 0x100101c4
      .word 0x00000002 0x00000000 0x0007648c 0x1001019c 0x100101d8

AST4_HEAD: .word 0x100101ec

.text

main:

    sub     $sp, $sp, 4
    sw      $ra, 0($sp)

    ### TESTCASE 1 ###
    # Computing: 2 + 2
    la      $s0, AST1_HEAD
    lw      $s0, ($s0)
    move    $a0, $s0
    jal     value
    move    $s1, $v0

    # Check that head_node->computed is appropriately set
    # Expected: non-zero value
    lbu     $a0, 4($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that return value is appropriately set
    # Expected: 4
    move    $a0, $s1
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that head_node->value is appropriately set
    # Expected: 4
    lw      $a0, 8($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    ### TESTCASE 2 ###
    # Computing: 9 * 12 / 8 + (4 + -5) % 7
    # Note that this follows the Lab document's AST so division has higher priority than multiplication
    la      $s0, AST2_HEAD
    lw      $s0, ($s0)
    move    $a0, $s0
    jal     value
    move    $s1, $v0

    # Check that head_node->computed is appropriately set
    # Expected: non-zero value
    lbu     $a0, 4($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that return value is appropriately set
    # Expected: 8
    move    $a0, $s1
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that head_node->value is appropriately set
    # Expected: 8
    lw      $a0, 8($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    ### TESTCASE 3 ###
    # Computing: 1 + 1 + 1 + 1
    la      $s0, AST3_HEAD
    lw      $s0, ($s0)
    move    $a0, $s0
    jal     value
    move    $s1, $v0

    # Check that head_node->computed is appropriately set
    # Expected: non-zero value
    lbu     $a0, 4($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that return value is appropriately set
    # Expected: 4
    move    $a0, $s1
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that head_node->value is appropriately set
    # Expected: 4
    lw      $a0, 8($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    ### TESTCASE 4 ###
    # Computing 2 * 10 + 1 = 2 * 11 = 22. Here the AST computes the 10 + 1, contrary to typical order of operations.
    # Diagram:
    # *
    # | 2
    # | +
    #   | 10
    #   | 1
    la      $s0, AST4_HEAD
    lw      $s0, ($s0)
    move    $a0, $s0
    jal     value
    move    $s1, $v0

    # Check that completed is appropriately set
    # Expected: non-zero value
    lbu     $a0, 4($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that return value is appropriately set
    # Expected: 22
    move    $a0, $s1
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # Check that head_node->value is appropriately set
    # Expected: 22
    lw      $a0, 8($s0)
    li      $v0, 1
    syscall
    li      $a0, '\n'
    li      $v0, 11
    syscall

    # End of main

    lw      $ra, 0($sp)
    add     $sp, $sp, 4
    jr      $ra
