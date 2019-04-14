.data
	PlayAgain:	.asciiz	 "Would you like to play again? (y/n)\n"
	Return:		.asciiz  "\n"
	WrongInput:	.asciiz	 "Sorry, you can't enter "
	MagicNumber:	.asciiz	 "Abracadabra, your number is: "	
	
.text

Main:
	#Generate random number
	li	$v0, 42
	li	$a1, 6
	syscall
	
	#Lower bounds (1-6)
	add	$a0, $a0, 1
	
Cards:
###################################################
#
#	Check random number to see if it has
#	already been used. If it does then save
#	it. 
#
###################################################
	
	#Save the random number for comparisons 
	move	$a1, $a0

###################################################
#
#	Take $a1 and use it to generate & display
#	cards 1-6. By end of this we should
#	have the final num in $s1, and the 
#	register used to track all 6 card bit
#	positions should be $s0
#
###################################################

	#Placeholder
	addi	$s0, $zero, 63

	#$t9 = 111111
	addi	$t9, $zero, 63
	
	bne	$s0, $t9, Cards
	#Put the magic number in $s1
	addi	$s1, $zero, 69
###################################################
#
#	Print the number the user was thinking of,
#	which should be in $s1.
#
###################################################	
PrintFinalNumber:
	#Magic number prompt
	li      $v0, 4       
	la      $a0, MagicNumber
	syscall 
	
	move	$a0, $s1
	#Print the magic number in $s0
	li      $v0, 1      
	syscall 
	
	#Return for spacing
	li      $v0, 4       
	la      $a0, Return
	syscall 
	
###################################################
#
#	Ask the user if they want to play again
#	and compare input for branching.
#
###################################################	
AskPlayAgain:	
	#Ask user to play again
	li      $v0, 4       
	la      $a0, PlayAgain  
	syscall 
	
	#Get user char input
	li	$v0, 12
	syscall
	
	#Save char for comparisons
	move	$a2, $v0

	#$t0 = n, $t1 = y
	addi	$t0, $zero, 110
	addi	$t1, $zero, 121
	
	#Return for spacing
	li      $v0, 4       
	la      $a0, Return
	syscall 
	
	#Yes, No or Error
	beq	$t1, $a2, Main
	beq	$t0, $a2, End
	
###################################################	
#
#	If not 'y' or 'n', print back the input
#	and loop back to AskPlayAgain.
#
###################################################
Error:
	#Return for spacing
	li      $v0, 4       
	la      $a0, WrongInput
	syscall 
	
	move	$a0, $a2
	li	$v0, 11
	syscall
	
	#Return for spacing
	li      $v0, 4       
	la      $a0, Return
	syscall 
	
	j	AskPlayAgain
	
###################################################
#
#	End the program.
#
###################################################
End:
	li $v0, 10
	syscall
