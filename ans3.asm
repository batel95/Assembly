#Title:		answer 3 mmn 12							File name:	ans3.asm
#Author:	Batel
#Description:	Compare a string and print
#			+ if the early character bigger then the later,
#			= if them equals and - if the early character smaller then the later.
#Input:		buf: a string with up to 20 characters
#Output:	buf1: a string with up to 19 characters - the result of buf compare


############################################# Data segment #############################################
.data
	buf:	.space	21	#to keep the input
	buf1:	.space	20	#to keep the result
	
	msgS:	.asciiz	"\nPlease enter up to 20 characters"			#ask the user to enter the input
	msgOp:	.asciiz	"\nThe number of identical char in a row is: "	#answer 2
	
	msgE:	.asciiz	"\nERROR - The input string is empty"
	msg1:	.asciiz "\nERROR - The input include only 1 character - can not compare characters"

############################################# Code segment #############################################

#Registers:
#		$to	keep place early character in buf
#		$t1	keep place later character in buf string
#		$t2	equals counter - how many equal caracters there are
#		$t3	temporery keep characters
#		$s0	early character in buf
#		$s1	later character in buf string
#		$s2	result compare between $s0 and $s1


.text	
.globl main
		
#main program entry
main:
init:
	li	$t0, 0		#keep place first character in buf string
	li	$t1, 1		#keep place second character in buf string
	li	$t2, 0		#equals counter - how many equal caracters there are.
	
	
askInput:			#ask the user to enter the input
	la	$a0, msgS	#Please enter up to 20 characters
	li	$v0, 4		#syscall 4 print a string
	syscall
	
input:				#get the input	
	la	$a0, buf	#input buffer
	li	$a1, 21		#max length 20 (for stop)
	li	$v0, 8		#syscall 8 get a string from the user
	syscall
checkErr:			#Check if the input is not comparable	
	lb	$s0,buf($t0)	#load the first character to s0
	beq 	$s0,0xa,empty	#if thr first character is new line - the input is empty 
	lb	$s1,buf($t1)	#load the second character to s1
	beq 	$s1,0xa,only1	#if the second character is new line - the input include only 1 character 

loop:				#start the loop to pass the input string
compare:			#compare between 2 characters
	beq	$s0, $s1, equal	#characters are equals - go to equal lable
	slt	$s2, $s0, $s1	#characters are not equals - if the first character smaller then the second - s2 = 1, else s2 = 0
	beqz	$s2, bigger	#if s2 = 0, the first character is bigger, go to bigger lable
	j	smaller		#else, the first character is smaller - go to smaller lable
	
equal:				#the characters are equals
	li	$t3, '='	
	sb	$t3, buf1($t0)	#add = to buf1
	addi	$t2, $t2, 1	#add 1 to the equals counter
	j	continue	#continue the loop

bigger:				#if the first charcter bigger then the second
	li	$t3, '+'	
	sb	$t3, buf1($t0)	#add + to the buf1
	j	continue	#continue the loop
smaller:			#if the first charcter smaller then the second   
	li	$t3, '-'
	sb	$t3, buf1($t0)	#add - to the buf1
	j	continue	#continue the loop
	
continue:			#check if the loop finish
	beq	$t1, 19, print	#if t1 is in the last character - print the answers
	addi	$t0, $t0, 1	#else: t0++
	addi	$t1, $t1, 1	#t1++
	lb	$s0,buf($t0)	#load the t0 character to s0
	lb	$s1,buf($t1)	#load the t1 character to s1
	beq 	$s1,0xa,print	#if the character in s1 in new line - the input end, print the answer
	j	loop		#else - continue the loop
	
print:				#print the answers in the end of the program
a:
	li	$t3, 0x0	
	sb	$t3, buf1($t0)	#load null to the end of buf1 string
	la	$a0, buf1	#load buf1 to print it
	li	$v0, 4		#syscall 4 print a string
	syscall
	
b:	
	la	$a0, msgOp	#The number of identical char in a row is: 
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	move	$a0, $t2	#equals counter
	li	$v0, 1		#syscall 1 print a int
	syscall

exit:
	li	$v0, 10		#exit program
	syscall
	
errors:
empty:				#the input is empty
	la	$a0, msgE	#the input is empty
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	j	exit		#exit program
	
only1:				#The input include only 1 character - can not compare caracters
	la	$a0, msg1	#the input include only 1 character
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	j	exit		#exit program
