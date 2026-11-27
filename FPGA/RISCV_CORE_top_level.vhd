library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISCV_CORE_top_level is
generic(xlen: natural:= 32;
a_width: natural := 10 -- --max = 30 (1G of memory)
);
port(
	clk,rstn: in std_logic;
	
	--- DEBUG PORTS
	--if
	dbg_pc				: out std_logic_vector(xlen-1 downto 0);
	dbg_inst				: out std_logic_vector(xlen-1 downto 0);
	dbg_ifr_pc			: out std_logic_vector(a_width-1 downto 0);
	dbg_ifr_inst		: out std_logic_vector(xlen-1 downto 0);
	
	--id	
	dbg_alu_ctrl		: out std_logic_vector(3 downto 0);
	dbg_m_ext_en		: out std_logic;
	dbg_imm_to_B		: out std_logic;
	dbg_pc4_to_reg		: out std_logic;
	dbg_pc_to_a			: out std_logic;
	dbg_rs1_add			: out std_logic_vector(4 downto 0);
	dbg_rs2_add			: out std_logic_vector(4 downto 0);
	dbg_rd_add			: out std_logic_vector(4 downto 0);
	dbg_branch			: out std_Logic;
	dbg_jal				: out std_Logic;
	dbg_jalr				: out std_Logic;
	dbg_taken			: out std_logic;
	dbg_target			: out std_logic_vector(xlen-1 downto 0);
	dbg_id_pc4			: out std_logic_vector(xlen-1 downto 0);
		
	--ex	
	dbg_ex_pc			: out std_logic_vector(xlen-1 downto 0);
	dbg_imm				: out std_logic_vector(xlen-1 downto 0);
	dbg_rs1_data		: out std_logic_vector(xlen-1 downto 0);
	dbg_rs2_data		: out std_logic_vector(xlen-1 downto 0);
	dbg_ex_result		: out std_logic_vector(xlen-1 downto 0);
		
	--mem	
	dbg_mem_rd_add		: out std_logic_vector(4 downto 0);
	dbg_st				: out std_logic;
	dbg_st_type			: out std_logic_vector(2 downto 0);
	dbg_st_data			: out std_logic_vector(xlen-1 downto 0);
	dbg_ld				: out std_logic;
	dbg_ld_type			: out std_logic_vector(2 downto 0);
	dbg_ld_data			: out std_logic_vector(xlen-1 downto 0);
		
	--wb	
	dbg_wb_pc4			: out std_logic_vector(xlen-1 downto 0);
	dbg_wb_add			: out std_logic_vector(4 downto 0);
	dbg_wb_dout			: out std_logic_vector(xlen-1 downto 0);
	dbg_wb_we			: out std_logic;
	
	--fwd and hazard
	dbg_stall			: out std_logic_vector(4 downto 0);
	dbg_flush			: out std_logic_vector(4 downto 0);
	--FWD indicator signals to ID
	dbg_mem_to_id1		: out std_logic;
	dbg_mem_to_id2		: out std_logic;
	--FWD indicator signals to EX
	dbg_mem_to_ex1		: out std_logic;
	dbg_mem_to_ex2		: out std_logic;
	dbg_wb_to_ex1		: out std_logic;
	dbg_wb_to_ex2		: out std_logic;
	--FWD Data
	dbg_fwd_mem_data	: out std_logic_vector(xlen -1 downto 0); --data from ex_mem_reg output
	dbg_fwd_wb_data	: out std_logic_vector(xlen -1 downto 0); --data from mem_wb_reg output
	-----------
	
	IF_except			: out std_logic;
	opcode_except		: out std_logic;
	ctrl_except			: out std_logic;
	br_except			: out std_logic;
	alu_except			: out std_logic;
	mem_except			: out std_logic;
	wb_except			: out std_logic
);
end RISCV_CORE_top_level;

architecture struct of RISCV_CORE_top_level is
------------------ IF STAGE ------------------
component if_stage is
generic(xlen: natural := 32;
a_width: natural := 10 -- --max = 30 (1G of memory)
);
port(
	clk,rstn: in std_logic;
	flush,stall: in std_logic;
	
	jal		: in std_logic;
	jalr		: in std_logic;
	branch	: in std_logic;
	taken		: in std_logic;
	target	: in std_logic_vector(xlen -1 downto 0);
	
	inst		: out std_logic_vector(xlen -1 downto 0);
	pc_out	: out std_logic_vector(xlen -1 downto 0);
	pc4_out	: out std_logic_vector(xlen -1 downto 0);
	
	IF_except	: out std_logic
);
end component;
signal if_inst, if_pc, if_pc4: std_logic_vector(xlen -1 downto 0);

------------------ IF/ID REG ------------------
component if_id_reg is
generic(XLEN: natural:= 32);
port(
	clk,rstn: in std_logic;
	flush,stall: in std_logic;
	
	--inputs
	if_inst: in std_logic_vector(31 downto 0);
	if_pc,if_pc4: in std_logic_vector(xlen -1 downto 0);
	
	--outputs
	id_inst: out std_logic_vector(31 downto 0);
	id_pc,id_pc4: out std_logic_vector(xlen -1 downto 0)
);
end component;
signal ifr_inst, ifr_pc, ifr_pc4: std_logic_vector(xlen -1 downto 0);

------------------ ID STAGE ------------------
component id_stage is
generic(xlen: natural:= 32);
port(
	clk,rstn: in std_logic;
	--------------CTRL UNIT PORTS--------------
	inst				: in std_logic_Vector(xlen -1 downto 0);
	imm				: out std_logic_vector(xlen -1 downto 0);
	-- ALU	
	alu_ctrl			: out std_logic_vector(3 downto 0);
	m_ext_en			: out std_logic;
	imm_to_B			: out std_logic;
	pc_to_a			: out std_logic;
	pc4_to_reg		: out std_logic;
	
	-- REG file	
	rs1_add			: out std_logic_vector(4 downto 0);
	rs2_add			: out std_logic_vector(4 downto 0);
	rs1_data			: out std_logic_vector(xlen -1 downto 0);
	rs2_data			: out std_logic_vector(xlen -1 downto 0);
	rd_add			: out std_logic_vector(4 downto 0);
	reg_write		: out std_logic; 
	
	-- MEM	
	store				: out std_logic;
	st_type			: out std_logic_vector(2 downto 0); --store type
	load				: out std_logic;
	ld_type			: out std_logic_vector(2 downto 0); --load type
	--JUMP AND BRANCH
	jal				: out std_logic:= '0';
	jalr				: out std_logic:= '0';
	
	opcode_except	: out std_logic;
	ctrl_except		: out std_logic;
	--------------REG FILE PORTS (WB)--------------
	wb_we				: in std_logic;
	wb_rd_add		: in std_logic_Vector(4 downto 0);
	wb_rd_data		: in std_logic_vector(xlen -1 downto 0);
		
	--------------BRANCH UNIT PORTS--------------
	PC					: in std_logic_vector(xlen -1 downto 0);
	taken				: out std_logic;
	target			: out std_logic_vector(xlen -1 downto 0);
	branch			: out std_logic;
	
	--FWD AND HAZARD
	mem_to_id1		: in std_logic;
	mem_to_id2		: in std_logic;
	fwd_mem_data	: in std_logic_vector(xlen -1 downto 0);
	
	br_except		: out std_logic
	
);
end component;
signal id_imm, id_rs1_data, id_rs2_data, id_target: std_logic_vector(xlen -1 downto 0);
signal id_alu_ctrl: std_logic_vector(3 downto 0);
signal id_m_ext_en, id_imm_to_B, id_pc_to_a, id_pc4_to_reg,
 id_reg_write, id_store, id_load, id_taken,
 id_jal, id_jalr, id_branch: std_logic;
signal id_rs1_add, id_rs2_add, id_rd_add: std_logic_vector(4 downto 0);
signal id_st_type, id_ld_type: std_logic_vector(2 downto 0);

------------------ ID/EX REG ------------------
component id_ex_reg is
generic(XLEN: natural:= 32);
port(
	--inputs
	clk,rstn			: in std_logic;
	flush,stall		: in std_logic;
	
	id_imm			: in std_logic_vector(xlen -1 downto 0):= (others => '0');
	
	--ALU
	id_alu_ctrl		: in std_logic_vector(3 downto 0):= (others => '0');
	id_m_ext_en		: in std_logic;
	id_imm_to_B		: in std_logic:= '0';
	id_pc_to_a		: in std_logic:= '0';
	id_pc4_to_reg	: in std_logic:= '0';

	--REG file
	id_rs1_add		: in std_logic_vector(4 downto 0):= (others => '0');
	id_rs2_add		: in std_logic_vector(4 downto 0):= (others => '0');
	id_rs1_data		: in std_logic_vector(xlen -1 downto 0);
	id_rs2_data		: in std_logic_vector(xlen -1 downto 0);
	id_rd_add		: in std_logic_vector(4 downto 0):= (others => '0');
	id_reg_write	: in std_logic; 

	--MEM
	id_store			: in std_logic:= '0';
	id_st_type		: in std_logic_vector(2 downto 0); --store type
	id_load			: in std_logic:= '0';
	id_ld_type		: in std_logic_vector(2 downto 0); --load type

	--IF STAGE
	id_pc				: in std_logic_vector(xlen -1 downto 0);	
	id_pc4			: in std_logic_vector(xlen -1 downto 0);					
	
	
	--outputs
	ex_imm			: out std_logic_vector(xlen -1 downto 0):= (others => '0');
	
	--ALU
	ex_alu_ctrl		: out std_logic_vector(3 downto 0):= (others => '0');
	ex_m_ext_en		: out std_logic;
	ex_imm_to_B		: out std_logic:= '0';
	ex_pc_to_a		: out std_logic:= '0';
	ex_pc4_to_reg	: out std_logic:= '0';

	--REG file
	ex_rs1_add		: out std_logic_vector(4 downto 0):= (others => '0');
	ex_rs2_add		: out std_logic_vector(4 downto 0):= (others => '0');
	ex_rs1_data		: out std_logic_vector(xlen -1 downto 0);
	ex_rs2_data		: out std_logic_vector(xlen -1 downto 0);
	ex_rd_add		: out std_logic_vector(4 downto 0):= (others => '0');
	ex_reg_write	: out std_logic; 

	--MEM
	ex_store			: out std_logic:= '0';
	ex_st_type		: out std_logic_vector(2 downto 0); --store type
	ex_load			: out std_logic:= '0';
	ex_ld_type		: out std_logic_vector(2 downto 0); --load type
	
	--IF STAGE
	ex_pc				: out std_logic_vector(xlen -1 downto 0);	
	ex_pc4			: out std_logic_vector(xlen -1 downto 0)
);
end component;
signal idr_imm, idr_rs1_data, idr_rs2_data, idr_pc, idr_pc4: std_logic_vector(xlen -1 downto 0);
signal idr_alu_ctrl: std_logic_vector(3 downto 0);
signal idr_rs1_add, idr_rs2_add, idr_rd_add: std_logic_vector(4 downto 0);
signal idr_st_type, idr_ld_type: std_logic_vector(2 downto 0);
signal idr_m_ext_en, idr_imm_to_B, idr_pc_to_a, idr_pc4_to_reg,
 idr_reg_write, idr_store, idr_load : std_logic;

------------------ EX STAGE ------------------
component ex_stage is
generic(XLEN: natural:= 32);
port(
	--inputs
	--ALU
	imm				: in std_logic_Vector(xlen -1 downto 0);
	ctrl				: in std_logic_vector(3 downto 0);
	m_ext_en			: in std_logic;
	imm_to_B			: in std_logic;
	pc_to_a			: in std_logic;
	pc4_to_reg		: in std_logic;
	
	--REG file	
	rs1_data			: in std_logic_Vector(xlen -1 downto 0);
	rs2_data			: in std_logic_Vector(xlen -1 downto 0);
	
	--IF STAGE
	pc					: in std_logic_Vector(xlen -1 downto 0);
	pc4				: in std_logic_Vector(xlen -1 downto 0);

	--outputs
	ex_rs2_data		: out std_logic_vector(xlen -1 downto 0);
	Result			: out std_logic_vector(xlen -1 downto 0);
	
	--FWD AND HAZARD
	mem_to_ex1		: in std_logic;
	mem_to_ex2		: in std_logic;
	wb_to_ex1		: in std_logic;
	wb_to_ex2		: in std_logic;
	fwd_mem_data	: in std_logic_vector(xlen -1 downto 0);
	fwd_wb_data		: in std_logic_vector(xlen -1 downto 0);
	
	alu_except		: out std_logic
);
end component;
signal ex_rs2_data, ex_result: std_logic_vector(xlen -1 downto 0);

------------------ EX/MEM REG ------------------
component ex_mem_reg is
generic(XLEN: natural:= 32);
port(
	--input
	clk,rstn				: in std_logic;
	flush,stall			: in std_logic;
	
	--EX
	ex_alu_result		: in std_logic_vector(xlen -1 downto 0);
	ex_pc4_to_reg		: in std_logic;
	
	--REG file
	ex_rd_add			: in std_logic_vector(4 downto 0);
	ex_reg_write		: in std_logic;
	
	--MEM
	ex_load				: in std_logic;
	ex_ld_type			: in std_logic_vector(2 downto 0); -- load type
	
	--IF STAGE
	ex_pc4				: in std_logic_vector(xlen -1 downto 0);

	
	--output
	--EX
	mem_alu_result		: out std_logic_vector(xlen -1 downto 0);
	mem_pc4_to_reg		: out std_logic;
	
	--REG file
	mem_rd_add			: out std_logic_vector(4 downto 0);
	mem_reg_write		: out std_logic;

	mem_load				: out std_logic;
	mem_ld_type			: out std_logic_vector(2 downto 0); -- load type
	
	--IF STAGE
	mem_pc4				: out std_logic_vector(xlen -1 downto 0)
	
);
end component;
signal exr_alu_result, exr_pc4: std_logic_vector(xlen -1 downto 0);
signal exr_rd_add: std_logic_vector(4 downto 0);
signal exr_ld_type: std_logic_vector(2 downto 0);
signal exr_pc4_to_reg, exr_reg_write, exr_load: std_logic;

------------------ MEM STAGE ------------------
component mem_stage is
generic(xlen: natural:= 32;
byteen_width: natural:= 4;
a_width: natural := 10 --max = 30 (1G of memory)
);
port(
	clk,rstn		: in std_logic;
	flush			: in std_logic;
--------------BYPASS THE EX_MEM REG FOR THESE PORTS--------------
	alu_result	: in std_logic_vector(xlen -1 downto 0); -- ram address
	rs2_data		: in std_logic_vector(xlen -1 downto 0); -- store data
	store			: in std_logic;
	st_type		: in std_logic_vector(2 downto 0); -- store type
	load			: in std_logic;
	ld_type		: in std_logic_vector(2 downto 0); -- load type
-----------------------------------------------------------------
	ld_data		: out std_logic_vector(xlen -1 downto 0); -- load data
	
	mem_except	: out std_logic
);
end component;
signal mem_ld_data: std_logic_vector(xlen -1 downto 0); -- load data

------------------ MEM/WB REG ------------------
component mem_wb_reg is
generic(XLEN: natural:= 32);
port(
	--input
	clk,rstn: in std_logic;
	flush,stall: in std_logic;
	
	--EX
	mem_alu_result	: in std_logic_vector(xlen -1 downto 0);
	mem_pc4_to_reg	: in std_logic;
	
	--REG file
	mem_rd_add		: in std_logic_vector(4 downto 0);
	mem_reg_write	: in std_logic;
	
	--MEM
	mem_load			: in std_logic;
	mem_ld_type		: in std_logic_vector(2 downto 0); -- load type
	mem_ld_data		: in std_logic_vector(xlen -1 downto 0);
	
	--IF STAGE
	mem_pc4			: in std_logic_vector(xlen -1 downto 0);
	
	--output
	--EX
	wb_alu_result	: out std_logic_vector(xlen -1 downto 0);
	wb_pc4_to_reg	: out std_logic;
	
	--REG file
	wb_rd_add		: out std_logic_vector(4 downto 0);
	wb_reg_write	: out std_logic;
	
	--MEM
	wb_load			: out std_logic;
	wb_ld_type		: out std_logic_vector(2 downto 0); -- load type
	wb_ld_data		: out std_logic_vector(xlen -1 downto 0);
	
	--IF STAGE
	wb_pc4			: out std_logic_vector(xlen -1 downto 0)
);
end component;
signal memr_alu_result, memr_ld_data, memr_pc4: std_logic_vector(xlen -1 downto 0);
signal memr_rd_add: std_logic_vector(4 downto 0);
signal memr_ld_type: std_logic_vector(2 downto 0);
signal memr_pc4_to_reg, memr_reg_write, memr_load: std_logic;

------------------ WB STAGE ------------------
component wb_stage is
generic(xlen: natural:= 32);
port(
	alu_result	: in std_logic_vector(xlen -1 downto 0);
	pc4_to_reg	: in std_logic;

	load			: in std_logic;
	ld_type		: in std_logic_vector(2 downto 0);
	ld_data		: in std_logic_vector(xlen -1 downto 0);

	pc4			: in std_logic_vector(xlen -1 downto 0);

	data_out		: out std_logic_vector(xlen -1 downto 0);
	wb_except	: out std_logic
);
end component;
signal wb_data_out: std_logic_vector(xlen -1 downto 0);

------------------ FORWARD AND HAZARD UNIT ------------------
component fwd_hazard_unit_v1 is
generic(xlen: natural:= 32);
port(
-------------------- hazard-only ports --------------------
	flush				: out std_logic_vector(4 downto 0);
	stall				: out std_logic_vector(4 downto 0);
-- 0:IF stage, 1:IF_ID_REG, 2:ID_EX_REG, 3:EX_MEM_REG, 4:MEM_WB_REG
-------------------- hazard & FWD ports --------------------
	--ID & EX inputs
	id_branch		: in std_logic;
	id_jalr			: in std_logic;
	id_rs1_add		: in std_logic_vector(4 downto 0);
	id_rs2_add		: in std_logic_vector(4 downto 0);
	ex_rs1_add		: in std_logic_vector(4 downto 0);
	ex_rs2_add		: in std_logic_vector(4 downto 0);
	--ID/EX register output
	ex_rd_add		: in std_logic_vector(4 downto 0);
	ex_reg_write	: in std_logic;
	--EX/MEM register output
	mem_rd_add		: in std_logic_vector(4 downto 0);
	mem_reg_write	: in std_logic;
	mem_rd_data		: in std_logic_vector(xlen -1 downto 0);
	mem_load			: in std_logic; --decides whether to get data from ex_mem_reg or ram.dout
	--MEM/WB register output
	wb_rd_add		: in std_logic_vector(4 downto 0);
	wb_reg_write	: in std_logic;
	wb_rd_data		: in std_logic_vector(xlen -1 downto 0);
	--FWD indicator signals to ID
	mem_to_id1		: out std_logic;
	mem_to_id2		: out std_logic;
	--FWD indicator signals to EX
	mem_to_ex1		: out std_logic;
	mem_to_ex2		: out std_logic;
	wb_to_ex1		: out std_logic;
	wb_to_ex2		: out std_logic;
	--FWD Data
	fwd_mem_data	: out std_logic_vector(xlen -1 downto 0); --data from ex_mem_reg output
	fwd_wb_data		: out std_logic_vector(xlen -1 downto 0) --data from mem_wb_reg output
);
end component;
signal fwd_mem_data, fwd_wb_data: std_logic_vector(xlen -1 downto 0);
signal flush,stall: std_logic_vector(4 downto 0);
signal fwd_mem_to_id1, fwd_mem_to_id2, fwd_mem_to_ex1, fwd_mem_to_ex2,
 fwd_wb_to_ex1, fwd_wb_to_ex2: std_logic;


begin
------------------ IF STAGE
IF_s: IF_stage
generic map(xlen => xlen, a_width => a_width)
port map(
	clk			=> clk			,
	rstn			=> rstn			,
	flUsh			=> flush(0)		,
	stall			=> stall(0)		,
	jal			=> id_jal	 	,
	jalr			=> id_jalr	 	,
	branch		=> id_branch 	,
	taken			=> id_taken		,
	target		=> id_target	,
	inst			=> if_inst			,
	pc_out		=> if_pc				,
	pc4_out		=> if_pc4			,
	IF_except	=>	IF_except
);

------------------ IF/ID REG
if_id: if_id_reg
generic map(xlen => xlen)
port map(
	--inputs
	clk			=> clk		,
	rstn			=> rstn		,
	flush			=> flush(1)	,
	stall			=> stall(1)	,
	
	if_inst		=> if_inst	,
	if_pc			=> if_pc		,
	if_pc4		=> if_pc4	,
	
	--outputs
	id_inst		=> ifr_inst		,
	id_pc			=> ifr_pc		,
	id_pc4		=> ifr_pc4
);

------------------ ID STAGE
id_s: id_stage
generic map(xlen => xlen)
port map(
	clk				=> clk				,
	rstn				=> rstn				,
	inst				=> ifr_inst			,
	imm				=> id_imm				,
	alu_ctrl			=> id_alu_ctrl			,
	m_ext_en			=> id_m_ext_en			,
	imm_to_B			=> id_imm_to_B			,
	pc_to_a			=> id_pc_to_a			,
	pc4_to_reg		=> id_pc4_to_reg		,
	rs1_add			=> id_rs1_add			,
	rs2_add			=> id_rs2_add			,
	rs1_data			=> id_rs1_data			,
	rs2_data			=> id_rs2_data			,
	rd_add			=> id_rd_add			,
	reg_write		=> id_reg_write		,
	store				=> id_store				,
	st_type			=> id_st_type			,
	load				=> id_load				,
	ld_type			=> id_ld_type			,
	jal				=> id_jal				,
	jalr				=> id_jalr				,
	opcode_except	=> opcode_except		,
	ctrl_except		=> ctrl_except			,
	wb_we				=> memr_reg_write	,
	wb_rd_add		=> memr_rd_add		,
	wb_rd_data		=> wb_data_out		,
	PC					=> ifr_PC			,
	taken				=> id_taken				,
	target			=> id_target			,
	branch			=> id_branch			,
	mem_to_id1		=> fwd_mem_to_id1	,
	mem_to_id2		=> fwd_mem_to_id2	,
	fwd_mem_data	=> fwd_mem_data	,
	br_except		=> br_except
);	
	
------------------ ID/EX REG
id_ex: id_ex_reg
generic map(xlen => xlen)
port map(
	--inputs
	clk				=> clk				,
	rstn				=> rstn				,
	flush				=> flush(2)			,
	stall				=> stall(2)			,

	id_imm			=> id_imm			,
	 
	--ALU 
	id_alu_ctrl		=> id_alu_ctrl		,
	id_m_ext_en		=> id_m_ext_en		,
	id_imm_to_B		=> id_imm_to_B		,
	id_pc_to_a		=> id_pc_to_a		,
	id_pc4_to_reg	=> id_pc4_to_reg	,
	 
	--REG file 
	id_rs1_add		=> id_rs1_add		,
	id_rs2_add		=> id_rs2_add		,
	id_rs1_data		=> id_rs1_data		,
	id_rs2_data		=> id_rs2_data		,
	id_rd_add		=> id_rd_add		,
	id_reg_write	=> id_reg_write	,
	 
	--MEM 
	id_store			=> id_store			,
	id_st_type		=> id_st_type		,
	id_load			=> id_load			,
	id_ld_type		=> id_ld_type		,
	 
	--IF STAGE 
	id_pc				=> ifr_pc			,
	id_pc4			=> ifr_pc4			,
 
	--outputs 
	ex_imm			=> idr_imm				,
                     
	--ALU            
	ex_alu_ctrl		=> idr_alu_ctrl		,
	ex_m_ext_en		=> idr_m_ext_en		,
	ex_imm_to_B		=> idr_imm_to_B		,
	ex_pc_to_a		=> idr_pc_to_a			,
	ex_pc4_to_reg	=> idr_pc4_to_reg		,
                     
	--REG file        
	ex_rs1_add		=> idr_rs1_add			,
	ex_rs2_add		=> idr_rs2_add			,
	ex_rs1_data		=> idr_rs1_data		,
	ex_rs2_data		=> idr_rs2_data		,
	ex_rd_add		=> idr_rd_add			,
	ex_reg_write	=> idr_reg_write		,
                     
	--MEM             
	ex_store			=> idr_store			,
	ex_st_type		=> idr_st_type			,
	ex_load			=> idr_load				,
	ex_ld_type		=> idr_ld_type			,
                     
	--IF STAGE        
	ex_pc				=> idr_pc				,
	ex_pc4			=> idr_pc4				
);
	
------------------ EX STAGE
ex_s: ex_stage
generic map(xlen => xlen)
port map(
	--inputs
	--ALU
	imm				=> idr_imm			,
	ctrl				=> idr_alu_ctrl	,
	M_ext_en			=> idr_m_ext_en	,
	imm_to_B			=> idr_imm_to_B	,
	pc_to_a			=> idr_pc_to_a		,
	pc4_to_reg		=> idr_pc4_to_reg	,
	
	--REG file
	rs1_data			=> idr_rs1_data	,
	rs2_data			=> idr_rs2_data	,
	
	--IF STAGE
	pc					=> idr_pc			,
	pc4				=> idr_pc4			,
	
	--outputs
	ex_rs2_data		=> ex_rs2_data			,
	result			=> ex_result			,
	
	--FWD AND HAZARD
	mem_to_ex1		=> fwd_mem_to_ex1 ,
	mem_to_ex2		=> fwd_mem_to_ex2 ,
	wb_to_ex1		=> fwd_wb_to_ex1	,
	wb_to_ex2		=> fwd_wb_to_ex2	,
	fwd_mem_data	=> fwd_mem_data 	,
	fwd_wb_data		=> fwd_wb_data	 	,
	
	alu_except		=> alu_except
);
	
------------------ EX/MEM REG
ex_mem: ex_mem_reg
generic map(xlen => xlen)
port map(
	--inputs
	clk					=> clk				,
	rstn					=> rstn				,
	flush					=> flush(3)			,
	stall					=> stall(3)			,
	
	--EX
	ex_alu_result		=> ex_result		,
	ex_pc4_to_reg		=> idr_pc4_to_reg	,
		
	--REG file	
	ex_rd_add			=> idr_rd_add		,
	ex_reg_write		=> idr_reg_write	,
		
	--MEM	
	ex_load				=> idr_load			,
	ex_ld_type			=> idr_ld_type		,
		
	--IF STAGE	
	ex_pc4				=> idr_pc4			,
	
	--output
	--EX
	mem_alu_result		=> exr_alu_result		,
	mem_pc4_to_reg		=> exr_pc4_to_reg		,
		
	--REG file	
	mem_rd_add			=> exr_rd_add			,
	mem_reg_write		=> exr_reg_write		,
		
	mem_load				=> exr_load				,
	mem_ld_type			=> exr_ld_type			,
		
	--IF STAGE	
	mem_pc4				=> exr_pc4				
);
	
	
------------------ MEM STAGE	
mem_s: mem_stage
generic map(xlen => xlen, a_width => a_width)
port map(
	clk			=> clk				,
	rstn			=> rstn				,
	flush			=>	flush(3)			,
	-----------BYPASS THE EX_MEM REG FOR THESE PORTS
	alu_result	=> ex_result		,
	rs2_data		=> ex_rs2_data		,
	store			=> idr_store		,
	st_type		=> idr_st_type		,
	load			=> idr_load			,
	ld_type		=> idr_ld_type		,
	------------
	ld_data		=> mem_ld_data			,
	
	mem_except => mem_except
);
	
------------------ MEM/WB REG
mem_wb: mem_wb_reg
generic map(xlen => xlen)
port map(
	--inputs
	clk				=> clk					,
	rstn				=> rstn					,
	flush				=> flush(4)				,
	stall				=> stall(4)				,
	
	--EX
	mem_alu_result	=> exr_alu_result		,
	mem_pc4_to_reg	=> exr_pc4_to_reg		,
	
	--REG file
	mem_rd_add		=> exr_rd_add			,
	mem_reg_write	=> exr_reg_write		,
	
	--MEM
	mem_load			=> exr_load				,
	mem_ld_type		=> exr_ld_type			,
	mem_ld_data		=> mem_ld_data			,
	
	--IF STAGE
	mem_pc4			=> exr_pc4				,
	
	--output
	--EX
	wb_alu_result	=> memr_alu_result	 	,
	wb_pc4_to_reg	=> memr_pc4_to_reg	 	,
	                  
	--REG file        --REG file
	wb_rd_add		=> memr_rd_add		 		,
	wb_reg_write	=> memr_reg_write	 		,
	                  
	--MEM             --MEM
	wb_load			=> memr_load			 	,
	wb_ld_type		=> memr_ld_type		 	,
	wb_ld_data		=> memr_ld_data		 	,
	                  
	--IF STAGE        --IF STAGE
	wb_pc4			=> memr_pc4			 		
);	
	
------------------ WB STAGE	
wb_s: wb_stage
generic map(xlen => xlen)
port map(	
	--inputs
	--EX
	alu_result	=> memr_alu_result	,
	pc4_to_reg	=> memr_pc4_to_reg	,
	--MEM
	load			=> memr_load			,
	ld_type		=> memr_ld_type		,
	ld_data		=> memr_ld_data		,
	--IF Stage
	pc4			=> memr_pc4				,
	
	--outputs
	data_out		=> wb_data_out				,
	wb_except	=> wb_except
);	
	
------------------ FORWARD AND HAZARD UNIT
fwd_hazard: fwd_hazard_unit_v1	
generic map(xlen => xlen)
port map(	
-------------------- hazard-only ports --------------------
	flush				=> flush					,
	stall				=> stall					,
-- 0:IF stage, 1:IF_ID_REG, 2:ID_EX_REG, 3:EX_MEM_REG, 4:MEM_WB_REG
-------------------- hazard & FWD ports --------------------
	--ID & EX inputs
	id_branch		=> id_branch		,
	id_jalr			=> id_jalr			,
	id_rs1_add		=> id_rs1_add		,
	id_rs2_add		=> id_rs2_add		,
	ex_rs1_add		=> idr_rs1_add		,
	ex_rs2_add		=> idr_rs2_add		,
	--ID/EX register output
	ex_rd_add		=> idr_rd_add		,
	ex_reg_write	=> idr_reg_write	,
	--EX/MEM register output
	mem_rd_add		=> exr_rd_add		,
	mem_reg_write	=> exr_reg_write	,
	mem_rd_data		=> exr_alu_result	,
	mem_load			=> exr_load			,
	--MEM/WB register output
	wb_rd_add		=> memr_rd_add		,
	wb_reg_write	=> memr_reg_write	,
	wb_rd_data		=> wb_data_out		,
	--FWD indicator signals to ID
	mem_to_id1		=> fwd_mem_to_id1		,
	mem_to_id2		=> fwd_mem_to_id2		,
	--FWD indicator signals to EX
	mem_to_ex1		=> fwd_mem_to_ex1		,
	mem_to_ex2		=> fwd_mem_to_ex2		,
	wb_to_ex1		=> fwd_wb_to_ex1		,
	wb_to_ex2		=> fwd_wb_to_ex2		,
	--FWD Data	
	fwd_mem_data	=> fwd_mem_data		,
	fwd_wb_data		=> fwd_wb_data	
);	


------------ DEBUG
--IF
dbg_pc				<= if_pc;
dbg_inst				<= if_inst;
dbg_ifr_pc			<= ifr_pc(a_width+1 downto 2);
dbg_ifr_inst		<= ifr_inst;
--id	
dbg_alu_ctrl		<= id_alu_ctrl;
dbg_m_ext_en		<= id_m_ext_en;
dbg_imm_to_B		<= id_imm_to_B	;
dbg_pc4_to_reg		<= id_pc4_to_reg	;
dbg_pc_to_a			<= id_pc_to_a		;
dbg_rs1_add			<= id_rs1_add		;
dbg_rs2_add			<= id_rs2_add		;
dbg_rd_add			<= id_rd_add		;
dbg_branch			<= id_branch		;
dbg_jal				<= id_jal			;
dbg_jalr				<= id_jalr			;
dbg_taken			<= id_taken			;
dbg_target			<= id_target		;
dbg_id_pc4			<= ifr_pc4			;
	
--ex	
dbg_ex_pc			<= idr_pc;
dbg_imm				<= idr_imm;
dbg_rs1_data		<= idr_rs1_data;
dbg_rs2_data		<= idr_rs2_data;
dbg_ex_result		<= ex_result;
	
--mem	
dbg_mem_rd_add		<= exr_rd_add;
dbg_st				<= idr_store;
dbg_st_type			<= idr_st_type;
dbg_st_data			<= ex_rs2_data;
dbg_ld				<= idr_load;
dbg_ld_type			<= idr_ld_type;
dbg_ld_data			<= mem_ld_data;
	
--wb	
dbg_wb_pc4			<= memr_pc4;
dbg_wb_add			<= memr_rd_add;
dbg_wb_dout			<= wb_data_out;
dbg_wb_we			<= memr_reg_write;

--fwd and hazard
dbg_stall			<= stall;
dbg_flush			<= flush;
--FWD indicator signals to ID
dbg_mem_to_id1		<= fwd_mem_to_id1		;
dbg_mem_to_id2		<= fwd_mem_to_id2		;
--FWD indicator signals to EX
dbg_mem_to_ex1		<= fwd_mem_to_ex1		;
dbg_mem_to_ex2		<= fwd_mem_to_ex2		;
dbg_wb_to_ex1		<= fwd_wb_to_ex1		;
dbg_wb_to_ex2		<= fwd_wb_to_ex2		;
--FWD Data           
dbg_fwd_mem_data	<= fwd_mem_data	;
dbg_fwd_wb_data	<= fwd_wb_data		;

end struct;