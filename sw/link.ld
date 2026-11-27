SECTIONS {
  . = 0x0;
  .text : {
    KEEP(*(.text.init))
    *(.text .text*)
  }
  .rodata : { *(.rodata .rodata*) }
  .data : { *(.data .data*) }
  .bss : { *(.bss .bss*) *(COMMON) }
}