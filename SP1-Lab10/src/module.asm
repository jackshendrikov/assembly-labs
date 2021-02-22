.586
.model flat, c
.data 
	x dd 0h
	x1 dd 0h
	x2 dd 0h
	b dd 0
	fractionalPart db ?
	two dd 2
	buf dd 80 dup(0)
	decCode db ?
	buffer dd 128 dup(?)


.code
;процедура StrHex_MY записує текст шістнадцятькового коду
;перший параметр - адреса буфера результату (рядка символів)
;другий параметр - адреса числа
;третій параметр - розрядність числа у бітах (має бути кратна 8)
StrHex_MY proc proc bits:DWORD, src:DWORD, dest:DWORD

mov ecx, bits ;кількість бітів числа
cmp ecx, 0
jle @exitp
shr ecx, 3 ;кількість байтів числа
mov esi, src ;адреса числа
mov ebx, dest ;адреса буфера результату
@cycle:
mov dl, byte ptr[esi+ecx-1] ;байт числа - це дві hex-цифри
mov al, dl
shr al, 4 ;старша цифра
call HexSymbol_MY
mov byte ptr[ebx], al
mov al, dl ;молодша цифра
call HexSymbol_MY
mov byte ptr[ebx+1], al
mov eax, ecx
cmp eax, 4
jle @next
dec eax
and eax, 3 ;проміжок розділює групи по вісім цифр
cmp al, 0
jne @next
mov byte ptr[ebx+2], 32 ;код символа проміжку
inc ebx
@next:
add ebx, 2
dec ecx
jnz @cycle
mov byte ptr[ebx], 0 ;рядок закінчується нулем
@exitp:

ret 
StrHex_MY endp
;ця процедура обчислює код hex-цифри
;параметр - значення AL
;результат -> AL

HexSymbol_MY proc
and al, 0Fh
add al, 48 ;так можна тільки для цифр 0-9
cmp al, 58
jl @exitp
add al, 7 ;для цифр A,B,C,D,E,F
@exitp:

ret
HexSymbol_MY endp

StrToDec proc bytesOnScreen: dword, numberOfDd: dword, decCodeLocal: dword, strCodeLocal: dword

mov esi, strCodeLocal ;[ebp + 20] ;str code
mov edi, decCodeLocal ;[ebp + 16] ;dec code
mov eax, numberOfDd ;[ebp + 12]
mov x1, eax ; number of dd
mov eax, bytesOnScreen ;[ebp + 8]
mov x2, eax ; bytes on screan


	push esi
	push edi
	

	push esi
	push offset buffer
	push x1
	call COPY_LONGOP

	pop edi
	pop esi

mov b, 0

xor ecx, ecx
xor ebx, ebx
cycle:
push ecx
push edi

push esi
push offset buf
push offset decCode
push x1
call DIV_LONGOP

pop edi
mov ebx, b
mov al, byte ptr[decCode]
add al, 48
mov byte ptr[edi + ebx], al

xor ecx, ecx
cycleInner:
mov eax, dword ptr[buf + 4 * ecx]
mov dword ptr[esi + 4 * ecx], eax
mov dword ptr[buf + 4 * ecx], 0
inc ecx
cmp ecx, x1
jl cycleInner

pop ecx
inc ecx
inc b
cmp ecx, x2
jl cycle

mov ebx, x2
mov eax, x2
xor edx, edx
div two
mov x2, eax
dec ebx 
xor ecx, ecx 
cycle1:

mov al, byte ptr[edi + ecx]
mov ah, byte ptr[edi + ebx]
mov byte ptr[edi + ecx], ah
mov byte ptr[edi + ebx], al

dec ebx
inc ecx
cmp ecx, x2
jl cycle1

push offset buffer
	push esi
	push x2
	call COPY_LONGOP

ret 
StrToDec endp

DIV_LONGOP proc

push ebp
mov ebp, esp

mov esi, [ebp + 20] ; number
mov edi, [ebp + 16] ;integer
mov ebx, [ebp + 12] ;fractional
mov eax, [ebp + 8] ; bytes
mov x, eax

push ebx
xor edx, edx
mov ecx, x
dec x
mov ebx,x
cycle :
push ecx
mov ecx, 10
mov eax, dword ptr[esi + 4 * ebx]

div ecx
mov fractionalPart, dl
mov dword ptr[edi + 4 * ebx], eax
dec ebx
pop ecx
dec ecx

jnz cycle

pop ebx
mov al, fractionalPart
mov byte ptr[ebx], al
pop ebp
ret 16

DIV_LONGOP endp

COPY_LONGOP proc

	push ebp
	mov ebp, esp

	mov esi, [ebp + 16]
	mov edi, [ebp + 12]
	mov edx, [ebp + 8]


	mov ecx, 0
	@cycle:
		mov eax, dword ptr[esi + 4 * ecx]
		mov dword ptr[edi + 4 * ecx], eax
		inc ecx

		cmp ecx, edx
		jne @cycle

	pop ebp
	ret 12


COPY_LONGOP endp


End
