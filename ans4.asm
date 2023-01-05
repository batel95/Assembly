#Title:		answer 4 mmn 12							File name:	ans4.asm
#Author:	Batel
#Description:	Check if the code is legal
#			count the instruction and the registers
#Input:		TheCode: list code in hexa
#Output:	Table - how many times was: r-type, lw, sw, beq instruction, each register


############################################# Data segment #############################################
.data 
	TheCode:	.word	0x014b4820, 0x8d4c0000, 0xadcd0000, 0x12320000, 0x08100004, 0xffffffff
	
	RegCtrArr:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	InstCtrArr:	.word	0, 0, 0, 0	#RType, lw, sw, beq
	
	MsgErrOp:	.asciiz	"\nError - no opcode"
	MsgErrF:	.asciiz	"\nError - no funct"

	
	MsgRd0Reg:	.asciiz	"\nrd register is 0"
	MsgRt0Reg:	.asciiz	"\nin lw instruction rt register is 0"
	MsgBeqEq:	.asciiz	"\nin beq instruction, rt and rs registers are equals"
	
	MsgTitle:	.asciiz	"\ninst code / reg\t\tappearances"  
	
	EndR:		.asciiz "\nR-Type\t\t\t"
	EndLw:		.asciiz "\nlw\t\t\t"
	EndSw:		.asciiz "\nsw\t\t\t"
	EndBeq:		.asciiz "\nbeq\t\t\t"
	EndNewLine:	.asciiz "\n"
	EndTabs:	.asciiz "\t\t\t"
############################################# Code segment #############################################
.text
.globl main
		
#main program entry
main:

init:
#initilize registers counter array
initRegArr:
	li	$s0, 0 
	li	$s1, 128
	
zeroRegCtr:
	sw	$0, RegCtrArr($s0)
	addi	$s0, $s0, 4
	beq	$s0, $s1, zeroRegCtr
	
#initilize instruction counter array
initInstArr:
	li	$s0, 0 
	li	$s1, 16
	
zeroInstCtr:
	sw	$0, InstCtrArr($s0)
	addi	$s0, $s0, 4
	beq	$s0, $s1, zeroInstCtr

initVars:

	li	$s1, 0 
#pass the code	
loop:
	lw	$s2, TheCode($s1)
	addi	$s1, $s1, 4
	beq	$s2, 0xffffffff, print
	
	srl	$s3, $s2, 26
	beq	$s3, 0x0, rType
	beq	$s3, 0x23, iLw
	beq	$s3, 0x2b, iSw
	beq	$s3, 0x4, iBeq
	j	errNoOpCode
	
exit:
	li	$v0, 10		#exit program
	syscall
		
#R-Type instruction
rType:
	addi	$t0, $0, 0x3F
	and	$s3, $s2, $t0
	
funct:
	beq	$s3, 0x0, rTypeContinue
	beq	$s3, 0x2, rTypeContinue
	beq	$s3, 0x3, rTypeContinue
	beq	$s3, 0x8, rTypeContinue
	beq	$s3, 0x10, rTypeContinue
	beq	$s3, 0x12, rTypeContinue
	beq	$s3, 0x18, rTypeContinue
	beq	$s3, 0x19, rTypeContinue
	beq	$s3, 0x1a, rTypeContinue
	beq	$s3, 0x1b, rTypeContinue
	beq	$s3, 0x20, rTypeContinue
	beq	$s3, 0x21, rTypeContinue
	beq	$s3, 0x22, rTypeContinue
	beq	$s3, 0x23, rTypeContinue
	beq	$s3, 0x24, rTypeContinue
	beq	$s3, 0x25, rTypeContinue
	beq	$s3, 0x27, rTypeContinue
	beq	$s3, 0x2a, rTypeContinue
	beq	$s3, 0x2b, rTypeContinue
	j	errorFunct

rTypeContinue:
	lw	$t0, InstCtrArr
	addi	$t0, $t0, 1
	sw	$t0, InstCtrArr	
	
	move	$a0, $s2
	jal	find_rd
	
	beqz	$v0, rdRt0 

saveRd:
	li	$t0, 0
	mul	$t0, $v0, 4
	lw	$t1, RegCtrArr ($t0)
	addi	$t1, $t1, 1
	sw	$t1, InstCtrArr ($t0)
	
	move	$a0, $s2
	jal	find_rt_rs
	
	li	$t0, 0
	mul	$t0, $v0, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	li	$t0, 0
	mul	$t0, $v1, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	j	loop
	
rdRt0:
	la	$a0, MsgRd0Reg
	li	$v0, 4		#syscall 4 print a string
	syscall
	j	saveRd
	
	
iLw:
	lw	$t0, InstCtrArr + 4
	addi	$t0, $t0, 1
	sw	$t0, InstCtrArr + 4
	
	move	$a0, $s2
		
	jal	find_rt_rs
	
	li	$t0, 0
	mul	$t0, $v0, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	li	$t0, 0
	mul	$t0, $v1, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	beqz	$v1, lwRt0 
	
	j	loop
	
lwRt0:
	la	$a0, MsgRt0Reg
	li	$v0, 4		#syscall 4 print a string
	syscall
	j	loop
	
iSw:
	lw	$t0, InstCtrArr + 8
	addi	$t0, $t0, 1
	sw	$t0, InstCtrArr + 8
	
	move	$a0, $s2
			
	jal	find_rt_rs
	
	li	$t0, 0
	mul	$t0, $v0, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	li	$t0, 0
	mul	$t0, $v1, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	j	loop
	
iBeq:
	lw	$t0, InstCtrArr + 12
	addi	$t0, $t0, 1
	sw	$t0, InstCtrArr + 12
	
	move	$a0, $s2
		
	jal	find_rt_rs
	
	li	$t0, 0
	mul	$t0, $v0, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	li	$t0, 0
	mul	$t0, $v1, 4
	lw	$t1, RegCtrArr($t0)
	addi	$t1, $t1, 1
	sw	$t1, RegCtrArr ($t0)
	
	beq	$v0, $v1, eqBeq
	
	j	loop
	
eqBeq:
	la	$a0, MsgBeqEq
	li	$v0, 4		#syscall 4 print a string
	syscall
	j	loop
	
errNoOpCode:
	la	$a0, MsgErrOp	#Error - no opcode
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	j	loop
	
errorFunct:
	la	$a0, MsgErrF	#Error - no funct
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	j	loop
	
print:
	la	$a0, MsgTitle	#title:
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	la	$a0, EndR	#R-Type
	syscall
	
	lw	$a0, InstCtrArr	#times r-type
	li	$v0, 1		#syscall 1 print a int
	syscall
	
	la	$a0, EndLw	#lw
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	lw	$a0, InstCtrArr + 4	#times lw
	li	$v0, 1		#syscall 1 print a int
	syscall
	
	la	$a0, EndSw	#sw
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	lw	$a0, InstCtrArr + 8
	li	$v0, 1		#syscall 1 print a int
	syscall
	
	la	$a0, EndBeq	#beq
	li	$v0, 4		#syscall 4 print a string
	syscall
	
	lw	$a0, InstCtrArr + 12
	li	$v0, 1		#syscall 1 print a int
	syscall
	

printReg:
	li	$t0, 0
	li	$t1, 0

	
	loopReg:

		beq	$t0, 32, exit
		lw	$t2, RegCtrArr ($t1)
		beqz	$t2, continueLoopReg	#the register times is 0
		
		la	$a0, EndNewLine	#new line
		li	$v0, 4		#syscall 4 print a string
		syscall
	
		move	$a0, $t0	#the register num
		li	$v0, 1		#syscall 1 print a int
		syscall
		
		la	$a0, EndTabs	#tabs
		li	$v0, 4		#syscall 4 print a string
		syscall
		
		lw	$a0, RegCtrArr ($t1)	#the register times
		li	$v0, 1		#syscall 1 print a int
		syscall
		
	continueLoopReg:
		addi	$t0, $t0, 1
		addi	$t1, $t1, 4
		j	loopReg
		
#Procedure: find_rd
#input $a0=The instruction num
#Description find rd register
#output: $v0 the rd register

find_rd:
	li	$t3, 0x0000f800		#rd masking
	and	$t1, $a0, $t3		#do masking on rd
	srl	$v0, $t1, 11		#shift 11 bits - the register number will be in the right - find the number
	
	jr	$ra			#return to caller
	
#Procedure: find_rt_rs
#input $a0=The instruction num
#Description find rt and rs registers
#output: $v0 the rs register
#output: $v1 the rt register
	
find_rt_rs:
	li	$t0, 0x03e00000		#rs masking
	and	$t1, $a0, $t0		#do masking on rs
	srl	$v0, $t1, 21		#shift 21 bits - the register number will be in the right - find the number

	li	$t0, 0x001f0000		#rt masking
	and	$t1, $a0, $t0		#do masking on rt
	srl	$v1, $t1, 16		#shift 16 bits - the register number will be in the right - find the number
	
	jr	$ra			#return to caller
	
	addi	$t0, $t0, 0
	
