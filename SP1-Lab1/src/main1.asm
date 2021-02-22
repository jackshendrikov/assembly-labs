.386
.model flat, stdcall

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
 Caption db "Assembler programm" , 0
 Text db "Шендріков Євгеній Олександрович" ,13 ,10, "ІО-82", 13, 10, "2020", 0

.code
start:
 invoke MessageBoxA, 0, ADDR Text, ADDR Caption, 0
 invoke ExitProcess, 0
end start
