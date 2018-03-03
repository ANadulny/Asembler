#Zadanie małe na duże - duże na małe
.data
prompt: .asciiz "Enter string\n"
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
	la $t0,buf
	li $s0,'a'
	li $s1,'z'
	li $s2,'A'
	li $s3,'Z'
loop:
	lb $t1,($t0)
	beqz $t1,end
	blt $t1,$s2,next
	bgt $t1,$s1,next
	bgt $t1,$s3,tocap #większe niż Z
	# blt $t1,$s0,tosmall
tosmall:
	add $t1,$t1,32
	j next
next:
	sb $t1,($t0)
	add $t0,$t0,1
	j loop
tocap:
	sub $t1,$t1,32
	j next
end:
	li $v0,4
	la $a0,buf
	syscall
	li $v0,10
	syscall
	
	
