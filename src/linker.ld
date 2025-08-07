OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTION
{
    /*code at 1MiB
    . =1M;

    .text : {
        *(.multiboot) /* if using multiboot header*/
        *(.text) /* this is all the code */
    }

    .rodata : {*(.rodata)}
    .data : {*(.data)}
    .bss : {
        *(.bss)
        *(COMMON)
    }

    /DISCARD/ : { *(.note.GNU-stack) }
}
