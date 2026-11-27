# FPGA Target — DE10-Lite (`FPGA/`)

Intel Quartus Prime project files and memory initialization assets for the Terasic **DE10-Lite** (MAX 10) board.

## Contents
* Quartus project and pin/timing files (`.qpf`, `.qsf`, `.sdc`, and `RISCV` top-level wrapper).
* On-chip memory IP/initialization files (`.qip`, `.mif`, including `rom_init.mif`).

## Loading a New Program into Instruction ROM
1. Build your target program in `sw/` to generate its `.mif` output.
2. Copy the generated `.mif` content from `sw/` into `FPGA/rom_init.mif`.
3. Recompile/update memory in Quartus so the instruction ROM initializes with the new program before programming the board.

## Status & Roadmap
* **Current:** Top-level shell and internal memories structured to avoid excessive top-level port counts during synthesis/fitting.
* **Stage 2 (Next):** Add UART TX store telemetry (`MAX10_CLK1_50` baud divider + store FIFO/packetizer) wired to a 3.3V USB-TTL `RXD` pin.