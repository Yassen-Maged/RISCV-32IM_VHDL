onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISCV_CORE_top_level_tb/rstn
add wave -noupdate /RISCV_CORE_top_level_tb/clk
add wave -noupdate -expand -group IF -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_stall(0)
add wave -noupdate -expand -group IF -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_flush(0)
add wave -noupdate -expand -group IF /RISCV_CORE_top_level_tb/dbg_pc
add wave -noupdate -expand -group IF /RISCV_CORE_top_level_tb/dbg_inst
add wave -noupdate -expand -group ID -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_stall(1)
add wave -noupdate -expand -group ID -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_flush(1)
add wave -noupdate -expand -group ID -radix hexadecimal -childformat {{/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(0) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(1) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(2) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(3) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(4) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(5) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(6) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(7) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(8) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(9) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(10) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(11) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(12) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(13) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(14) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(15) -radix decimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(16) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(17) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(18) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(19) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(20) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(21) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(22) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(23) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(24) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(25) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(26) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(27) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(28) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(29) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(30) -radix hexadecimal} {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(31) -radix hexadecimal}} -subitemconfig {/RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(0) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(1) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(2) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(3) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(4) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(5) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(6) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(7) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(8) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(9) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(10) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(11) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(12) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(13) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(14) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(15) {-height 15 -radix decimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(16) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(17) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(18) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(19) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(20) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(21) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(22) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(23) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(24) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(25) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(26) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(27) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(28) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(29) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(30) {-height 15 -radix hexadecimal} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs(31) {-height 15 -radix hexadecimal}} /RISCV_CORE_top_level_tb/dut/id_s/reg32/regs
add wave -noupdate -expand -group ID -radix hexadecimal /RISCV_CORE_top_level_tb/dbg_ifr_pc
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_ifr_inst
add wave -noupdate -expand -group ID -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_alu_ctrl
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_m_ext_en
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_imm_to_B
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_pc4_to_reg
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_id_pc4
add wave -noupdate -expand -group ID -radix unsigned /RISCV_CORE_top_level_tb/dbg_pc_to_a
add wave -noupdate -expand -group ID -radix unsigned /RISCV_CORE_top_level_tb/dbg_rs1_add
add wave -noupdate -expand -group ID -radix unsigned /RISCV_CORE_top_level_tb/dbg_rs2_add
add wave -noupdate -expand -group ID -radix unsigned /RISCV_CORE_top_level_tb/dbg_rd_add
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_branch
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_jal
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_jalr
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_taken
add wave -noupdate -expand -group ID /RISCV_CORE_top_level_tb/dbg_target
add wave -noupdate -expand -group EX -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_stall(2)
add wave -noupdate -expand -group EX -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_flush(2)
add wave -noupdate -expand -group EX /RISCV_CORE_top_level_tb/dbg_ex_pc
add wave -noupdate -expand -group EX -radix decimal /RISCV_CORE_top_level_tb/dbg_imm
add wave -noupdate -expand -group EX -radix decimal /RISCV_CORE_top_level_tb/dbg_rs1_data
add wave -noupdate -expand -group EX -radix decimal /RISCV_CORE_top_level_tb/dbg_rs2_data
add wave -noupdate -expand -group EX -radix decimal /RISCV_CORE_top_level_tb/dbg_ex_result
add wave -noupdate -expand -group MEM -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_stall(3)
add wave -noupdate -expand -group MEM -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_flush(3)
add wave -noupdate -expand -group MEM -radix unsigned /RISCV_CORE_top_level_tb/dbg_mem_rd_add
add wave -noupdate -expand -group MEM /RISCV_CORE_top_level_tb/dbg_st
add wave -noupdate -expand -group MEM -label {store address} -radix hexadecimal /RISCV_CORE_top_level_tb/dbg_ex_result
add wave -noupdate -expand -group MEM -radix decimal /RISCV_CORE_top_level_tb/dbg_st_data
add wave -noupdate -expand -group MEM /RISCV_CORE_top_level_tb/test_mem
add wave -noupdate -expand -group MEM -radix binary /RISCV_CORE_top_level_tb/dbg_st_type
add wave -noupdate -expand -group MEM -radix binary /RISCV_CORE_top_level_tb/dut/mem_s/byteen
add wave -noupdate -expand -group MEM /RISCV_CORE_top_level_tb/dbg_ld
add wave -noupdate -expand -group MEM -label {load address} -radix hexadecimal -radixshowbase 1 /RISCV_CORE_top_level_tb/dbg_ex_result
add wave -noupdate -expand -group MEM -radix hexadecimal /RISCV_CORE_top_level_tb/dbg_ld_data
add wave -noupdate -expand -group MEM /RISCV_CORE_top_level_tb/dbg_ld_type
add wave -noupdate -expand -group WB -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_stall(4)
add wave -noupdate -expand -group WB -radix binary -radixshowbase 0 /RISCV_CORE_top_level_tb/dbg_flush(4)
add wave -noupdate -expand -group WB /RISCV_CORE_top_level_tb/dbg_wb_pc4
add wave -noupdate -expand -group WB -radix unsigned /RISCV_CORE_top_level_tb/dbg_wb_add
add wave -noupdate -expand -group WB -radix decimal /RISCV_CORE_top_level_tb/dbg_wb_dout
add wave -noupdate -expand -group WB /RISCV_CORE_top_level_tb/dbg_wb_we
add wave -noupdate -expand -group {FWD AND HAZARD} -radix binary -childformat {{/RISCV_CORE_top_level_tb/dbg_stall(4) -radix binary} {/RISCV_CORE_top_level_tb/dbg_stall(3) -radix binary} {/RISCV_CORE_top_level_tb/dbg_stall(2) -radix binary} {/RISCV_CORE_top_level_tb/dbg_stall(1) -radix binary} {/RISCV_CORE_top_level_tb/dbg_stall(0) -radix binary}} -radixshowbase 0 -subitemconfig {/RISCV_CORE_top_level_tb/dbg_stall(4) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_stall(3) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_stall(2) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_stall(1) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_stall(0) {-height 15 -radix binary -radixshowbase 0}} /RISCV_CORE_top_level_tb/dbg_stall
add wave -noupdate -expand -group {FWD AND HAZARD} -radix binary -childformat {{/RISCV_CORE_top_level_tb/dbg_flush(4) -radix binary} {/RISCV_CORE_top_level_tb/dbg_flush(3) -radix binary} {/RISCV_CORE_top_level_tb/dbg_flush(2) -radix binary} {/RISCV_CORE_top_level_tb/dbg_flush(1) -radix binary} {/RISCV_CORE_top_level_tb/dbg_flush(0) -radix binary}} -radixshowbase 0 -subitemconfig {/RISCV_CORE_top_level_tb/dbg_flush(4) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_flush(3) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_flush(2) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_flush(1) {-height 15 -radix binary -radixshowbase 0} /RISCV_CORE_top_level_tb/dbg_flush(0) {-height 15 -radix binary -radixshowbase 0}} /RISCV_CORE_top_level_tb/dbg_flush
add wave -noupdate -expand -group {FWD AND HAZARD} -radix unsigned /RISCV_CORE_top_level_tb/dbg_fwd_mem_data
add wave -noupdate -expand -group {FWD AND HAZARD} -radix unsigned /RISCV_CORE_top_level_tb/dbg_fwd_wb_data
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_mem_to_id1
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_mem_to_id2
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_mem_to_ex1
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_mem_to_ex2
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_wb_to_ex1
add wave -noupdate -expand -group {FWD AND HAZARD} /RISCV_CORE_top_level_tb/dbg_wb_to_ex2
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/IF_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/opcode_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/ctrl_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/br_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/alu_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/mem_except
add wave -noupdate -group EXCEPTIONS /RISCV_CORE_top_level_tb/wb_except
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 5
configure wave -gridperiod 10
configure wave -griddelta 10
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {76 ps}
