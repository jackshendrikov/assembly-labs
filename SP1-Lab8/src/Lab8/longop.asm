.586
.model flat, c
.code

FloatDec_MY proc
	push ebp 
	mov ebp, esp 
	mov esi, [ebp + 8];esi 32 бітове число
	mov edi, [ebp + 12];edi адреса текстового буферу

	;вставка знаку числа
	mov eax, esi 
	and eax, 80000000h 
	cmp eax, 0 
	je @end_sign 
			mov byte ptr[edi], 45 
			inc edi 
	@end_sign: 
	mov ecx, edi
	
	;перевірка е
	mov eax, esi 
	and eax, 7F800000h 
	shr eax, 23 
		
	cmp eax, 0 
	jne @next 
		mov byte ptr[edi], 48 
		jmp @endproc 
	
	@next: 
		cmp eax, 0FFh 
		jne @next2 
		mov byte ptr[edi], 78 
		mov byte ptr[edi + 1], 65 
		mov byte ptr[edi + 2], 78 
	jmp @endproc 
	
	@next2: 
	sub eax, 7Fh
	
	;перевірка Е
	cmp eax, 0 
	jge @next3 
			mov byte ptr[edi], 48 
			inc ecx 
			mov ebx, esi 
			and ebx, 7FFFFFh ;мантиса 
			add ebx, 800000h ;прихована одиниця в 24 розр. 
			mov edx, 0FFFFFFFFh ;-1 
			imul edx 
			mov edx, ecx 
			mov ecx, eax 
			shr ebx, cl 
			mov ecx, edx 
			jmp @fraction 
	
	@next3: 
		jg @next4 
		mov byte ptr[edi], 49 
		inc ecx 
		mov ebx, esi 
		and ebx, 7FFFFFh 
		jmp @fraction 
	
	@next4: 
		push ecx 
		
		;пошук цілої частини
		mov ecx, 23 
		sub ecx, eax ;експонента (позиція від якої накладати маску)
		push ecx 
		mov eax, esi 
		and eax, 7FFFFFh 
		add eax, 800000h ;прихована одиниця в 24 розр.
		xor ebx, ebx 
		mov ebx, 1 
		shl ebx, cl 
		mov edx, ebx 

	@mask: 
		inc cl 
		shl ebx, 1 
		add ebx, edx 
		cmp cl, 24 
	jne @mask 

	mov edx, eax 
	and edx, ebx ;ціла частина

	mov ebx, eax 
	sub ebx, edx ;дробова частина

	pop ecx 
	shr edx, cl  ;здвиг цілої частини до 0 розряду

	mov eax, 23 
	sub eax, ecx 
	mov ecx, eax 
	shl ebx, cl  ;здвиг дробової частини до 23 розряду

	mov eax, edx 
	pop ecx 
	push ebx 
	mov ebx, 10 
	@full_part: ;обрахунок цілої частини
		xor edx, edx 
		div ebx 
		add edx, 48 
		mov byte ptr[ecx], dl 
		inc ecx 
		cmp eax, 0 
	jne @full_part 

	mov eax, ecx 
	dec eax 
	@reverse: 
		xor edx, edx 
		mov dh, byte ptr[eax] 
		mov dl, byte ptr[edi] 
		mov byte ptr[eax], dl 
		mov byte ptr[edi], dh 
		inc edi 
		dec eax 
		cmp edi, eax 
	jl @reverse 

	pop ebx 

	;пошук дробової частини в ebx 23 разр. дробу
	@fraction: 
		mov byte ptr[ecx], 44 
		inc ecx 
		mov ax, 6 
	@cycle: 
		shl ebx, 1 
		mov edx, ebx 
		shl edx, 2 
		add ebx, edx 

		mov edx, ebx 
		and edx, 0FF800000h 
		shr edx, 23 
		add dl, 48 
		mov [ecx], dl 
		and ebx, 7FFFFFh 
		inc ecx 
		dec ax 
		cmp ax, 0 
	jne @cycle 
	@endproc: 
		pop ebp 
		ret 8 
FloatDec_MY endp

end
