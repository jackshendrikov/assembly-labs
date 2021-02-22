.586
.model flat, c

.code

Add_864_LONGOP proc
push ebp
mov ebp,esp
mov esi, [ebp+16]
mov ebx, [ebp+12]
mov edi, [ebp+8]
mov ecx, 0

addAB:
mov eax, dword ptr[esi+ecx]
adc eax, dword ptr[ebx+ecx]
mov dword ptr [edi+ecx], eax
add ecx, 4
cmp ecx, 864
jl addAB
pop ebp
ret 12
Add_864_LONGOP endp

Sub_256_LONGOP proc
push ebp
mov ebp,esp
mov esi, [ebp+16]
mov ebx, [ebp+12]
mov edi, [ebp+8]
mov ecx, 0

subAB:
mov eax, dword ptr[esi+ecx]
sbb eax, dword ptr[ebx+ecx]
mov dword ptr [edi+ecx], eax
add ecx, 4
cmp ecx, 256
jl subAB
pop ebp
ret 12
Sub_256_LONGOP endp

Mul_N32_LONGOP proc
	push ebp
	mov ebp, esp
	mov esi, [ebp+16]
	mov ebx, [ebp+12]
	mov edi, [ebp+8]
	
	xor ecx, ecx
	@cycle: 
		mov eax, dword ptr[esi+ 4*ecx]
		mul ebx
		add dword ptr[edi+4*ecx], eax
		add dword ptr[edi+4*ecx+4], edx
		inc ecx
		cmp ecx, 7
	jb @cycle

	pop ebp
	ret 12
Mul_N32_LONGOP endp

Mul_N_x_N_LONGOP proc
	push ebp
	mov ebp, esp
	mov esi, [ebp + 16]
	mov edi, [ebp + 12]
	mov bl, [ebp + 8]
	x db 0
	mov x, bl
	mov ecx, 8
	xor ebx, ebx
	@cycle1:
	mov eax, dword ptr[edi + 8 * ebx]
	mul x
	mov dword ptr[esi + 8 * ebx], eax
	mov dword ptr[esi + 8 * ebx + 4], edx

	inc ebx
	dec ecx
	jnz @cycle1
	mov ecx, 8
	xor ebx, ebx
	@cycle2:
	mov eax, dword ptr[edi + 8 * ebx + 4]
	mul x
	clc
	adc eax, dword ptr[esi + 8 * ebx + 4]
	mov dword ptr[esi + 8 * ebx + 4], eax
	clc
	adc edx, dword ptr[esi + 8 * ebx + 8]
	mov dword ptr[esi + 8 * ebx + 8], edx
	inc ebx
	dec ecx
	jnz @cycle2
	pop ebp
	ret 12
Mul_N_x_N_LONGOP endp

Write_1_LONGOP proc
		push ebp
		mov ebp, esp

		mov eax, [ebp+8]; m
		mov edx, [ebp+12]; n
		mov esi, [ebp+16]; adres
		mov ebx, edx; n
		and ebx, 7; 0000 0xxx
		shr edx, 3; byte
		mov ecx, ebx
		mov ch, 255; 1111 1111
		shl ch, cl; 1110 0000
		xor ebx, 7; 5:101 = 010:2
		inc ebx; 2 + 1 = 3
		sub eax, ebx
		jc @inner
		or byte ptr[esi+edx], ch
		inc edx
		xor ecx, ecx
		@byte1:
		sub eax, 8
		jc @out
		or byte ptr[esi+edx], 255
		inc edx
		jmp @byte1
		@inner:
		not eax
		inc eax
		xor ebx, ebx
		mov bh, ch
		mov ecx, eax
		shl bh, cl
		jmp @end
		@out:
		not eax
		inc eax
		and eax, 7
		xor ebx, ebx
		mov bh, 255
		mov ecx, eax
		@end:
		shr bh, cl
		or byte ptr[esi+edx], bh
		pop ebp
		ret 12
Write_1_LONGOP endp

End
