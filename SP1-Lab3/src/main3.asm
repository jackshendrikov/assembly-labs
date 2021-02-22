.586
.model flat, stdcall

option casemap : none; розрізнювати великі та маленькі букви

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

include module.inc

includelib \lib\kernel32.lib
includelib \lib\user32.lib

.data
TextBuf db 64 dup(? )
Caption db "Лабораторна робота №3", 0
Text db "Hello!", 10, 13, "Автор: Шендріков Євгеній, ІО-82", 0


value1 db 35; ціле 8 - бітове
value2 db - 35; ціле 8 - бітове
value3 dw 35; ціле 16 - бітове
value4 dw - 35; ціле 16 - бітове
value5 dd 35; ціле 32 - бітове
value6 dd - 35; ціле 32 - бітове
value7 dq 35; ціле 64 - бітове
value8 dq - 35; ціле 64 - бітове
value9 dd 35.0; Число у 32 - бітовому форматі з плаваючою точкою
value10 dd - 35.0; Число у 32 - бітовому форматі з плаваючою точкою
value11 dd 35.35; Число у 32 - бітовому форматі з плаваючою точкою
value12 dq 35.0; Число у 64 - бітовому форматі з плаваючою точкою
value13 dq - 70.0; Число у 64 - бітовому форматі з плаваючою точкою
value14 dq 35.35; Число у 64 - бітовому форматі з плаваючою точкою
value15 dt 35.0; Число у 80 - бітовому форматі з плаваючою точкою
value16 dt - 70.0; Число у 80 - бітовому форматі з плаваючою точкою
value17 dt 35.35; Число у 80 - бітовому форматі з плаваючою точкою

.code

main :
invoke MessageBoxA, 0, ADDR Text, ADDR Caption, 0

push offset TextBuf
push offset value1
push 8
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value2
push 8
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value3
push 16
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value4
push 16
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value5
push 32
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value6
push 32
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value7
push 64
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value8
push 64
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value9
push 32
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value10
push 32
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value11
push 32
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value12
push 64
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value13
push 64
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value14
push 64
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value15
push 80
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value16
push 80
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0

push offset TextBuf
push offset value17
push 80
call StrHex_MY
invoke MessageBoxA, 0, ADDR TextBuf, ADDR Caption, 0


invoke ExitProcess, 0
end main
