#program zamienia kolejnosc liter w stringu i wypisuje go potem
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
	
	#przydatna stala - ENTER, ktorego nie chcemy wypisywac na poczatku oraz liczba 2
	li $t0, '\n'
	li $t6, 2
	
	#liczymy znaki podanego tekstu w t5
	li $t5, 0
	#za³adowanie adresu pierwszego bajtu wczytanego stringa - t1 bêdzie pocz¹tkiem, a t2 koñcem
	la $t1, buf
	la $t2, buf
	lb $t3, ($t1)
	#sprawdzenie, czy uzytkownik cokolwiek wpisal
	beqz $t3, end
	
loop1:
	#dodajemy 1
	addi $t2, $t2, 1
	lb $t3, ($t2)
	
	#dodajemy 1 do liczby znaków
	addi $t5, $t5, 1	

	#sprawdzamy, czy to koniec stringu
	beqz $t3, next
	
	#przechodzimy do loop1
	j loop1
	
next:	
	#cofniecie t3 o 1, bo t2 stoimy na '\0'
	addi $t2, $t2, -1
	
	
	
	#ADDITIONAL: wypisanie tego, co jest $t5
	#li $v0, 1
	#add $a0, $t5, $zero
	#syscall	
	
loop2:
	#sprawdz, czy liczba znakow < 2
	blt $t5, $t6, end
	
	#za³adowanie
	lb $t4, ($t1)
	lb $t3, ($t2)	
				
	#tu robimy inwersje
	sb $t4, ($t2)
	sb $t3, ($t1)
	
	#przesuniêcie t1 i t2
	addi $t2, $t2, -1
	addi $t1, $t1, 1
	
	#odejmij 2 od liczby znakow
	addi $t5, $t5, -2
	
	#przeskocz do loop2
	j loop2
	
end:
	#wypisanie stringa uzytkownika
	li $v0, 4	
	la $a0, buf
	syscall
	#exit
	li $v0, 10
	syscall