.data
# Create a string to separate the 100 numbers with a space
numberArray: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

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


# generate 10 random integers in the range 100 from the 
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
beq	$t3, $t2, UpdateRestOfArray	# branch to EXIT if iterations is 10

# Do another iteration 
j	LOOP

EXIT:
li	$v0, 10		# exit syscall
syscall

UpdateRestOfArray:
li $t5, 6 		# Index to be modified (indexZ)
li $t6, 0		# Index to be added (index0)
li $t7, 1		# Other index to be added (index1)

LoopArray:
addi $t5, 1
addi $t6, 1
addi $t7, 1

la $t4, numberArray
sll $t6, $t6, 2		# Multiply index0 by 4
sll $t7, $t7, 2		# Multiply index1 by 4
sll $t5, $t5, 2		# Multiply indexZ by 4

add $t

