section .text
global countJuliaAsm
; ADRIAN NADULNY JULIA SET ;


countJuliaAsm:
	push rbp
	mov rbp, rsp

	; Moves a scalar single-precision floating-point value from the source operand
  	movss DWORD [rbp-68], xmm0  ; imgWidth
  	movss DWORD [rbp-72], xmm1  ; imgHeight
  	movss DWORD [rbp-76], xmm2  ; startX
  	movss DWORD [rbp-80], xmm3  ; endX
  	movss DWORD [rbp-84], xmm4  ; startY
  	movss DWORD [rbp-88], xmm5  ; endY
  	movss DWORD [rbp-92], xmm6  ; C_Re
  	movss DWORD [rbp-96], xmm7  ; C_Im

	mov QWORD [rbp-104], rdi	; unsigned int

	mov DWORD [rbp-24], 100		; const int Iteration = 100

  	movss xmm0, DWORD [rbp-80]	; endX
  	subss xmm0, DWORD [rbp-76]  ; startX
  	movss DWORD [rbp-28], xmm0  ; width

  	movss xmm0, DWORD [rbp-28]	; width
  	divss xmm0, DWORD [rbp-68]  ; imgWidth
  	movss DWORD [rbp-32], xmm0  ; ratioX

  	movss xmm0, DWORD [rbp-88]	; endY
  	subss xmm0, DWORD [rbp-84]  ; startY
  	movss DWORD [rbp-36], xmm0  ; height

  	movss xmm0, DWORD [rbp-36]	; height
  	divss xmm0, DWORD [rbp-72]  ; imgHeight
  	movss DWORD [rbp-40], xmm0  ; ratioY

  	mov DWORD [rbp-4], -1	; int x = -1

loop_x:
    add DWORD [rbp-4], 1    ; int x = 0
    cvtsi2ss xmm0, DWORD [rbp-4] ; Converts a signed double word integer
    movss xmm1, DWORD [rbp-68]   ; imgWidth
    ucomiss xmm1, xmm0           ; if(imgWidth > x)

    jbe end     ; jump if below or equal

    mov DWORD [rbp-8], -1    ; int y = -1

loop_y:
    add DWORD [rbp-8], 1    ; int y = 0
    cvtsi2ss xmm0, DWORD [rbp-8] ; Converts a signed double word integer
    movss xmm1, DWORD [rbp-72]   ; imgHeight
    ucomiss xmm1, xmm0           ; if(imgHeight > y)
    jbe loop_x

    cvtsi2ss xmm0, DWORD [rbp-4] ; x
    mulss xmm0, DWORD [rbp-32]   ; x * ratioX
    movss xmm1, DWORD [rbp-76]   ; startX
    addss xmm0, xmm1             ; x * ratioX + startX
    movss DWORD [rbp-12], xmm0   ; Z_Re

    cvtsi2ss xmm0, DWORD [rbp-8] ; y
    mulss xmm0, DWORD [rbp-40]   ; y * ratioY
    movss xmm1, DWORD [rbp-84]   ; startY
    addss xmm0, xmm1             ; y * ratioY + startY
    movss DWORD [rbp-16], xmm0   ; Z_Im

    pxor xmm0, xmm0              ; 0
    movss DWORD [rbp-44], xmm0   ; new_Z_Re

    pxor xmm0, xmm0              ; 0
    movss DWORD [rbp-48], xmm0   ; new_Z_Im


    mov DWORD [rbp-52], 4       ; diameter (r = 2)

    movss xmm0, DWORD [rbp-24]
    movss DWORD [rbp-20], xmm0  ; iterations

    ;;;;;;;;;;;;;;;
    ; mov DWORD [rbp-20], 100
    ;;;;;;;;;;;;;;
    add DWORD [rbp-20], 1

loop_iterations:
    sub DWORD [rbp-20], 1
    cmp DWORD [rbp-20], 0       ; if(iterations == 0)
    je color_choose

    movss xmm0, DWORD [rbp-12]  ; Z_Re
    mulss xmm0, DWORD [rbp-12]  ; Z_Re^2

    movss xmm1, DWORD [rbp-16]  ; Z_Im
    mulss xmm1, DWORD [rbp-16]  ; Z_Im^2

    subss xmm0, xmm1            ; Z_Re^2 - Z_Im^2

    movss xmm1, DWORD [rbp-92]  ; C_Re
    addss xmm0, xmm1            ; Z_Re^2 - Z_Im^2 + C_Re
    movss DWORD [rbp-44], xmm0  ; new_Z_Re = Z_Re^2 - Z_Im^2 + C_Re

    movss xmm0, DWORD [rbp-12]  ; Z_Re
    addss xmm0, xmm0            ; Z_Re + Z_Re
    mulss xmm0, DWORD [rbp-16]  ; 2 * Z_Re * Z_Im

    movss xmm1, DWORD [rbp-96]  ; C_Im
    addss xmm0, xmm1            ; 2 * Z_Re * Z_Im + C_Im
    movss DWORD [rbp-48], xmm0  ; new_Z_Im = 2 * Z_Re * Z_Im + C_Im

    movss xmm0, DWORD [rbp-44]  ; new_Z_Re
    movss DWORD [rbp-12], xmm0  ; Z_Re = new_Z_Re

    movss xmm0, DWORD [rbp-48]  ; new_Z_Im
    movss DWORD [rbp-16], xmm0  ; Z_Im = new_Z_Im


    movss xmm0, DWORD [rbp-12]  ; Z_Re
    movaps xmm1, xmm0
    mulss xmm1, DWORD [rbp-12]  ; Z_Re^2

    movss xmm0, DWORD [rbp-16]  ; Z_Im
    mulss xmm0, DWORD [rbp-16]  ; Z_Im^2

    addss xmm0, xmm1            ; Z_Re^2 + Z_Im^2
    cvtsi2ss xmm1, DWORD [rbp-52]   ; diameter = 4
    ucomiss xmm0, xmm1          ; Z_Re^2 + Z_Im^2 < 4
    jbe loop_iterations


color_choose:
    cvtsi2ss xmm0, DWORD [rbp-8]    ; y
    movaps xmm1, xmm0
    mulss xmm1, DWORD [rbp-68]      ; y * imgWidth
    cvtsi2ss xmm0, DWORD [rbp-4]    ; x
    addss xmm0, xmm1                ; y * imgWidth + x
    cvttss2si eax, xmm0
    mov DWORD [rbp-56], eax         ; index = y * imgWidth + x

    ;;;;;;;;;;;;;;;;;;;
    ; tmp = ITERATION - iterations

    mov eax, DWORD [rbp-24]
    sub eax, DWORD [rbp-20]
    mov DWORD [rbp-60], eax

    ;;;;;;;;;;;;;;;;;;;
    ; prepare index

    mov eax, DWORD [rbp-56]
    cdqe
    lea rdx, [0+rax*4]
    mov rax, QWORD [rbp-104]
    add rax, rdx

    cmp DWORD [rbp-20], 0           ; if(iterations == 0)
    je color_0

    cmp DWORD [rbp-60], 0
    je color_1

    cmp DWORD [rbp-60], 1
    je color_2

    cmp DWORD [rbp-60], 2
    je color_3

    cmp DWORD [rbp-60], 7
    jl color_4

    cmp DWORD [rbp-60], 16
    jl color_5

    cmp DWORD [rbp-60], 26
    jl color_6

    cmp DWORD [rbp-60], 51
    jl color_7

color_0:
    ;;;; pixel[index] ;;;;
    mov DWORD [rax], 0xFF000000
    jmp loop_y

color_1:
    mov DWORD [rax], 0xFFC71585
    jmp loop_y

color_2:
    mov DWORD [rax], 0xFF8B0000
    jmp loop_y

color_3:
    mov DWORD [rax], 0xFFFF4500
    jmp loop_y

color_4:
    mov DWORD [rax], 0xFFFFD700
    jmp loop_y

color_5:
    mov DWORD [rax], 0xFFADD8E6
    jmp loop_y

color_6:
    mov DWORD [rax], 0xFF0000FF
    jmp loop_y


color_7:
    mov DWORD [rax], 0xFFDB7093
    jmp loop_y

end:
    pop rbp
    ret
