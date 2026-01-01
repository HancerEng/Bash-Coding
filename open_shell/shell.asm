global _start

section .text
_start:

	xor eax , eax
	push eax
	push 0x68732f2f
	push 0x6e69622f

	mov ebx , esp
	xor ecx , ecx
	xor edx , edx
	mov al , 11
	int 0x80

	xor eax , eax
	mov al , 1
	xor ebx , ebx
	int 0x80
