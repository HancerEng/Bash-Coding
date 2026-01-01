# 🛠️ Bash-Coding (x86 Assembly)

This repository contains various Linux CLI tools and "Bash-like" commands written from scratch using **x86 Assembly (NASM)**. The goal is to understand system calls and low-level programming on the x86 architecture.

## � Project Structure

### `local_network_manager/`
Manages local network operations and socket communication:
- `transfer` - Compiled executable
- `transfer.asm` - Assembly source code
- `transfer_disassembly.txt` - Disassembly output

### `open_shell/`
Implements a basic shell interface:
- `shell` - Compiled executable
- `shell.asm` - Assembly source code
- `shell_disassembly.txt` - Disassembly output

## 🚀 Getting Started

### Prerequisites
To assemble and link these programs, you need `nasm` and `binutils` installed on your Linux system:

```bash
sudo apt update
sudo apt install nasm binutils
```

## 🛠️ Build & Development

Follow these steps to compile the source code into a runnable executable.

### 1. Assembling
Convert the .asm source file into an ELF object file:

```bash
nasm -f elf32 example.asm -o example.o
```

### 2. Linking
Link the object file to create the final Linux executable:

```bash
ld -m elf_i386 example.o -o example
```

### 3. Inspection (Optional)
To view the assembly instructions and disassembled code of the compiled object file:

```bash
objdump -d example.o
```

## 📝 License

This project is open source and available for educational purposes.

## 📚 Resources & Reference

For detailed reference guides and syscall tables:
- **English:** [REFERENCE.md](REFERENCE.md)
- **Türkçe:** [REFERENCE_tr.md](REFERENCE_tr.md)

Contents include:
- 32-bit register categories (eax, ebx, ecx, edx, esi, edi, ebp, esp)
- x86 Linux syscall table
- Socketcall sub-numbers
- Syscall usage examples