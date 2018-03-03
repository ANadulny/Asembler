#Zadanie - usuwamy cyfry
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
	la $t1,buf
	li $s0,'0'
	li $s1,'9'
loop:
	lb $t2,($t0)
	beqz $t2,end
	add $t0,$t0,1
	bgt $t2,$s1,movetop
	blt $t2,$s0,movetop
	j loop
movetop:
	sb $t2,($t1)
	add $t1,$t1,1
	j loop
end:
	sb $zero,($t1)
	li $v0,4
	la $a0,buf
	syscall
	li $v0,10
	syscall