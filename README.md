# Pipelined RV32IM Processor Core (VHDL)

A 32-bit pipelined RISC-V processor core written in VHDL implementing the **RV32I** base instruction set plus the **M** multiplication instruction (`mul`, without hardware division `div`/`rem`/`divu`/`remu`).

## Current Status
* **Stage 1 — RTL & Simulation (Done):** Pipelined datapath, hazard detection, data forwarding, `mul` execution, linker-script placement (`<_start>` at `0x00000000`), and store-event reporting verified in ModelSim across test programs.
* **Stage 2 — FPGA & UART TX Telemetry (Next):** Top-level DE10-Lite integration with internal memories and UART TX streaming of store events to a PC.
* **Stage 3 — Host Commands via UART RX (Planned):** Sending commands/data from the PC back to the processor.

## Repository Layout
* `rtl/` — VHDL RTL modules for the pipelined RV32IM core.
* `tb/` — VHDL testbench with automated store-address/data logging.
* `sw/` — Custom linker script (`link.ld`), build file, and the three test programs.
* `fpga/` — Top-level board integration and memory initialization files.

## Toolchain & Verification
* **Simulation:** ModelSim (VHDL-2008 used for hex string formatting in testbench logs)
* **Software / Build:** RISC-V GCC toolchain (`-march=rv32im` / `-mabi=ilp32` as configured in your build file) with `link.ld` anchoring `<_start>` at `0x00000000`.
* **Known Scope Limitation:** No hardware divider unit is included; avoid `div`/`divu`/`rem`/`remu` in target test binaries.

## How to Run
1. Build the test binaries and memory image using the build script/Makefile in `sw/`.
2. Compile `rtl/` and `tb/` in ModelSim, load the program memory, and run the simulation to inspect register states and logged memory stores.
