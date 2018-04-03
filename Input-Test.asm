.data 
	verticalArrayVal: .word 0
	horizontalArrayVal: .word 0
	
	up: .byte 'w'
	left: .byte 'a'
	right: .byte 'd'
	down: .byte 's'

	newline: .asciiz "\n"
.text

#  Trying to get input from WASD instead othe arrow keys

loop:  
	jal spacing
	
	li $v0, 1
	lw $a0, verticalArrayVal
	syscall
	
	jal spacing
	
	li $v0, 1
	lw $a0, horizontalArrayVal
	syscall
	
	jal spacing

  	li   $v0, 12       
	syscall            # Read Character
	addiu $a0, $v0, 0  # $a0 gets the next char
	jal checkDirection
  	li   $v0, 11       
  	syscall            # Write Character
  	b loop
	nop
	
checkDirection:
	lb $t1, up
	beq $a0, $t1, directionUp
	lb $t1, left
	beq $a0, $t1, directionLeft
	lb $t1, right
	beq $a0, $t1, directionRight
	lb $t1, down
	beq $a0, $t1, directionDown
	
	j error
	
directionUp:
	lw $a0, verticalArrayVal
	la $a1, verticalArrayVal
	addi $a0, $a0, 1
	sw $a0, 0($a1)
	
	jr $ra
	
directionLeft:
	lw $a0, horizontalArrayVal
	la $a1, horizontalArrayVal
	addi $a0, $a0, -1
	sw $a0, 0($a1)
	
	jr $ra
	
directionRight:
	lw $a0, horizontalArrayVal
	la $a1, horizontalArrayVal
	addi $a0, $a0, 1
	sw $a0, 0($a1)
	
	jr $ra
	
directionDown:
	lw $a0, verticalArrayVal
	la $a1, verticalArrayVal
	addi $a0, $a0, -1
	sw $a0, 0($a1)
	
	jr $ra

error:
	break
	
spacing:
	li $v0, 4
	la $a0, newline
	syscall
	
	jr $ra