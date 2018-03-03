#Program removes all non-small letters from the given string
.data
prompt: .asciiz "Enter string:\n"
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
	li $t6,'a'
	li $t7,'z'
loop:
	lb $t2,($t0)
	beqz $t2,end
	blt $t2,$t6,nexttop
	bgt $t2,$t7,nexttop
	lb $t2,($t0)
	sb $t2,($t1)
	add $t1,$t1,1
nexttop:
	add $t0,$t0,1
	bnez $t0,loop
end:
	li $v0,4
	la $a0,bufb
	syscall
	li $v0,10
	syscall
