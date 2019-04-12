.text

	addi $a1, $a1, 4
	#initilize t0 to 0 for card display loop
	li $t0, 0
	#t4 is to count keys per line for formatting
	li $t4, 0
displayCardLoop:
	#increment t0 for each iteration
	addi $t0, $t0, 1
	#if t0 contians the bit in a0 print the number
	#else loop back
	and $t1, $t0, $a1
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
	
end:
	li $v0, 10
	syscall
	
	
	