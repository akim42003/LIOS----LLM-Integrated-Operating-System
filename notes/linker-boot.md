````markdown
### Assemble → Object
*Convert `.s` assembly into a relocatable `.o` file.*
```bash
i686-elf-as foo.s -o foo.o
# or via GCC front‐end:
i686-elf-gcc -ffreestanding -c foo.s -o foo.o
````

---

### Link → ELF (`ld`)

*Use your custom linker script to place sections at the right addresses.*

```bash
i686-elf-ld -T linker.ld -o kernel.elf foo.o
```

---

### Link → ELF (`gcc`)

*Let GCC invoke `ld`, omitting libc/startup files.*

```bash
i686-elf-gcc -ffreestanding -nostdlib \
  -Wl,-T,linker.ld -o kernel.elf foo.o
```

---

### Linker Script (`linker.ld`)

*Defines entry point, load address (1 MiB), and organizes your sections.*

```ld
ENTRY(_start)             # symbol where execution begins

SECTIONS {
  . = 0x00100000;         # set load address to 1 MiB

  .text   : {             # code: multiboot header + instructions
    *(.multiboot)
    *(.text)
  }

  .rodata : { *(.rodata) }# read-only data (constants)
  .data   : { *(.data)   }# initialized data in RAM
  .bss    : {             # zero-initialized data
    *(.bss)
    *(COMMON)
  }

  /DISCARD/: { *(.note.GNU-stack) }  # drop unnecessary note
}
```

---

### Quick Linux VM Test

*Validate your exit syscall in a normal Linux binary.*

```bash
cat > test.s << 'EOF'
.global _start
_start:
  mov $1, %eax     # sys_exit (32-bit)
  mov $0, %ebx     # exit code 0
  int $0x80
EOF
as --32 test.s -o test.o
ld -m elf_i386 -o test test.o
./test; echo $?    # should print 0
```

---

### ISO → Boot (GRUB + QEMU)

*Package `kernel.elf` into a bootable ISO and run it.*

```bash
mkdir -p iso/boot/grub
cp kernel.elf iso/boot/
cat > iso/boot/grub/grub.cfg << 'EOF'
set timeout=5
menuentry "OS" {
  multiboot /boot/kernel.elf
  boot
}
EOF
grub-mkrescue -o myos.iso iso
qemu-system-i386 \
  -cdrom myos.iso \
  -serial mon:stdio \
  -m512M
```
