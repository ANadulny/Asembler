.data
prompt: .asciiz "Enter string: \n"
swaplbl: .asciiz " /  - next/lowest. Swap done\n"
buf: .space 100

.text
.globl main
main:
	li $v0,4
	la $a0,prompt
	syscall
	li $v0,8
	la $a0,buf
	li $a1,100
	syscall
	li $t0,'\n'
	la $t2,buf #address for the buffer starting char
	la $t3,buf #address for the buffer considered char
	lb $t4,($t2) #gets first character - currently the lowest
	beqz $t4,end
	add $t6,$t2,0
loop:
	#t6 - ADDR of the lowest; t3 - ADDR of the current, t5 - VALUE of the current, t4 - value of the starting
	lb $t5,($t3)
	lb $t4,($t6)
	beq $t5,$t0,swap
	beqz $t5,swap
	add $t7,$t3,0
	add $t3,$t3,1
	bge $t5,$t4,loop
	add $t6,$t7,0 #this will happen if t5<t4 t4 is the lowest - $t6 is the address of the lowest
	bnez $t5,loop
swap:
	lb $t1,($t2) #get the value of currently first char to t1 (operations buffer)
	lb $t5,($t6)
	sb $t5,swaplbl+2
	sb $t5,($t2) #set value under t2 to the lowest letter
	sb $t1,($t6) #set value under t6 to the first letter
	add $t2,$t2,1
	add $t6,$t2,0
	add $t3,$t2,0
	lb $t7,($t2)
	sb $t7,swaplbl
	
	#li $v0,4
	#la $a0,swaplbl
	#syscall
	#la $a0,buf
	#syscall
	
	bnez $t7,loop
end:
	li $v0,4
	la $a0,buf
	syscall
	li $v0,10
	syscall
