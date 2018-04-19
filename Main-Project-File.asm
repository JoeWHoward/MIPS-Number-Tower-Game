.data
# Create a string to separate the 28 numbers with a space
numberArray: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
symbolArray: .word 0, 0, 0, 0, 0, 0, 0
err: .asciiz "Incorrect!  Try again!\n"
space: .asciiz " "
bar: .asciiz "|"
nA: .asciiz "!"
nB: .asciiz "#"
nC: .asciiz "@"
nD: .asciiz "$"
nE: .asciiz "%"
nF: .asciiz "&"
nG: .asciiz "*"
userString: .asciiz
userInt: .word 0
endline: .asciiz "\n"

playPrompt: .asciiz "\n\nPlease enter the symbol of the block you would like to guess: "
playPrompt2: .asciiz "\nPlease enter the number you would like to guess: "
endGamePrompt: .asciiz "\nCongratulations!  You won the game!"

.text
##############################################################################
# Don't touch the code from HERE
##############################################################################

# get the time
	li	$v0, 30		# get time in milliseconds (as a 64-bit value)
	syscall

	move	$t0, $a0	# save the lower 32-bits of time

# seed the random generator (just once)
	li	$a0, 1		# random generator id (will be used later)
	move 	$a1, $t0	# seed from time
	li	$v0, 40		# seed random number generator syscall
	syscall

#############################
# 	TO HERE  	    #
#############################


# generate 7 random integers in the range 100 from the 
# seeded generator (whose id is 1)
	li	$t2, 8		# max number of iterations + 1
	li	$t3, 0		# current iteration number

LOOP:
	li	$a0, 1		# as said, this id is the same as random generator id
	li	$a1, 30		# upper bound of the range
	li	$v0, 42		# random int range
	syscall

# $a0 now holds the random number
	li $t5, 0
	la $t4, numberArray
	add $t5, $t3, $t5
	sll $t5, $t5, 2
	add $t4, $t4, $t5
	sw $a0, 0($t4)

# loop terminating condition
	addi	$t3, $t3, 1	# increment the number of iterations
	beq	$t3, $t2, start	# branch to EXIT if iterations is 10

# Do another iteration 
	j	LOOP

EXIT:
	j play
	li	$v0, 10		# exit syscall
	syscall
start:
	li $t0, 0
	
UpdateRowOneValues:
	bne $t0, 0, UpdateRowTwoValues # If the counter is 0, skip this module
	la $t4, numberArray # set base address in $t4
	addi $t5, $t4, 28 # $t5 = array[7]
	li $t9, 6 # Set max counter to 6
	j UpdateRowLoop # Loop it
	
UpdateRowTwoValues:
	bne $t0, 6, UpdateRowThreeValues # If the counter is 6, skip this module, etc.
	li $t9, 11 # Set max counter to 11
	addi $t4, $t4, 4 # Add 4 to address counter $t4 to go to next row
	j UpdateRowLoop
	
UpdateRowThreeValues:
	bne $t0, 11, UpdateRowFourValues
	li $t9, 15
	addi $t4, $t4, 4
	j UpdateRowLoop
	
UpdateRowFourValues:
	bne $t0, 15, UpdateRowFiveValues
	li $t9, 18
	addi $t4, $t4, 4
	j UpdateRowLoop
	
UpdateRowFiveValues:
	bne $t0, 18, UpdateRowSixValues
	li $t9, 20
	addi $t4, $t4, 4
	j UpdateRowLoop
	
UpdateRowSixValues:
	bne $t0, 20, UpdateRowSevenValues
	li $t9, 21
	addi $t4, $t4, 4
	j UpdateRowLoop
	
UpdateRowSevenValues:
	li $t9, 21
	addi $t4, $t4, 4
	j prePrint

UpdateRowLoop:
	
	lw $t1, 0($t4) # Storing index[0] into $t1
	addi $t4, $t4, 4 # Adding 4 to the address to increment index + 1 (ArrayAddr += 4)
	lw $t2, 0($t4) # Storing index[1] into $t2
	
	add $t2, $t1, $t2 # Add $t2 and $t1 and store in $t2
	sw $t2, 0($t5) # Store $t2 to 24($t4)
	
	addi $t5, $t5, 4
	addi $t0, $t0, 1 # Increment counter
	beq $t0, $t9, UpdateRowOneValues # Branch if max counter hit
	j UpdateRowLoop

prePrint:
	li $t9, -1 # set new counter to -1
	li $t8, 0 # set max counter to 0
	la $t4, numberArray # load base array address
	addi $t4, $t4, 108 # Set it to the last element in the array (array[28])
	li $t6, 0
print:
	j frontSpacing
	
fspaceReturn:
	addi $t6, $t6, 1
	addi $t9, $t9, 1 # Increment counter
	
	beq $t6, 2, numA
	beq $t6, 5, numB
	beq $t6, 9, numC 
	beq $t6, 13, numD
	beq $t6, 19, numE
	beq $t6, 20, numF
	beq $t6, 23, numG
	
next:

	li $v0, 1 # Get ready to print integer
	lw $a0, 0($t4) # print integer
	syscall

skip:
	j preSpacing
	
spaceReturn:
	subi $t4, $t4, 4 # Subtract 4 from index to move backwards one to array[i-4]
	bne $t9, $t8, fspaceReturn  # If counter doesnt = max counter, loop
	j line # else, print a new line

line:
	li $v0, 4 # Get ready to print string
	la $a0, endline # Print endline
	syscall
	
	addi $t8, $t8, 1 # Increment max_counter
	li $t9, -1 # Reset counter
	beq $t8, 7, play # If max counter = 6, exit
	j print
	
preSpacing:		 # Sets up registers to be used in spacing
	li $s0, 10 # Set s0 to 10 so we can divide numbers by it
	li $s1, 1 # Set s1 to 1 so we can compare with slt
	lw $t1, 0($t4) # set $t1 = current integer on the array
	li $t0, 0 # Reset $t0, the counter
check:
	div $t1, $s0 # Divide
	mflo $t1 # Get quotient, put it back in $t1
	slt $t2, $t1, $s1 # If quotient is less than 1, set $t2 to true
	addi $t0, $t0, 1 # Add to $t0, the counter
	bne $t2, 0, Spacing # If $t2 != 0, which is to say if the quotient is in fact less than 1, jump to spacing
	j check # loop

Spacing:
	beq $t0, 4, spaceReturn # If $t0 (which is the character count of the integer) is 4, skip
	li $v0, 4
	la $a0, space #Else, print space
	syscall
	
	addi $t0, $t0, 1 #And increment $t0
	j Spacing # Loop
	
frontSpacing:
	li $t3, 0 # Reset register
	add $t3, $t8, $t3 # Add the current row counter to $t3
	sll $t3, $t3, 1 # Multiply it by 2
	li $t5, 15 # Store 15
	sub $t3, $t5, $t3 # Subtract $t3 from 15 (for determining number of initial spaces needed)

frontSpacingLoop:
	li $v0, 4 # Make a space
	la $a0, space
	syscall
	
	subi $t3, $t3, 1 # Subtract 1 from $t3
	beq $t3, 0, fspaceReturn # When $t3 hits 0, all spaces are printed, return
	j frontSpacingLoop # loop

numA:
	la $t0, symbolArray # Store symbol array (Which holds values 0 or 1 based on if the number has been guessed yet)
	lw $t0, 0($t0) # Attempt to load the first word from the symbolArray
	li $t1, 1  # Set $t1 = 1
	beq $t0, $t1, next # Branch if equal 
	
	li $v0, 4 # Get ready to print 
	la $a0, nA # Print the hidden character
	syscall
	
	j numSpacing
	
numB:
	la $t0, symbolArray
	addi $t0, $t0, 4
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next

	li $v0, 4
	la $a0, nB
	syscall
	
	j numSpacing
numC:
	la $t0, symbolArray
	addi $t0, $t0, 8
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next
	
	li $v0, 4
	la $a0, nC
	syscall
	
	j numSpacing
numD:
	la $t0, symbolArray
	addi $t0, $t0, 12
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next
	
	li $v0, 4
	la $a0, nD
	syscall
	
	j numSpacing
numE:
	la $t0, symbolArray
	addi $t0, $t0, 16
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next
	
	li $v0, 4
	la $a0, nE
	syscall
	
	j numSpacing
numF:
	la $t0, symbolArray
	addi $t0, $t0, 20
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next
	
	li $v0, 4
	la $a0, nF
	syscall
	
	j numSpacing
numG:
	la $t0, symbolArray
	addi $t0, $t0, 24
	lw $t0, 0($t0)
	li $t1, 1
	beq $t0, $t1, next
	
	li $v0, 4
	la $a0, nG
	syscall
	
	j numSpacing
	
numSpacing: 	# Spacing function for non-integers (all the symbols)
	li $v0, 4 # Print string
	la $a0, space
	syscall
	syscall
	syscall
	
	j spaceReturn

play:		# Main play function, this is what drives user input
	li $v0, 4 # Print prompt
	li $t6, 0
	la $a0, playPrompt
	syscall

	li $v0, 12 # Read character from user
	syscall
	
	sw $v0, userString # Store character in userString variable
	
	lb $s6, userString # Load byte from userString
	
	li $v0, 4 # Print
	la $a0, playPrompt2
	syscall
	
	li $v0, 5 # Read integer
	syscall
	
	sw $v0, userInt # Store integer in userInt
	
	lb $a0, nA # Load the character into $a0
	li $a1, 0 # Set $a1 to 0
	beq $a0, $s6, update # If $a0 and $s6 are equal, go to update
	lb $a0, nB
	li $a1, 1
	beq $a0, $s6, update
	lb $a0, nC
	li $a1, 2
	beq $a0, $s6, update
	lb $a0, nD
	li $a1, 3
	beq $a0, $s6, update
	lb $a0, nE
	li $a1, 4
	beq $a0, $s6, update
	lb $a0, nF
	li $a1, 5
	beq $a0, $s6, update
	lb $a0, nG
	li $a1, 6
	beq $a0, $s6, update
	
	j errorMsg
	


update:
	beq $a1, 0, uA # Branch based on flag set
	beq $a1, 1, uB
	beq $a1, 2, uC
	beq $a1, 3, uD
	beq $a1, 4, uE
	beq $a1, 5, uF
	beq $a1, 6, uG
				
uA:
	la $t0, numberArray # Store address of numberArray in $t0
	addi $t0, $t0, 104 # Add 104 to access appropriate index
	lw $t0, 0($t0) # Pull value and keep it for comparison 
	lw $t1, userInt # Pull userInt and put it up for comparison
	beq $t1, $t0, postUpdate # Compare them
	j errorMsg
	
uB:
	la $t0, numberArray
	addi $t0, $t0, 92
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg
	
uC:
	la $t0, numberArray
	addi $t0, $t0, 76
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg
	
uD:
	la $t0, numberArray
	addi $t0, $t0, 60
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg
	
uE:
	la $t0, numberArray
	addi $t0, $t0, 36
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg
	
uF:
	la $t0, numberArray
	addi $t0, $t0, 32
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg
uG:
	la $t0, numberArray
	addi $t0, $t0, 20
	lw $t0, 0($t0)
	lw $t1, userInt
	beq $t1, $t0, postUpdate
	j errorMsg

errorMsg: # Standard error message
	li $v0, 4
	la $a0, err
	syscall
	j prePrint
	
postUpdate:
	la $t0, symbolArray # Get address of symbol array
	sll $a1, $a1, 2 # Multiply $a1 (index) by 4
	add $t0, $t0, $a1 # Add 'em
	li $t1, 1 # Set $t1 to 1
	sw $t1, 0($t0) # Store in the symbolArray as having been hit by the user
	
	jal preCheckForWin
	
	j prePrint

preCheckForWin: # Setting up necessary variables
	la $t0, symbolArray
	li $t1, 1
	
checkForWin:
	lw $t2, 0($t0) # load values from symbol array, if all are == 1, end the game
	bne $t2, $t1, prePrint
	lw $t2, 4($t0)
	bne $t2, $t1, prePrint
	lw $t2, 8($t0)
	bne $t2, $t1, prePrint
	lw $t2, 12($t0)
	bne $t2, $t1, prePrint
	lw $t2, 16($t0)
	bne $t2, $t1, prePrint
	lw $t2, 20($t0)
	bne $t2, $t1, prePrint
	lw $t2, 24($t0)
	bne $t2, $t1, prePrint
	
	j endGame
	
endGame:
	li $v0, 4 # end game and exit
	la $a0, endGamePrompt
	syscall
	li $v0, 10
	syscall
	
