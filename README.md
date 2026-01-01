# 🛠️ Bash-Coding (x86 Assembly)

This repository contains various Linux CLI tools and "Bash-like" commands written from scratch using **x86 Assembly (NASM)**. The goal is to understand system calls and low-level programming on the x86 architecture.

> **Educational Project:** Learn x86 assembly, system programming, and Linux kernel interfaces through practical examples.

## ✨ Features

- ✅ Pure x86 Assembly implementation (no C runtime)
- ✅ Direct syscall usage via `int 0x80`
- ✅ Network socket programming
- ✅ File I/O operations
- ✅ Shell command processing
- ✅ Well-documented code with references
- ✅ Comprehensive guides (English & Turkish)

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

Additional Documentation:
- [File Structure](FILES.md) - Project organization and file descriptions
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to the project
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions
- [Changelog](CHANGELOG.md) - Version history and roadmap

Contents include:
- 32-bit register categories (eax, ebx, ecx, edx, esi, edi, ebp, esp)
- x86 Linux syscall table
- Socketcall sub-numbers
- Syscall usage examples

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to report bugs
- How to propose enhancements
- Code style guidelines
- Pull request process

## 📋 Requirements

- **OS:** Linux (32-bit or 32-bit support on 64-bit)
- **Assembler:** NASM (nasm.us)
- **Linker:** GNU LD (binutils)
- **Architecture:** x86 (32-bit)

### Optional Tools
- **Debugger:** GDB for debugging
- **Disassembler:** objdump for code analysis

## 🚀 Quick Start

```bash
# Install prerequisites
sudo apt update
sudo apt install nasm binutils

# Clone/navigate to project
cd Bash-Coding/local_network_manager

# Build transfer utility
nasm -f elf32 transfer.asm -o transfer.o
ld -m elf_i386 transfer.o -o transfer

# Run
./transfer
```

## 📊 Project Status

- **Version:** 0.1.0
- **Status:** Active Development
- **License:** MIT (see [LICENSE](LICENSE))

### Current Modules
- ✅ local_network_manager - Socket communication
- ✅ open_shell - Basic shell implementation

### Planned Features
- [ ] Enhanced error handling
- [ ] Additional socket operations
- [ ] Process management utilities
- [ ] Memory management examples
- [ ] Comprehensive test suite

See [CHANGELOG.md](CHANGELOG.md) for detailed roadmap.

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

### MIT License Summary
- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ⚠️ License and copyright notice required

## 📧 Support

- 📖 Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
- 🤔 Review [REFERENCE.md](REFERENCE.md) or [REFERENCE_tr.md](REFERENCE_tr.md) for x86 help
- 💬 Open an issue for bugs or feature requests
- 🔧 See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines

## 🎓 Learning Resources

This project demonstrates:
- x86-32 assembly language
- Linux syscall interface
- Socket programming in assembly
- File I/O operations
- System-level programming

Perfect for students learning:
- Computer architecture
- Operating systems
- Low-level programming
- Assembly language