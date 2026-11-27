.global _start
_start:
# --- Phase 1: Initialization & Basic ALU (No Hazards) ---
    li   x2, 10         # x2 = 10
	#00A00113
    li   x3, 20         # x3 = 20
	#01400193
    li   x5, 5          # x5 = 5
	#00500293

    add  x1, x2, x3     # x1 = 30 (Base for forwarding)
	#003 : 003100B3;
    sub  x4, x3, x2     # x4 = 10
	#004 : 40218233;
    and  x6, x1, x5     # x6 = 30 & 5 = 4
	#005 : 0050F333;
    or   x7, x4, x5     # x7 = 10 | 5 = 15
	#006 : 005263B3;

# --- Phase 2: True EX-to-EX & WB-to-EX Forwarding ---
    add  x1, x2, x3     # x1 = 30
	#007 : 003100B3;
    add  x8, x1, x2     # CONSUMER IS IMMEDIATE: Uses x1 directly from EX stage -> Tests EX-to-EX Forwarding (x8 = 40)
	#008 : 00208433;
    addi x9, x1, 10     # Uses x1 later -> Tests WB-to-EX Forwarding (x9 = 40)
	#009 : 00A08493;

# --- Phase 3: M-Extension Check ---
    mul  x10, x2, x3    # x10 = 10 * 20 = 200 (Tests multiplier unit in EX)
	#00A : 02310533;
# --- Phase 4: Memory Operations (Store & Load) ---
    sw   x1, 0(x0)      # Store 30 into Data Memory address 0
	#00B : 00102023;
    lw   x11, 0(x0)     # Load back into x11 (x11 = 30)
	#00C : 00002583;
    
# --- Phase 5: Load-Use Hazard (EX Stage Stall - 1 Cycle) ---
    lw   x12, 0(x0)     # x12 = Mem[0]
	#00D : 00002603;
    add  x13, x12, x2   # x13 = 40, DEPENDENCY: Needs x12 immediately -> Forces 1-cycle EX stall
	#00E : 002606B3;
# --- Phase 6: ALU-to-Branch Hazard (ID Stage Stall - 1 Cycle) ---
    addi x14, x0, 1     # x14 = 1
	#00F : 00100713;    
    beq  x14, x0, skipped_branch # DEPENDENCY: Branch checks x14 immediately -> Forces 1-cycle ID stall
	#010 : 00070463;
    addi x15, x0, 99    # This should execute (Branch not taken)
	#011 : 06300793;
	
skipped_branch:
# --- Phase 7: Load-to-Branch Hazard (ID Stage Stall - 2 Cycles) ---
    lw   x16, 0(x0)     # x16 = Mem[0] (30)
	#012 : 00002803;
    beq  x16, x2, branch_target # DEPENDENCY: Branch checks load result -> Forces 2-cycle ID stall
	#013 : 00280463;
    addi x17, x0, 77    # Skipped if branch taken
    #014 : 04D00893;
	
branch_target:
# --- Phase 8: Jumps (JAL & JALR) ---
    jal  x1, jump_destination   # Jump forward, save return address in x1
	#015 : 010000EF;
    addi x18, x0, 0     # Should be flushed/skipped
	#016 : 00000913;
	sub x3, x15, x14
	#017 : 40E781B3;
	j    done
	#018 : 0080006F;
	
jump_destination:
    jalr x0, x1, 0      # Jump back using register address (return)
	#019 : 00008067;
	
# --- Phase 9: Infinite Loop Trap ---
done:
    j    done           # Traps processor at the end for waveform inspection
	#01A : 0000006F;

