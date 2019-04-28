.data
	PlayAgain:	.asciiz	 "Would you like to play again? (y/n)\n"
	Return:		.asciiz  "\n"
	WrongInput:	.asciiz	 "Sorry, you can't enter "
	MagicNumber:	.asciiz	 "Abracadabra, your number is: "
	CardQuestion:	.asciiz  "Was your number in the card? (y/n) \n"	
	
.text

	li $s1,0
Main:
 	# Initializing the Register $s1(Which contains the Magic Number) to zero.
	
	
	#Generate random number
	li	$v0, 42
	li	$a1, 6
	syscall
	
	
	beq $s0, 63, PrintFinalNumber
	
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

	move $t1, $a1
	#Holds the random variable
	li $t2, 1
	#Holds the incremented variable
	li $t3, 1
	#Holds the "card generated" bit representation variable

shiftLoop2:
	beq $t1, $t2, UsedCheck
	#if increment equals card random value, break from loop
	addi $t2, $t2, 1
	#increments by 1 each , the counter
	sll $t3, $t3, 1
	#increments "card used" representation
	j shiftLoop2
	
UsedCheck:
	and $t5, $s0, $t3
	bne $t5, $zero, Main
	add $s0, $s0, $t3
###################################################
#
#	Take $a1 and use it to generate & display
#	cards 1-6. By end of this we should
#	have the final num in $s1, and the 
#	register used to track all 6 card bit
#	positions should be $s0
#	DONE
###################################################
	#move the bit value
	move $t6, $t3
	#initilize t0 to 0 for card display loop
	li $t0, 0
	#t4 is to count keys per line for formatting
	li $t4, 0
displayCardLoop:
	#increment t0 for each iteration
	addi $t0, $t0, 1
	#if t0 contians the bit in a0 print the number
	#else loop back
	and $t1, $t0, $t6
	beq $t1, $zero, displayCardLoop
	
	#print the number
	li $v0, 1
	move $a0, $t0
	syscall
	
	#print a space (space is 32 in ascii)
	li $v0, 11
	li $a0, 32
	syscall
	
	#add 1 to t4 to count another key printed
	addi $t4, $t4, 1
	
	li $t3, 8
	#print a new line if t4 is divisable by 8
	divu $t4, $t3
	
	mfhi $t3
	#if a new line does not need to be displayed loop back to card display loop
	bnez $t3, displayCardLoop
	
	#print new line
	li $v0, 11
	li $a0, '\n'
	syscall
	
	#while the itertions are less then 63
	bne $t0, 63, displayCardLoop
###############################################
#	GET USER INPUT
#	TODO
###############################################
AskCard:	
	
	
    
   
    
    #Initializing the Register $s3 to 1(For allowing the shift left logical operations while updating the MAGICNUMBER in UpdateMagicNumberFunction.
		li $s3,1
    
    # Storing the values of chars 'y' and 'n' in Ascii in registers $t0,$t1 for comparing the inputs.
    # May required to change the Registers if they are already in use.
		li $t0,121
		li $t1,110
	
    #Asking the User for his input.
		li $v0,4
		la $a0,CardQuestion
		syscall
	
    # Storing the User input.  
		li $v0,12
		syscall
		move $a2,$v0
		
    # If the User input is 'y' Go to the function UpdateMagicNumber.
		beq $a2,$t0,UpdateMagicNumber
    
    # If the User input is 'n' Go to the function DoNotUpdateMagicNumber
		beq $a2,$t1,DoNotUpdateMagicNumber
    
    # If the UserInput does not match either 'y' or 'n'. Go to the Error Function. 
		j Error_2
		
  # Function for Updating the Magic Number.(i.e User Inputs 'y')
	UpdateMagicNumber:
    		subi $a1, $a1, 1
    # Shift the rightmost bit(Which is '1') by RandomNumber(Generated and stored in $a1) places.
		sllv $s3,$s3,$a1
    
    # Updating the Value of the Magic Number.
		add $s1,$s1,$s3
    
    # After Updating Go back to Generating Random Number again for next iteration.
    # May need to Check and Update the Function to which the Counter should go...
		j Main
	
  # Function when the user inputs 'n'. Need not update anything.
	DoNotUpdateMagicNumber:
  
    # Need Not update the MagicNumber. So go to Generating Random Number again for next iteration.
    # May need to Check and Update the Function to which the Counter should go...
		j Main
	
  # If the user inputs anything otherthan 'y' or 'n'.
	Error_2:
    # For getting the Space
		li $v0,4
		la $a0,Return
		syscall
		
    # For explaining the user that his input was wrong.
		li $v0,4
		la $a0, WrongInput
		syscall
		
    # For getting the Space.
		li $v0,4
		la $a0,Return
		syscall
    
    # For prompting the user to give the input again and going through the Loop to Update the MagicNumber.
		j Main
	
	
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
