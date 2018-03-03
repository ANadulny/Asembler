#program dla ka¿dej czwórki znaków zamienia: 1 z 3 i 2 z 4
.data
prompt:	.asciiz "Enter a string\n"
buf:	.space 100
.text
.globl main
main:
	#wypisanie stringu na ekran
	li $v0, 4	
	la $a0, prompt
	syscall
	#wczytanie stringu od uzytkownika
	la $a0, buf
	li $a1, 100
	li $v0, 8
	syscall
	
	li $t7, '\n'
	
	la $t0, buf
	la $t1, buf
	la $t3, buf
	la $t4, buf
	
check:
	lb $t5, ($t0)
	beqz $t5, end
	beq $t5, $t7, end
	
	addi $t1, $t0, 1
	lb $t5, ($t1)
	beqz $t5, end
	beq $t5, $t7, end
	
	addi $t2, $t0, 2
	lb $t5, ($t2)
	beqz $t5, end
	beq $t5, $t7, end
	
	addi $t3, $t0, 3
	lb $t5, ($t3)
	beqz $t5, end
	beq $t5, $t7, end
	
	#zamiana 4 z 2
	lb $t6, ($t1)
	sb $t6, ($t3)
	sb $t5, ($t1)
	
	#zamiana 2 z 3
	lb $t6, ($t0)
	lb $t5, ($t2)
	sb $t6, ($t2)
	sb $t5, ($t0)
	
	#przenisienie na poczatek kolejnej 4	
	addi $t0, $t3, 1
	addi $t1, $t0, 0
	addi $t2, $t0, 0
	addi $t3, $t0, 0
	
	j check
	
end:
	#wypisanie stringa uzytkownika
	li $v0, 4	
	la $a0, buf
	syscall
	#exit
	li $v0, 10
	syscall