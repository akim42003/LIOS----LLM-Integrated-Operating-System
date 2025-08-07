OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS
{
    /* code at 1MiB */
    . = 0x00100000;

    .text : {
        *(.multiboot)
        *(.text)

    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : {
        *(.bss)
        *(COMMON)
    }

    /DISCARD/ : { *(.note.GNU-stack) }
}
