.data
prompt: .asciiz "Enter string:\n"
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
	
	li $s0,' '
	li $s1,'a'
	li $s2,'z'
	la $t0,buf
	la $t1,buf
loop:
	lb $t3,($t0)
	beqz $t3,end
	add $t0,$t0,1
	beq $t3,$s0,loop
	blt $t3,$s1,next
	bgt $t3,$s2,next
	sub $t3,$t3,32
next:
	sb $t3,($t1)
	add $t1,$t1,1
	j loop
end:
	sb $zero,($t1)
	li $v0,4
	la $a0,buf
	syscall
	li $v0,10
	syscall
	