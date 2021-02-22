.586
.model flat, stdcall

option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\windows.inc
include \masm32\include\comdlg32.inc

include longop.inc
include module.inc 

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\comdlg32.lib   ; comdlg32.lib - діалогове вікно вказування імені файлу


.data
	x dd 1
	hFile dd 0
	
	myFileName db 256 dup(0), 0 ;буфер для імені файлу
	
	pResult dd 0
	pBuf dd 0

	decCode db 1024 dup(0) , 13,10, 0
	line db " ",13,10, 0

	n dd 0
	nm dd 80
	pRes dd 0
	
.code

	MySaveFileName proc
		LOCAL ofn : OPENFILENAME
		invoke RtlZeroMemory, ADDR ofn, SIZEOF ofn ; спочатку усі поля обнулюємо
		mov ofn.lStructSize, SIZEOF ofn
		mov ofn.lpstrFile, OFFSET myFileName
		mov ofn.nMaxFile, SIZEOF myFileName
		invoke GetSaveFileName,ADDR ofn ; виклик вікна File Save As
		ret
	MySaveFileName endp


	main:
	
		call MySaveFileName
		cmp eax, 0  ; перевірка якщо у вікні FileSaveAs було натиснуто Cancel, то EAX = 0
		je @exit
			; відкриття або створення файлу якщо немає - CreateFile
			invoke CreateFile,  ADDR myFileName,
							    GENERIC_WRITE,
								FILE_SHARE_WRITE,
								0, CREATE_ALWAYS,
								FILE_ATTRIBUTE_NORMAL,
								0
			; GENERIC_WRITE і тд - константи з windows.inc
			cmp eax, INVALID_HANDLE_VALUE ; INVALID_HANDLE_VALUE - якщо значення не дорівнює цьому то доступ дозволено
			je @exit ;доступ до файлу неможливий
			
			mov hFile, eax
			invoke GlobalAlloc, GPTR, 1024

			mov pResult, eax
			add eax, 512				
			mov pBuf, eax 
			mov dword ptr[eax], 1  ; val = 1

			; обчислення факторіала
			@cycle:
				inc dword ptr[n]  ; n = n + 1
				mov eax, dword ptr[n]
				cmp eax, nm  ; 80!
				jg @endf

				push pResult
				push pBuf
				push x
				call Mul_N_x_32_LONGOP  ; Result = val * n

				push pResult
				push offset decCode
				push 16
				push 120
				call StrToDec_LONGOP

				invoke lstrlen, ADDR decCode 
				invoke WriteFile, hFile, ADDR decCode, eax, ADDR pRes, 0

				invoke lstrlen, ADDR line 
				invoke WriteFile, hFile, ADDR line,  eax, ADDR pRes, 0
	
				inc x
	
				push pResult
				push pBuf
				push 16
				call COPY_LONGOP ; val <– Result
		
				jmp @cycle
			
		@endf:
		invoke GlobalFree, pResult
		; файл обовязково треба закрити 
		invoke CloseHandle, hFile
		
		@exit:	
			invoke ExitProcess, 0
end main
