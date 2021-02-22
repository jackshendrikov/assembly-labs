.586
.model flat, c


.code

ADD_128_LONGOP proc
	push ebp
	mov ebp,esp

	mov esi, [ebp+20]							;ESI = адреса A
	MOV EDX, [EBP + 12]							;Цей регістр є лічильником для циклу while
	mov edi, [ebp+8]							;EDI = адреса результату

	MOV ECX, 00H								;Цей регістр потрібен для зсуву масиву в циклі,
												;в цьому випадку ми не будемо використовувати CH, тому вони використовуються в loop2
	
	MOV EAX, DWORD ptr[ESI]						;починаємо з молодших 32-бітових груп

@loop: 
	MOV EBX, [ebp+16]							;EBX = адреса B
	ADD EAX, DWORD ptr[EBX + ECX]						;додавання 32-біт
	MOV DWORD ptr[EDI + ECX], EAX						;запис молодших 32 біт суми
	
	JNC @else
	ADD ECX, 04H								;Це потрібно для того, щоб взяти ще один елемент
	MOV EBX, ECX								;Це використовується для loop2, за винятком ECX, з метою збереження значення в ECX
@loop2:
	MOV EAX, DWORD ptr[ESI + EBX]
	ADD EAX, 01H								;Додаємо прапор CF
	MOV DWORD ptr[ESI + EBX], EAX				;Збереження значення, яке ми отримуємо в форвардних елементах
	JNC @endif									;Перевірка чи все ще встановлено прапор CF?

	ADD EBX, 04H								;Потім беремо інший елемент

	MOV EAX, [EBP + 12]							;EAX нам більше не потрібен, тому ми можемо використовувати його для збереження розміру масиву
	SHL EAX, 2									;В цьому випадку ми множимо розмір масиву на 4, це потрібно для приховування лічильника, яким є EBX
	ADD EAX, 04H
	CMP EBX, EAX
	JNZ @loop2

	JMP @endIf
@else:
	ADD ECX, 04H

@endIf:
	MOV EAX, DWORD ptr[ESI + ECX]

	DEC EDX
	JNZ @loop

	POP EBP
	RET 12
ADD_128_LONGOP endp

SUB_128_LONGOP proc	
	push ebp
	mov ebp,esp

	mov esi, [ebp+20]							;ESI = адреса A
	MOV EDX, [EBP + 12]							;Цей регістр є лічильником для циклу while
	mov edi, [ebp+8]							;EDI = адреса результату

	MOV ECX, 00H								;Цей регістр потрібен для зсуву масиву в циклі,
												;в цьому випадку ми не будемо використовувати CH, тому вони використовуються в loop2
	
	MOV EAX, DWORD ptr[ESI]						;починаємо з молодших 32-бітових груп

@loop: 
	MOV EBX, [ebp+16]							;EBX = адреса B
	SUB EAX, DWORD ptr[EBX + ECX]						;додавання 32-біт
	MOV DWORD ptr[EDI + ECX], EAX						;запис молодших 32 біт суми
	
	JNC @else
	ADD ECX, 04H								;Це потрібно для того, щоб взяти ще один елемент
	MOV EBX, ECX								;Це використовується для loop2, за винятком ECX, з метою збереження значення в ECX
@loop2:
	MOV EAX, DWORD ptr[ESI + EBX]
	SUB EAX, 01H								;Віднімаємо прапор CF
	MOV DWORD ptr[ESI + EBX], EAX				;Збереження значення, яке ми отримуємо в форвардних елементах
	JNC @endif									;Перевірка чи все ще встановлено прапор CF?

	ADD EBX, 04H								;Потім беремо інший елемент

	MOV EAX, [EBP + 12]							;EAX нам більше не потрібен, тому ми можемо використовувати його для збереження розміру масиву
	SHL EAX, 2									;В цьому випадку ми множимо розмір масиву на 4, це потрібно для приховування лічильника, яким є EBX
	ADD EAX, 04H
	CMP EBX, EAX
	JNZ @loop2

	JMP @endIf
@else:
	ADD ECX, 04H

@endIf:
	MOV EAX, DWORD ptr[ESI + ECX]

	DEC EDX
	JNZ @loop

	POP EBP
	RET 12
SUB_128_LONGOP endp
end
