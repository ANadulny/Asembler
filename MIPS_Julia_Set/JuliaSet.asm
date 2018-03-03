# projekt MIPS Adrian Nadulny
# zadanie 5: zbiory Julii
        	.data
nazwa:   	.asciiz "Zbiory Julii.bmp"      
zapytanie: 	.asciiz "Podaj szerokosc bitmapy.\n"
zapytanie2: 	.asciiz "Podaj wysokosc bitmapy.\n"
zapytanie3:	.asciiz "Podaj ilosc iteracji.\n"
		.align	2 # wyrownanie do 4 bajtow 
naglowek:	.space 56 # 00BM i dalej juz standardowo
		.text 
        	.globl main
  
main:  
	# t0 szerokosc
  	# t1 wysokosc
  	# t2 ilosc iteracji
 	# t3 szerokosc z paddingiem
  	# t4 rozmiar obrazka bmp
  	# t5 poczatek tablicy pikseli
  
  
 	# Szerokosc bitmapy
  	la 	$a0, zapytanie
  	li 	$v0, 4
  	syscall
  
  	li	$v0, 5
  	syscall
  	move	$t0, $v0 # zapamietuje szerokosc w rejestrze t0
  
  	# Wysokosc bitmapy
  	la 	$a0, zapytanie2
  	li 	$v0, 4
  	syscall
  
  	li	$v0, 5
  	syscall
 	move 	$t1, $v0 # zapamietuje wysokosc w rejestrze t1
  
  	# Liczba iteracji
  	la 	$a0, zapytanie3
  	li 	$v0, 4
  	syscall
  
  	li	$v0, 5
  	syscall
  	move 	$t2, $v0 # zapamietuje ilosc iteracji w rejestrze t2
  
  	# Wyznaczamy szerokosc obrazka z paddingiem
  	mulu 	$t3, $t0, 3
  	addu	$t3, $t3, 3
  	andi 	$t3, 0xFFFFFFFC # 0xFFFFFFFC daje nam 00 na koncu 
  	mulu 	$t4, $t3, $t1 # rozmiar obrazka bez naglowka
  
  
 	# Tworzenie naglowka pliku
	li	$k0, 'B'
	sb	$k0, naglowek+2
	li	$k0, 'M'
	sb	$k0, naglowek+3	
	addiu	$k0, $t4, 54
	sw	$k0, naglowek+4		# bfSize - dlugosc calego pliku w bajtach
	sw	$zero, naglowek+8	# bfReserved - pole zarezerwowane zwykle ma wartosc 0
	li	$k0, 54
	sw	$k0, naglowek+12	# bfOffBits - pozycja danych obrazkowych w pliku
	
	# Naglowek obrazu
	li	$k0, 40
	sw	$k0, naglowek+16	# biSize - wielkosc naglowka informacyjnego
	sw	$t0, naglowek+20	# biWidth - szerokosc obrazu w pikselach
	sw	$t1, naglowek+24	# biHeight - wysokosc obrazu w pikselach
	li	$k0, 1
	sh	$k0, naglowek+28	# biPlanes - liczba platow ( = 1 musi byc)
	li	$k0, 24
	sh	$k0, naglowek+30	# biBitCount - liczba bitow na piksel
	sw	$zero, naglowek+32	# biCompression - algorytm kompresji
	sw	$zero, naglowek+36	# biSizeImage - rozmiar samego rysunku
	sw	$zero, naglowek+40	# biXPixelsPerMeter - rozdzielczosc pozioma
	sw	$zero, naglowek+44	# biYPixelsPerMeter - rozdzielczosc pionowa
	sw	$zero, naglowek+48	# biClrUsed - liczba kolorow w palecie
	sw	$zero, naglowek+52	# biClrImportant - liczba waznych kolorow w palecie
  
    
  	#alokowanie miejsc
  	li	$v0, 9
  	la 	$a0, ($t4)
  	syscall
 	move 	$t5, $v0 # poczatek tablicy pikseli wskazanie w t5 zapamietane jest
  
  	# Z0 = 0^2 + C
  	# x1 -> $s0 czesc rzeczywista Z0
  	# y1 -> $s1 czesc urojona Z0
  
  	# C = x2 + y2
  	# x2 -> $s2 czesc rzeczywista
  	# y2 -> $s3 czesc urojona
  	
  	#	Przykladowe wartosci C dla obrazkow bmp
  	#
  	# set1
  	#li 	$s2, 0x00000
  	#li 	$s3, 0x00000
  	
  	# set2
  	#li 	$s2, 0x00000
  	#li 	$s3, 0x10000
  	
 	# set3 C = 1/4
  	#li 	$s2, 0x04000
  	#li 	$s3, 0x00000
 	
 	# set4 C = -3/4
  	#li 	$s2, 0xFFFF4000
  	#li 	$s3, 0x00000
  	
  	# set5 C = -1/8 +j* 3/4 
  	#li 	$s2, 0xFFFFE000
  	#li 	$s3, 0x0C000
 	
	# set6 C = ?1.375 
  	li 	$s2, 0xFFFEA000
  	li 	$s3, 0x00000
 	
  	# t7 iterator dla y
  	# t8 iterator dla x
  	la 	$t7, ($t1) # t1- wysokosc obrazka 
  	# a0 rejestr pomocniczy do obliczenia odwrotnosci szerokosci
  	li	$a0, 0x10000
  	div 	$a0, $a0, $t0
  	# a1 rejestr pomocniczy do obliczenia odwrotnosci wysokosci
  	li	$a1, 0x10000
  	div 	$a1, $a1, $t1
  	 
loopy:
	la	$t8, ($t0) # t0- szerokosc
	beqz	$t7, Koniec
	sub 	$t7, $t7, 1
	# t9 dla poczatku wartosci y
	sll	$t9, $t7, 2
	mulu	$t9, $t9, $a1
	sub	$t9, $t9, 0x20000
	
	
loopx:
	beqz	$t8, loopy
	sub 	$t8, $t8, 1
  	la	$s1, ($t9)
  	sll	$s0, $t8, 2 # s0 jest obecnie bez znaczenia dla nas bo obliczamy dla niego nowa wartosc 
	mulu	$s0, $s0, $a0
	sub	$s0, $s0, 0x20000
	# a2 bedzie trzymal wartosc rejestru t2(ilosc iteracji)- licznik iteracji
	la	$a2, ($t2)

loop:
  	# Zmniejszenie iteratora
  	sub 	$a2, $a2, 1  
  	
  	# Z = X + Y * j
  	# nowy X = x1^2 - y1^2 + x2
  	# s6 -> x1^2 
  	# s7 -> y1^2
  	# x1^2:
  	mul	$s6, $s0, $s0
  	mfhi    $s7
  	sll     $s7, $s7, 16
  	srl     $s6, $s6, 16
  	or      $s6, $s6, $s7
  
  	# y1^2:	
  	mul 	$s7, $s1, $s1
  	mfhi 	$k1
	sll 	$k1, $k1, 16 
  	srl 	$s7, $s7, 16 
  	or  	$s7, $s7, $k1
  
  	# nowy Y = 2*x1*y1 + y2
  	# k0 -> 2*x1*y1
  	# x1*y1
  	mul 	$k0, $s0, $s1
  	mfhi 	$k1
  	sll 	$k1, $k1, 16 
  	srl 	$k0, $k0, 16 
  	or  	$k0, $k1, $k0
  
  	# 2*x1*y1
  	sll 	$k0, $k0, 1 # przesuniecie w lewo o 1 bit
  
  	# wyznaczanie nowego X dla adresu s0
  	addu 	$s0, $zero, $s2
  	addu 	$s0, $s0, $s6
  	subu 	$s0, $s0, $s7

  
  	# wyznaczanie nowego Y dla adresu s1
  	addu 	$s1, $zero, $k0
  	addu 	$s1, $s1, $s3
        
        # warunek na pozostanie wewnatrz okregu
        # s6 - suma x^2 + y^2
        addu	$s6, $s6, $s7
        bgtu	$s6, 0x40000, wyznaczanie_pixela
  	bnez  	$a2, loop
  	

wyznaczanie_pixela:
  
  	# s4 X * 3
  	mulu 	$s4, $t8, 3 # 3 piksele
  	
  	# wyznaczenie Y * szerokosc_with_padding 	
  	# skalowanie przez wysokosc

  	mulu	$s5, $t7, $t3
  
  	addu 	$s4, $s4, $s5
  	addu 	$s4, $s4, $t5 # t5 poczatek tablicy pikseli
	
	bnez	$a2 , kolorowanie
	
#	li 	$s5, 0x00
#  	sb  	$s5, ($s4) # Niebieski
  
#  	li 	$s5, 0x00 # Zielony
#  	sb  	$s5, 1($s4)
  
#  	li 	$s5, 0x00 # Czerwony
#  	sb  	$s5, 2($s4)
 
 	b	loopx
 	
kolorowanie:
 	la	$s5, ($t2)
	subu 	$s5, $s5, $a2
	
	bgt	$s5, 35, kolor_35
	bgt	$s5, 25, kolor_25
	bgt	$s5, 20, kolor_20
	bgt	$s5, 10, kolor_10
	bgt	$s5, 5, kolor_5
	bgt	$s5, 2, kolor_3
	beq	$s5, 2, kolor_2
	beq	$s5, 1, kolor_1
	
kolor_35:
	li 	$s5, 0x00 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0xFF   # Zielony
  	sb  	$s5, 1($s4)
 
  	li 	$s5, 0xFF # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx	
	
kolor_25:
	li 	$s5, 0x00 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x00   # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0x8B # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx		
	
kolor_20:
	li 	$s5, 0xFA 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x80   # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0x72 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx	
	
kolor_10:
	li 	$s5, 0x80 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x00   # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0x80 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx	
	
kolor_5:
	li 	$s5, 0xFF 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0xB6  # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0xC1 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx

kolor_3:
	li 	$s5, 0xFF 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x69 # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0xB4 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx
kolor_2:
	li 	$s5, 0xFF 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x14  # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0x93 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx
kolor_1:
	li 	$s5, 0xC7 
  	sb  	$s5, ($s4) # Niebieski
  
  	li 	$s5, 0x15  # Zielony
  	sb  	$s5, 1($s4)
  
  	li 	$s5, 0x85 # Czerwony
  	sb  	$s5, 2($s4)
  	b	loopx

Koniec:  
	# Otwarcie plikudo zapisu
  	li	$v0, 13			
	la	$a0, nazwa		# nazwa pliku na wyjsciu
	li	$a1, 1			# zapisz
	li	$a2, 0			# ignoruj
	syscall
	move	$t7, $v0
	
	# Zapisanie naglowka do pliku
	li	$v0, 15		
	move	$a0, $t7
	la	$a1, naglowek+2
	li	$a2, 54
	syscall
	
	# Zapisanie obrazu do pliku
	li	$v0, 15		
	move	$a0, $t7
	la	$a1, ($t5)
	la	$a2, ($t4)
	syscall
	
	# Zamkniecie pliku
	li	$v0, 16		
	move	$a0, $t7
	syscall
	
	li	$v0, 10
	syscall	
