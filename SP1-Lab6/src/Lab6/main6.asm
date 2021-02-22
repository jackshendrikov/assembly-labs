.586
.model flat, stdcall

option casemap :none
include \masm32\include\windows.inc
include module.inc
include longop.inc
include \masm32\include\kernel32.inc 
include \masm32\include\user32.inc  
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\user32.lib 

.data 
	mas db 128 dup(0)
	m dd 40
	n dd 7

	TextBuff1 db 256 dup(?)
	TextBuff2 db 302 dup(?)

	Caption1 db "Початкові дані" , 0
	Caption2 db "Вихідні дані", 0
.code
	main:
		 push offset TextBuff1
		 push offset mas
		 push 1024
		 call StrHex_MY

		 invoke MessageBox, 0, ADDR TextBuff1, ADDR Caption1, MB_ICONINFORMATION
		 push offset mas
		 push n
		 push m
		 call Write_1_LONGOP

		 push offset TextBuff2
		 push offset mas
		 push 1024
		 call StrHex_MY
		 
		 invoke MessageBox, 0, ADDR TextBuff2, ADDR Caption2, MB_ICONINFORMATION

		 invoke ExitProcess, 0
	end main
