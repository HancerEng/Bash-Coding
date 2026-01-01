# x86 Assembly Referans Belgesi

Not: Bu referans x86 Assembly üzerine odaklanmıştır, ancak depodaki C kaynaklarıyla çalışırken faydalı olacak eşlemeler ve örnekler içermektedir.

## 32-bit Registerler ve Alt Kategorileri

### EAX - Biriktiricinin (Accumulator)
- **32-bit:** `eax` - Tam kayıt
- **16-bit:** `ax` - Düşük 16-bit
  - **8-bit (Yüksek):** `ah` - Yüksek 8-bit
  - **8-bit (Düşük):** `al` - Düşük 8-bit

**Kullanım:** Fonksiyon dönüş değerleri, aritmetik işlemler

### EBX - Taban (Base) Registerı
- **32-bit:** `ebx` - Tam kayıt
- **16-bit:** `bx` - Düşük 16-bit
  - **8-bit (Yüksek):** `bh` - Yüksek 8-bit
  - **8-bit (Düşük):** `bl` - Düşük 8-bit

**Kullanım:** Dizin işlemlerinde taban, syscall argümanları

### ECX - Sayaç (Counter) Registerı
- **32-bit:** `ecx` - Tam kayıt
- **16-bit:** `cx` - Düşük 16-bit
  - **8-bit (Yüksek):** `ch` - Yüksek 8-bit
  - **8-bit (Düşük):** `cl` - Düşük 8-bit

**Kullanım:** Döngü sayacı, syscall argümanları, string işlemleri

### EDX - Veri (Data) Registerı
- **32-bit:** `edx` - Tam kayıt
- **16-bit:** `dx` - Düşük 16-bit
  - **8-bit (Yüksek):** `dh` - Yüksek 8-bit
  - **8-bit (Düşük):** `dl` - Düşük 8-bit

**Kullanım:** I/O işlemleri, syscall argümanları

### ESI - Kaynak İndeksi (Source Index)
- **32-bit:** `esi` - Tam kayıt
- **16-bit:** `si` - Düşük 16-bit

**Kullanım:** String kaynağı, dizi işlemleri

### EDI - Hedef İndeksi (Destination Index)
- **32-bit:** `edi` - Tam kayıt
- **16-bit:** `di` - Düşük 16-bit

**Kullanım:** String hedefi, dizi işlemleri

### EBP - Taban İşaretçi (Base Pointer)
- **32-bit:** `ebp` - Tam kayıt
- **16-bit:** `bp` - Düşük 16-bit

**Kullanım:** Stack çerçeve işaretçisi, yerel değişkenler

### ESP - Stack İşaretçi (Stack Pointer)
- **32-bit:** `esp` - Tam kayıt
- **16-bit:** `sp` - Düşük 16-bit

**Kullanım:** Stack üst işaretçisi (genelde doğrudan değiştirilmez)

---

## Veri Türleri ve Bellek Boyutları

### Boyut Referansı

| Tür | NASM Direktifi | Boyut | Bit | Örnekler |
|-----|---|---|---|---|
| **Bayt** | `db` (define byte) | 1 bayt | 8 bit | `al`, `bl`, `cl` |
| **Kelime** | `dw` (define word) | 2 bayt | 16 bit | `ax`, `bx`, `cx` |
| **Çift Kelime** | `dd` (define doubleword) | 4 bayt | 32 bit | `eax`, `ebx`, `ecx` |
| **Dörtlü Kelime** | `dq` (define quadword) | 8 bayt | 64 bit | İki 32-bit register |

### Yaygın C Veri Türleri Assembly'de

| C Türü | Boyut | Assembly Register | Not |
|--------|------|---|---|
| `char` | 1 bayt | `al`, `bl`, `cl`, `dl` | Tek bayt karakter |
| `short` | 2 bayt | `ax`, `bx`, `cx`, `dx` | 16-bit tam sayı |
| `int` | 4 bayt | `eax`, `ebx`, `ecx`, `edx` | 32-bit tam sayı |
| `long` | 4 bayt | `eax`, `ebx`, `ecx`, `edx` | 32-bit'te int ile aynı |
| `pointer` | 4 bayt | Herhangi 32-bit register | Bellek adresi |
| `float` | 4 bayt | FPU registerleri | Kayan nokta (FPU gerekli) |
| `double` | 8 bayt | İki register veya FPU | Çift hassasiyet float |

### Assembly'de Bellek Tanımı

```asm
section .data
    byte_val db 0x42           ; 1 bayt: 'B'
    word_val dw 0x1234         ; 2 bayt: 0x1234
    dword_val dd 0x12345678    ; 4 bayt: 0x12345678
    
    char_string db "Hello", 0  ; String (bayt dizisi)
    array_bytes db 1, 2, 3, 4, 5  ; Birden çok bayt
```

### Değişken Tanımı Örnekleri

```asm
section .bss
    buffer resb 1024           ; 1024 bayt ayır
    numbers resw 100           ; 100 kelime ayır (200 bayt)
    values resd 50             ; 50 çift kelime ayır (200 bayt)

section .text
    mov al, byte [buffer]      ; 1 bayt yükle
    mov ax, word [buffer]      ; 2 bayt yükle (ax'e)
    mov eax, dword [buffer]    ; 4 bayt yükle (eax'e)
```

---

## Fonksiyon Çağırma Kuralı (CDECL - C Declaration)

### ÖNEMLİ: Ters Sırada Argüman Geçişi

Bir fonksiyonu veya syscall'ı çok argümanlı çağırırken, argümanlar stack'e **TERS SİRADA** push'lanır. Bu demektir:
- **Son parametre önce push edilir**
- **İlk parametre en son push edilir**
- **Her push'ta stack pointer azalır**

### Visual Stack Düzeni

```
Fonksiyon: mysyscall(arg1, arg2, arg3, arg4)

Çağrıdan önce:
    [ESP] -> boş stack alanı

Argümanları Push'ledikten sonra (ters sırada):
    [ESP + 16] -> arg1  (son push, argumentlerin üstü)
    [ESP + 12] -> arg2
    [ESP + 8]  -> arg3
    [ESP + 4]  -> arg4  (ilk push, derinlikte)
    [ESP]      -> dönüş adresi (CALL tarafından push'lanır)
```

### Örnek 1: Basit Fonksiyon Çağrısı

```asm
; Fonksiyon imzası: void write_file(fd, buffer, count)
; C: write_file(5, &buffer, 100);

; Argümanları TERS sırada push et
push 100           ; 3. parametre (count) - ilk push
push buffer_ptr    ; 2. parametre (buffer) - ikinci push  
push 5             ; 1. parametre (fd) - son push (ESP'ye en yakın)

call write_file    ; Fonksiyon çağır (dönüş adresini push'la)

; Fonksiyon dönüştükten sonra stack temizle
add esp, 12        ; 3 parametreyi kaldır (3 * 4 bayt)
```

### Örnek 2: Socketcall Argümanları

```asm
; socketcall(102, socket, 3, args)
; socket(AF_INET, SOCK_STREAM, 0)

; Socket argümanlarını TERS sırada push et
push 0             ; proto - 3. arg (ilk push)
push 1             ; type - 2. arg (ikinci push)
push 2             ; family - 1. arg (son push, derinlikte)
mov ecx, esp       ; ECX argümanlara işaret eder

; Şimdi socketcall argümanlarını TERS sırada push et
push ecx           ; args işaretçi - 2. arg
push 1             ; call numarası (socket=1) - 1. arg
mov ecx, esp       ; ECX socketcall argümanlarına işaret eder

mov eax, 102       ; socketcall syscall
int 0x80
```

### Örnek 3: cdecl vs stdcall

```asm
; CDECL (C Declaration - Linux'da varsayılan)
; Çağıran fonksiyon dönüştükten sonra stack'i temizler

push arg3          ; Argümanları ters sırada push et
push arg2
push arg1
call function      ; Dönüş adresini otomatik push'la
add esp, 12        ; Çağıran stack'i temizler (3 * 4 bayt)

; Fonksiyon stack'te argümanları alır:
; [ebp + 16] = arg1 (ilk push, arg stack'in üstü)
; [ebp + 12] = arg2
; [ebp + 8]  = arg3 (son push)
; [ebp + 4]  = dönüş adresi
; [ebp]      = kaydedilmiş ebp (eğer fonksiyon kaydederese)
```

### Fonksiyonlarda Stack Çerçevesi Kurulumu

```asm
my_function:
    push ebp               ; Eski base pointer'ı kaydet
    mov ebp, esp          ; Yeni stack çerçevesi kur
    sub esp, 16           ; Yerel değişkenler için yer ayır
    
    ; Şimdi parametrelere erişebilir:
    mov eax, [ebp + 8]    ; İlk parametre (arg1)
    mov ebx, [ebp + 12]   ; İkinci parametre (arg2)
    mov ecx, [ebp + 16]   ; Üçüncü parametre (arg3)
    
    ; Yerel değişkenler:
    mov [ebp - 4], eax    ; Yerel değişken 1
    mov [ebp - 8], ebx    ; Yerel değişken 2
    
    ; ... fonksiyon kodu ...
    
    mov esp, ebp          ; Stack pointer'ı geri yükle
    pop ebp               ; Base pointer'ı geri yükle
    ret                   ; Çağırıcı'ya dön
```

### Dönüş Değerleri

```asm
; Dönüş değeri EAX'e yerleştirilir (64-bit için EDX:EAX)

my_add:
    mov eax, [ebp + 8]    ; İlk parametre (arg1) yükle
    add eax, [ebp + 12]   ; İkinci parametre (arg2) ekle
    
    ; EAX şimdi sonucu içerir
    mov esp, ebp
    pop ebp
    ret                   ; Çağırıcı EAX'ten sonucu alır
```

---

## Stack İşlemleri

| No. | Adı | Hex | eax | ebx | ecx | edx | esi | edi |
|-----|-----|-----|--------|--------|--------|--------|--------|--------|
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

### Socketcall Alt Numaraları (syscall 102)
```
1 = socket        - Soket oluştur
2 = bind          - Soketi bağla
3 = connect       - Sokete bağlan
4 = listen        - Gelen bağlantıları dinle
5 = accept        - Bağlantıyı kabul et
6 = getsockname   - Soket adını al
7 = getpeername   - Eş adını al
8 = socketpair    - Soket çiftini oluştur
9 = send          - Veri gönder
10 = recv         - Veri al
11 = sendto       - Adrese veri gönder
12 = recvfrom     - Adresten veri al
13 = shutdown     - Soketi kapat
14 = setsockopt   - Soket seçeneği ayarla
15 = getsockopt   - Soket seçeneğini al
16 = listen       - Dinlemeye başla
```

---

## Syscall Nasıl Kullanılır?

### Değer Ayarlama (32-bit)
```asm
; Syscall numarası EAX'e
mov al, 102        ; socketcall
; veya
mov eax, 102

; Argümanlar:
; 1. Arg -> EBX
; 2. Arg -> ECX
; 3. Arg -> EDX
; 4. Arg -> ESI
; 5. Arg -> EDI
; 6. Arg -> EBP
```

### Syscall Çağırma
```asm
int 0x80           ; Syscall çağrısı (32-bit)
```

### Dönüş Değeri
```asm
; EAX'te dönüş değeri bulunur
mov result, eax
```

---

## Örnek: socket() Syscall

```asm
; socketcall (102) ile socket oluştur
mov al, 102        ; socketcall
mov bl, 1          ; socket alt numarası
push 0             ; proto (varsayılan)
push 1             ; type (SOCK_STREAM)
push 2             ; family (AF_INET)
mov ecx, esp       ; socket argümanlarına işaretçi
int 0x80           ; syscall
```

---

## Stack İşlemleri

Stack LIFO (Last In First Out) yapısıdır:
- `push` - Veriyi stack'e ekle (ESP azalır)
- `pop` - Stack'ten veriyi al (ESP artar)
- `esp` - Stack üstü işaretçisi
- `ebp` - Stack çerçeve işaretçisi

```asm
push 0x5c11        ; Port 4444
push word 2        ; AF_INET
mov ecx, esp       ; ECX = stack adresi
```
