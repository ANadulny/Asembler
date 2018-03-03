#Zadanie - odwracamy
.data
prompt: .asciiz "Enter string\n"
buf: .space 100
bufb: .space 100

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
	la $t0,buf
	la $t1,bufb
	li $t2,0 #counter
loop:
	lb $t3,($t0)
	add $t0,$t0,1
	add $t2,$t2,1
	bnez $t3,loop
	sub $t2,$t2,2
	sub $t0,$t0,2
loop2:
	sub $t2,$t2,1
	sub $t0,$t0,1
	lb $t3,($t0)
	sb $t3,($t1)
	add $t1,$t1,1
	bnez $t2,loop2
end:
	li $v0,4
	la $a0,bufb
	syscall
	li $v0,10
	syscall