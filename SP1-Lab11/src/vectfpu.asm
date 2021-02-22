.586
.model flat, c
.data 
.code

MyDotProduct_FPU proc dest:DWORD, pB:DWORD, pA:DWORD, bits:DWORD 

	mov eax, pA ; a 
	mov ebx, pB ; b 
	mov edx, dest ; res 
	mov ecx, bits  ; n 
    dec ecx

	fldz

	@cycle:
	    fld dword ptr[eax+4*ecx] 
	    fmul dword ptr[ebx+4*ecx]
		faddp st(1), st(0)
		dec ecx
	jge @cycle

	fstp dword ptr[edx]
	ret


MyDotProduct_FPU endp

End
