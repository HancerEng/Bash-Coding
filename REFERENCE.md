# x86 Assembly Reference Guide

## 32-bit Registers and Sub-Categories

### EAX - Accumulator Register
- **32-bit:** `eax` - Full register
- **16-bit:** `ax` - Lower 16-bit
  - **8-bit (High):** `ah` - High 8-bit
  - **8-bit (Low):** `al` - Low 8-bit

**Usage:** Function return values, arithmetic operations

### EBX - Base Register
- **32-bit:** `ebx` - Full register
- **16-bit:** `bx` - Lower 16-bit
  - **8-bit (High):** `bh` - High 8-bit
  - **8-bit (Low):** `bl` - Low 8-bit

**Usage:** Base for indexing operations, syscall arguments

### ECX - Counter Register
- **32-bit:** `ecx` - Full register
- **16-bit:** `cx` - Lower 16-bit
  - **8-bit (High):** `ch` - High 8-bit
  - **8-bit (Low):** `cl` - Low 8-bit

**Usage:** Loop counter, syscall arguments, string operations

### EDX - Data Register
- **32-bit:** `edx` - Full register
- **16-bit:** `dx` - Lower 16-bit
  - **8-bit (High):** `dh` - High 8-bit
  - **8-bit (Low):** `dl` - Low 8-bit

**Usage:** I/O operations, syscall arguments

### ESI - Source Index
- **32-bit:** `esi` - Full register
- **16-bit:** `si` - Lower 16-bit

**Usage:** String source, array operations

### EDI - Destination Index
- **32-bit:** `edi` - Full register
- **16-bit:** `di` - Lower 16-bit

**Usage:** String destination, array operations

### EBP - Base Pointer
- **32-bit:** `ebp` - Full register
- **16-bit:** `bp` - Lower 16-bit

**Usage:** Stack frame pointer, local variables

### ESP - Stack Pointer
- **32-bit:** `esp` - Full register
- **16-bit:** `sp` - Lower 16-bit

**Usage:** Stack top pointer (usually not modified directly)

---

## Data Types and Memory Sizes

### Size Reference

| Type | NASM Directive | Size | Bits | Examples |
|------|---|---|---|---|
| **Byte** | `db` (define byte) | 1 byte | 8 bits | `al`, `bl`, `cl` |
| **Word** | `dw` (define word) | 2 bytes | 16 bits | `ax`, `bx`, `cx` |
| **Doubleword** | `dd` (define doubleword) | 4 bytes | 32 bits | `eax`, `ebx`, `ecx` |
| **Quadword** | `dq` (define quadword) | 8 bytes | 64 bits | Two 32-bit registers |

### Common C Data Types in Assembly

| C Type | Size | Assembly Register | Note |
|--------|------|---|---|
| `char` | 1 byte | `al`, `bl`, `cl`, `dl` | Single byte character |
| `short` | 2 bytes | `ax`, `bx`, `cx`, `dx` | 16-bit integer |
| `int` | 4 bytes | `eax`, `ebx`, `ecx`, `edx` | 32-bit integer |
| `long` | 4 bytes | `eax`, `ebx`, `ecx`, `edx` | Same as int in 32-bit |
| `pointer` | 4 bytes | Any 32-bit register | Memory address |
| `float` | 4 bytes | FPU registers | Floating point (requires FPU) |
| `double` | 8 bytes | Two registers or FPU | Double precision float |

### Memory Definition in Assembly

```asm
section .data
    byte_val db 0x42           ; 1 byte: 'B'
    word_val dw 0x1234         ; 2 bytes: 0x1234
    dword_val dd 0x12345678    ; 4 bytes: 0x12345678
    
    char_string db "Hello", 0  ; String (array of bytes)
    array_bytes db 1, 2, 3, 4, 5  ; Multiple bytes
```

### Variable Declaration Examples

```asm
section .bss
    buffer resb 1024           ; Reserve 1024 bytes
    numbers resw 100           ; Reserve 100 words (200 bytes)
    values resd 50             ; Reserve 50 doublewords (200 bytes)

section .text
    mov al, byte [buffer]      ; Load 1 byte
    mov ax, word [buffer]      ; Load 2 bytes (into ax)
    mov eax, dword [buffer]    ; Load 4 bytes (into eax)
```

---

## Function Calling Convention (CDECL - C Declaration)

### Important: Reverse Order Argument Passing

When calling a function or syscall with multiple arguments, arguments are **pushed to the stack in REVERSE order**. This means:
- **Last parameter is pushed first**
- **First parameter is pushed last**
- **Stack pointer decreases with each push**

### Visual Stack Layout

```
Function: mysyscall(arg1, arg2, arg3, arg4)

Before Call:
    [ESP] -> empty stack space

After Pushing Arguments (in reverse):
    [ESP + 16] -> arg1  (pushed last, top of arguments)
    [ESP + 12] -> arg2
    [ESP + 8]  -> arg3
    [ESP + 4]  -> arg4  (pushed first, deepest)
    [ESP]      -> return address (pushed by CALL instruction)
```

### Example 1: Simple Function Call

```asm
; Function signature: void write_file(fd, buffer, count)
; C: write_file(5, &buffer, 100);

; Push arguments in REVERSE order
push 100           ; 3rd parameter (count) - pushed first
push buffer_ptr    ; 2nd parameter (buffer) - pushed second  
push 5             ; 1st parameter (fd) - pushed last (nearest to ESP)

call write_file    ; Call function (pushes return address)

; After function returns, clean up stack
add esp, 12        ; Remove 3 parameters (3 * 4 bytes)
```

### Example 2: Socketcall Arguments

```asm
; socketcall(102, socket, 3, args)
; socket(AF_INET, SOCK_STREAM, 0)

; Push socket arguments in REVERSE
push 0             ; proto - 3rd arg (pushed first)
push 1             ; type - 2nd arg (pushed second)
push 2             ; family - 1st arg (pushed last, deepest)
mov ecx, esp       ; ECX points to arguments

; Now push socketcall arguments in REVERSE
push ecx           ; args pointer - 2nd arg
push 1             ; call number (socket=1) - 1st arg
mov ecx, esp       ; ECX points to socketcall args

mov eax, 102       ; socketcall syscall
int 0x80
```

### Example 3: cdecl vs stdcall

```asm
; CDECL (C Declaration - default in Linux)
; Caller cleans up stack after function returns

push arg3          ; Push arguments in reverse
push arg2
push arg1
call function      ; Pushes return address automatically
add esp, 12        ; Caller cleans up (3 * 4 bytes)

; Function receives arguments on stack:
; [ebp + 16] = arg1 (first pushed, top of arg stack)
; [ebp + 12] = arg2
; [ebp + 8]  = arg3 (last pushed)
; [ebp + 4]  = return address
; [ebp]      = saved ebp (if function saves it)
```

### Stack Frame Setup in Functions

```asm
my_function:
    push ebp               ; Save old base pointer
    mov ebp, esp          ; Set up new stack frame
    sub esp, 16           ; Reserve space for local variables
    
    ; Now access parameters:
    mov eax, [ebp + 8]    ; First parameter (arg1)
    mov ebx, [ebp + 12]   ; Second parameter (arg2)
    mov ecx, [ebp + 16]   ; Third parameter (arg3)
    
    ; Local variables:
    mov [ebp - 4], eax    ; Local variable 1
    mov [ebp - 8], ebx    ; Local variable 2
    
    ; ... function code ...
    
    mov esp, ebp          ; Restore stack pointer
    pop ebp               ; Restore base pointer
    ret                   ; Return to caller
```

### Return Values

```asm
; Return value is placed in EAX (or EDX:EAX for 64-bit values)

my_add:
    mov eax, [ebp + 8]    ; Load first parameter (arg1)
    add eax, [ebp + 12]   ; Add second parameter (arg2)
    
    ; EAX now contains the result
    mov esp, ebp
    pop ebp
    ret                   ; Caller will get result from EAX
```

---

## Stack Operations

| No. | Name | Hex | eax | ebx | ecx | edx | esi | edi |
|-----|------|-----|---------|---------|---------|---------|---------|---------|
| 1 | exit | 0x01 | int error_code | - | - | - | - | - |
| 2 | fork | 0x02 | - | - | - | - | - | - |
| 3 | read | 0x03 | unsigned int fd | char *buf | size_t count | - | - | - |
| 4 | write | 0x04 | unsigned int fd | const char *buf | size_t count | - | - | - |
| 5 | open | 0x05 | const char *filename | int flags | umode_t mode | - | - | - |
| 6 | close | 0x06 | unsigned int fd | - | - | - | - | - |
| 11 | execve | 0x0b | const char *name | const char *const *argv | const char *const *envp | - | - | - |
| 33 | access | 0x21 | const char *filename | int mode | - | - | - | - |
| 39 | mkdir | 0x27 | const char *pathname | umode_t mode | - | - | - | - |
| 40 | rmdir | 0x28 | const char *pathname | - | - | - | - | - |
| 36 | sync | 0x24 | - | - | - | - | - | - |
| 37 | kill | 0x25 | pid_t pid | int sig | - | - | - | - |
| 38 | rename | 0x26 | const char *oldname | const char *newname | - | - | - | - |
| 41 | dup | 0x29 | unsigned int fildes | - | - | - | - | - |
| 42 | pipe | 0x2a | int *fildes | - | - | - | - | - |
| 45 | brk | 0x2d | unsigned long brk | - | - | - | - | - |
| 63 | dup2 | 0x3f | unsigned int oldfd | unsigned int newfd | - | - | - | - |
| 102 | socketcall | 0x66 | int call | unsigned long *args | - | - | - | - |
| 162 | nanosleep | 0xa2 | struct timespec *rqtp | struct timespec *rmtp | - | - | - | - |
| 240 | futex | 0xf0 | u32 *uaddr | int op | u32 val | struct timespec *utime | u32 *uaddr2 | u32 val3 |

### Socketcall Sub-Numbers (syscall 102)
```
1 = socket        - Create a socket
2 = bind          - Bind socket to address
3 = connect       - Connect to address
4 = listen        - Listen for connections
5 = accept        - Accept incoming connection
6 = getsockname   - Get socket name
7 = getpeername   - Get peer name
8 = socketpair    - Create socket pair
9 = send          - Send data
10 = recv         - Receive data
11 = sendto       - Send data to address
12 = recvfrom     - Receive data from address
13 = shutdown     - Shutdown socket
14 = setsockopt   - Set socket option
15 = getsockopt   - Get socket option
16 = listen       - Start listening
```

---

## How to Use Syscalls?

### Setting Values (32-bit)
```asm
; Syscall number in EAX
mov al, 102        ; socketcall
; or
mov eax, 102

; Arguments:
; 1st Arg -> EBX
; 2nd Arg -> ECX
; 3rd Arg -> EDX
; 4th Arg -> ESI
; 5th Arg -> EDI
; 6th Arg -> EBP
```

### Calling Syscall
```asm
int 0x80           ; Syscall call (32-bit)
```

### Return Value
```asm
; Return value is in EAX
mov result, eax
```

---

## Example: socket() Syscall

```asm
; socketcall (102) to create socket
mov al, 102        ; socketcall
mov bl, 1          ; socket sub-number
push 0             ; proto (default)
push 1             ; type (SOCK_STREAM)
push 2             ; family (AF_INET)
mov ecx, esp       ; pointer to socket arguments
int 0x80           ; syscall
```

---

## Stack Operations

Stack is LIFO (Last In First Out) structure:
- `push` - Push data to stack (ESP decreases)
- `pop` - Pop data from stack (ESP increases)
- `esp` - Stack top pointer
- `ebp` - Stack frame pointer

```asm
push 0x5c11        ; Port 4444
push word 2        ; AF_INET
mov ecx, esp       ; ECX = stack address
```
