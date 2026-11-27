# Software & Build (`sw/`)

Test programs, linker configuration, and Windows batch build scripts for compiling `.c` and `.s` sources into `.mif` memory images for the RV32IM core.

## Contents
* **Test programs (`.c` and `.s`)** — C and assembly test cases covering control flow, loops/accumulation, stack/memory accesses, and `mul` instructions.
* **`c_build.bat`** — Compiles and links a `.c` source file using `link.ld` and generates the `.mif` memory initialization file.
* **`s_build.bat`** — Assembles and links an `.s` assembly file and generates the `.mif` memory initialization file.
* **`link.ld`** — Linker script anchoring `<_start>` at `0x00000000` and laying out sections for memory initialization.
* **Toolchain link text file** — Contains the download link for the RISC-V GCC toolchain (`xpack-riscv-none-elf-gcc-15.2.0-1`).

## Toolchain Setup
* Download **`xpack-riscv-none-elf-gcc-15.2.0-1`** from the link inside the text file in `sw/xpack-riscv-none-elf-gcc-15.2.0-1` and place/extract it where expected by the batch scripts so `riscv-none-elf-gcc.exe` and `riscv-none-elf-objcopy.exe` are available.

## How to Use
Open Command Prompt inside `sw/` and pass the program base name (without extension) directly as an argument:

* **Assembly (`.s`):**
  * `s_build.bat prog1` — builds `prog1.s` into `prog1.mif`
  * `s_build.bat` — defaults to `prog3` (`prog3.s` -> `prog3.mif`) if no name is given
* **C source (`.c`):**
  * `c_build.bat <filename_without_ext>` — builds `<filename>.c` into `<filename>.mif`
* **Program the FPGA:** Copy the generated `.mif` content into `FPGA/rom_init.mif` and recompile/update memory in Quartus.

## Constraints
* Target `rv32im` / `ilp32` without relying on hardware division (`div`, `divu`, `rem`, `remu`).