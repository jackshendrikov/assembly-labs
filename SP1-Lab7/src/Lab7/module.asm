.586
.model flat, c
.data	
num11 dd 11

.code
    ;процедура StrHex_MY записуЇ текст ш≥стнадц€тькового коду
    ;перший параметр - адреса буфера результату (р€дка символ≥в)
	;другий параметр - адреса числа
	;трет≥й параметр - розр€дн≥сть числа у б≥тах 
Func proc
	push ebp
	mov ebp,esp
	mov ecx, [ebp+8]		;m
	mov eax, [ebp+12]		;X
	
	xor edx, edx
	mov ebx, eax
	shl ebx, 1
	jnc @plus
	sub edx, 1
	@plus:

	idiv num11
	sar eax, cl

	pop ebp
	ret 8
Func endp

End