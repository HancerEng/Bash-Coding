global _start

section .data
	filename db "new_file.txt", 0

section .bss
	buffer resb 1024

section .text
_start:

	xor eax , eax
	xor ebx , ebx
	xor edx , edx

	mov al , 102
	mov bl , 1

	push edx
	push 1
	push 2
	mov ecx , esp
	int 0x80

	mov esi , eax ; fd backup

	;Bind

	xor eax , eax
	xor ebx , ebx

	mov al , 102
	mov bl , 2

	push edx
	push edx
	push 0x6f01a8c0 ;IP 192.168.1.111 (Local Port)
	push word 0x5c11 ;PORT 4444
	push word 2
	mov ecx , esp ;ecx in sockaddr *

	push 16
	push ecx
	push esi
	mov ecx , esp
	int 0x80

	;Listen

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	mov al , 102

	mov bl , 4

	push 2
	push esi
	mov ecx , esp
	int 0x80

	;Accept Loop

accept_loop:

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx

	mov al , 102
	mov bl , 5

	push edx
	push edx
	push esi
	mov ecx , esp
	int 0x80

	mov edi, eax     ;(win fd *)

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	xor edx , edx

	mov al , 5
	mov ebx , filename
	mov ecx , 65
	mov edx , 420
	int 0x80

	mov ebp , eax 	; Received dir fd *

transfer_loop:

	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	xor edx , edx

	mov al , 3
	mov ebx , edi
	mov ecx , buffer
	mov edx , 1024
	int 0x80

	cmp eax, 0  	; EAX keeps number of bytes read
	jle transfer_finish

	mov al , 4
	mov ebx , ebp
	mov ecx , buffer
	mov edx , 1024
	int 0x80

	jmp transfer_loop

	;Transfer is finished

transfer_finish:

	xor eax , eax
	mov al , 6
	mov ebx , ebp
	int 0x80

	; Close sockets (Cleaning)
    mov eax, 6          ; sys_close
	mov ebx, edi        ; İstemci soketi
	int 0x80

	mov eax, 6          ; sys_close
	mov ebx, esi        ; Dinleyen ana soket
   	int 0x80

	; Exit Node
	mov eax, 1          ; sys_exit
	xor ebx, ebx        ; return 0
	int 0x80

