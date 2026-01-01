# 🛠️ Bash-Coding (Assembly & C)

This repository contains various Linux CLI tools and "Bash-like" commands written from scratch using **x86 Assembly (NASM)** and **C**. Some projects are implemented in Assembly, some in C, and some combine both languages. C sources are included for higher-level implementations and comparison while Assembly sources focus on low-level system call usage on the x86 architecture.

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
To assemble, compile and link these programs you generally need `nasm`, `binutils` and a C compiler. On Debian/Ubuntu systems this can be installed with:

```bash
sudo apt update
sudo apt install nasm binutils build-essential gcc-multilib
```
(If you only build 64-bit C code, `gcc-multilib` is not required. Adjust packages for your distribution.)

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

Note: The reference files focus on x86 Assembly, but also include mappings and notes useful when working with C sources in this repository.