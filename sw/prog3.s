.global _start
_start:
    # --- Phase 1: Upper Immediates (LUI / AUIPC) & Sign-Extension Corner Cases ---
    lui  x1, 0x80000          # x1 = 0x80000000 (-2147483648, INT32_MIN)
    addi x2, x0, -1           # x2 = 0xFFFFFFFF (-1)
    addi x3, x0, 1            # x3 = 0x00000001 (+1)
    auipc x4, 0x00001         # x4 = PC_of_auipc + 0x00001000

    # --- Phase 2: Signed vs. Unsigned Comparisons & Shifts ---
    slt  x5, x2, x3           # x5 = (-1 < 1) signed -> 1
    sltu x6, x2, x3           # x6 = (0xFFFFFFFF < 1) unsigned -> 0
    slt  x7, x1, x2           # x7 = (-2147483648 < -1) signed -> 1
    sltu x8, x1, x2           # x8 = (0x80000000 < 0xFFFFFFFF) unsigned -> 1

    sra  x9, x2, x3           # x9 = (-1 >>> 1 arithmetic) -> 0xFFFFFFFF (-1)
    srl  x10, x2, x3          # x10 = (0xFFFFFFFF >> 1 logical) -> 0x7FFFFFFF
    sll  x11, x3, x5          # x11 = (1 << 1) -> 2 (x5 forwarded from EX/MEM/WB)

    # --- Phase 3: Sub-Word Loads/Stores & Sign/Zero Extension ---
    lui  x12, 0x00001         # x12 = 0x00001000 (data memory base/offset)
    addi x13, x0, -128        # x13 = 0xFFFFFF80 (-128)
    sb   x13, 0(x12)          # Mem[0x1000] byte = 0x80
    lb   x14, 0(x12)          # x14 = sign-extended 0x80 -> 0xFFFFFF80 (-128)
    lbu  x15, 0(x12)          # x15 = zero-extended 0x80 -> 0x00000080 (128)

    addi x16, x0, -2          # x16 = 0xFFFFFFFE (-2)
    sh   x16, 2(x12)          # Mem[0x1002..0x1003] halfword = 0xFFFE
    lh   x17, 2(x12)          # x17 = sign-extended 0xFFFE -> 0xFFFFFFFE (-2)
    lhu  x18, 2(x12)          # x18 = zero-extended 0xFFFE -> 0x0000FFFE (65534)

    # Load-use immediately followed by ALU consuming loaded sign-extended value
    lw   x19, 0(x12)          # x19 = Mem[0x1000..0x1003] = 0xFFFE0080
    add  x20, x19, x14        # x20 = x19 + x14 (tests load-use stall + forwarding)

    # --- Phase 4: M-Extension Corner Cases ---
    mul  x21, x2, x2          # x21 = (-1) * (-1) = 1
    mulh x22, x1, x2          # x22 = upper 32 bits of INT32_MIN * (-1) -> 0 (or overflow check)
    mulhu x23, x2, x2         # x23 = upper 32 bits of 0xFFFFFFFF * 0xFFFFFFFF -> 0xFFFFFFFE
    div  x24, x2, x3          # x24 = (-1) / 1 = -1 (0xFFFFFFFF)
    divu x25, x2, x3          # x25 = 0xFFFFFFFF / 1 = 0xFFFFFFFF
    rem  x26, x2, x3          # x26 = (-1) % 1 = 0
    remu x27, x2, x3          # x27 = 0xFFFFFFFF % 1 = 0

    # --- Phase 5: Branch Polarity + Load-to-Branch + Jump Back-to-Back ---
    lw   x28, 0(x12)          # x28 = Mem[0x1000]
    bge  x28, x14, taken_bge 
	# Signed >= check right after load (2-cycle load-to-branch stall if applicable)
	#x28 = -130944,	x14 = -128-> NOT TAKEN
    addi x29, x0, 111         # Should be flushed/skipped when taken_bge is taken

taken_bge:
    addi x29, x0, 222         # x29 = 222
    jal  x30, sub_routine     # x30 = return PC, jump to sub_routine
    addi x31, x0, 88          # Flushed on initial jump; target on jalr return
	j done					  # 23
	#023 : 00C0006F;
	#0 0000000110 0 00000000 00000 1101111
	#6=3*2= 0 00000000 0 0000000110
	#PC = 0x8C = 0x23 ----> Target =  = 0x3ff
	#0xF70 = 0 00000000 1 1110111000 0
	#0 1110111000 1 00000000 00000 1101111

sub_routine:
    addi x29, x29, 1          # x29 = 223 24
    jalr x0, x30, 0           # Return to x30 (addi x31, x0, 88 -> x31 = 88) 25

    # --- Phase 6: Infinite Loop Trap ---
done:
    j    done                 # Trap at end for waveform inspection 26