# Pipelined RV32IM Processor Core (VHDL)

A 32-bit pipelined RISC-V processor core written in VHDL implementing the **RV32I** base instruction set plus the **M** multiplication instruction (`mul`, without hardware division `div`/`rem`/`divu`/`remu`).

## Status & Next Step
* **Stage 1 — RTL & Simulation (Complete):** Pipelined datapath, hazard detection, data forwarding, `mul` execution, linker-script placement (`<_start>` at `0x00000000`), and store-capture reporting (`dbg_st`) verified in ModelSim across test programs.
* **Stage 2 — FPGA & UART TX Telemetry (Next):** DE10-Lite integration with internal memories, store-event buffering/framing, and UART TX streaming (`MAX10_CLK1_50` baud generator) to a PC via a 3.3V USB-TTL adapter.

## Repository Structure
* `rtl/` — Pipelined RV32IM VHDL RTL modules (single source of truth for core RTL). See `rtl/README.md`.
* `tb/` — VHDL testbench (`RISCV_CORE_top_level_tb.vhd`), store-event hex logging, and simulation setup. See `tb/README.md`.
* `sw/` — C and assembly test programs, `link.ld`, `c_build.bat`, `s_build.bat`, `bin_to_mif.py`, and the toolchain link text file. See `sw/README.md`.
* `FPGA/` — Quartus Prime project files for the Terasic DE10-Lite, top-level wrapper, and memory initialization files (including `rom_init.mif`). See `FPGA/README.md`.

## Quick Start
1. **Toolchain Setup:** Download `xpack-riscv-none-elf-gcc-15.2.0-1` from the link inside the text file in `sw/` and place/extract it as expected by the build scripts.
2. **Build a Program (`.mif`):** In `sw/`, run `s_build.bat <prog_name>` (defaults to `prog3` if omitted) or `c_build.bat <prog_name>` to generate the `.mif` file.
3. **Program FPGA (DE10-Lite):** Copy the generated `.mif` content from `sw/` into `FPGA/rom_init.mif` and recompile/update memory in Quartus before running Analysis and Elaboration.
4. **Simulate (ModelSim):** Compile `rtl/` and `tb/` (with VHDL-2008 enabled for testbench string/hex logging), load the generated memory image, and verify register values and store logs.


## Scope & Constraints
* Targets `rv32im` / `ilp32` without hardware divider instructions (`div`, `divu`, `rem`, `remu`).
* Keep core RTL inside `rtl/` rather than duplicating core modules inside `FPGA/`.