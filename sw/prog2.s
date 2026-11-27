.global _start
_start:
    # --- Phase 1: x0 Hardwired Zero Protection & Edge Cases ---
    li   x2, 10         # x2 = 10
    li   x3, 20         # x3 = 20
    addi x0, x2, 5      # Attempt to write to x0 -> x0 must remain strictly 0
    add  x4, x0, x2     # x4 = 0 + 10 = 10 (Verify x0 reads as 0 in data path)

    # --- Phase 2: Store Data Forwarding (Store-after-ALU Hazard) ---
    add  x5, x2, x3     # x5 = 10 + 20 = 30
    sw   x5, 0(x0)      # Store x5 (30) to Data Memory[0] -> Tests forwarding to store data port (rs2)

    # --- Phase 3: Load-to-Store Data Hazard ---
    lw   x6, 0(x0)      # x6 = Mem[0] = 30
    sw   x6, 4(x0)      # Store x6 (30) to Data Memory[4] -> Tests load-to-store hazard handling

    # --- Phase 4: JALR Base Register Data Hazard (ID Stage Dependency) ---
    addi x10, x0, 48    # x10 = immediate offset/address base for jump target
    #jalr x0, x10, 36    # Jump to absolute address calculated from x10 + 36 -> Tests ID-stage hazard on jalr rs1
    addi x11, x0, 66    # Should be FLUSHED / SKIPPED due to jump control hazard

    # Dummy padding to align target offset if needed, or structured labels:
    nop                 # Nop padding
    nop                 # Nop padding

    # --- Phase 5: Taken vs. Not-Taken Branch Stress Test ---
    li   x12, 5         # x12 = 5
    li   x13, 5         # x13 = 5
    beq  x12, x13, branch_taken_1 # 5 == 5 -> Branch TAKEN (redirects PC, flushes 1 instruction)
    addi x14, x0, 11    # Should be FLUSHED / SKIPPED

branch_taken_1:
    addi x15, x0, 22    # x15 = 22 (Execution resumes here after taken branch)

    # --- Phase 6: Chained Load-Use Hazard (Multiple Dependent Stalls) ---
    lw   x16, 4(x0)     # x16 = Mem[4] = 30
    add  x17, x16, x2   # x17 = 30 + 10 = 40 (Triggers 1-cycle EX stage load-use stall)
    sub  x18, x17, x2   # x18 = 40 - 10 = 30 (EX-to-EX forwarding from the preceding add)

    # --- Phase 7: Infinite Loop Trap ---
done:
    j    done           # Traps processor in infinite loop for final waveform inspection
	
