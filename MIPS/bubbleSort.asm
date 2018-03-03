#Program that sorts a string descending using BubbleSort algorithm
.data
prompt: .asciiz "Enter string \n"
buf: .space 100

.text
.globl main
main:
	li $v0,4
	la $a0,prompt
	syscall
	li $v0,8
	la $a0,buf
	la $a1,100
	syscall
	li $t0,0 #changes counter
	li $s0,'\n'
	la $t1,buf
	la $t2,buf+1
loop:
	lb $t3,($t1) #value for the first char
	lb $t4,($t2) #value for the second char
	beq $t4,$s0,checkchanges
	beqz $t4,checkchanges
	blt $t4,$t3,swap
	add $t1,$t1,1
	add $t2,$t2,1
	j loop
swap:
	sb $t4,($t1)
	sb $t3,($t2)
	add $t1,$t1,1
	add $t2,$t2,1
	add $t0,$t0,1
	li $v0,4
	la $a0,buf
	syscall
	j loop
	
checkchanges:
	beqz $t0,end
	li $t0,0 #reset changes counter
	la $t1,buf
	la $t2,buf+1
	j loop
end:
	li $v0,4
	la $a0,buf
	syscall
	li $v0,10
	syscall