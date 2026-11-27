# RTL (`rtl/`)

VHDL source files implementing the 32-bit pipelined **RV32IM** processor core (RV32I base + `mul`, without hardware division `div`/`rem`/`divu`/`remu`).

## Contents
* Pipeline stage modules (`IF`, `ID`, `EX`, `MEM`, `WB`) and inter-stage pipeline registers.
* Control unit, ALU, branch unit, and `mul` execution logic.
* Hazard detection and data forwarding unit (`fwd_hazard_unit`).
* Memory/RAM wrappers where applicable.

## Notes
* Keep core RTL here as the single source of truth; avoid duplicating identical core files inside `FPGA/`.
* Stage 2+ peripherals (such as UART TX store telemetry) should be added cleanly as separate modules and wired at the top level.
