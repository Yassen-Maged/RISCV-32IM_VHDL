# Testbench & Simulation (`tb/`)

VHDL testbenches and ModelSim `.do` scripts for verifying the RV32IM core.

## Contents
* **Top-level testbench** (`RISCV_CORE_top_level_tb.vhd` and related testbench files).
* **Automated store-capture logging (`dbg_st`)** formatting store addresses and data in hex using VHDL-2008 (`to_hstring`).
* **`wave.do`** — Saved ModelSim waveform configuration.
* **`s1.do`** — ModelSim automation script (`delete wave *`, `do wave.do`, `restart`, `run -all`).

## How to Run in ModelSim
1. Compile `rtl/` and `tb/` sources in order (VHDL-2008 enabled for testbench logging).
2. Ensure the test program memory image is built/loaded.
3. In the ModelSim transcript/console, run `do s1.do` to load `wave.do`, restart, and run until completion. The simulation stops automatically when the halt instruction (`done: j done`, `0x6f`) is reached.