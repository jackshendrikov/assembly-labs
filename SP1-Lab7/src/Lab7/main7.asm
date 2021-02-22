.586
.model flat, stdcall
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include module.inc
include longop.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

option casemap :none

.data
	Caption db "80!" ,0
	Caption1 db "Значення функції за варіантом" ,0

	textBuf dd 100 dup(?)
	textBuf1 dd 60 dup(?)

	var dd 25 dup(0)
	x dd 80
	y dd 0

	test1 dd 25 dup(4294967295)
	test1res dd 50 dup(0)

	test2 dd 25 dup(4294967295)

	test31 dd 25 dup(4294967295)
	test32 dd 25 dup(0)
	test3res dd 50 dup(0)

	
.code
	main:
	;Факторіал в десятковій формі
	mov [var], 1
	@fact:
		push offset var
		push x
		call Mul_Nx32_LONGOP 
	dec x
	jne @fact
		
	push offset textBuf
	push offset var
	push 400
	call Str_Dec
	invoke MessageBoxA, 0, ADDR textBuf, ADDR Caption, 0

	;Обчислення функції
	push -1320880352	; X
	push 4				; m
	call Func

	mov y, eax 

	push offset textBuf1
	push offset y
	push 32
	call Str_Dec

	invoke MessageBoxA, 0, ADDR textBuf1, ADDR Caption1, 0
	invoke ExitProcess,0
end main
