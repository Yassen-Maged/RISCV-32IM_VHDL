library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_stage is
generic(xlen: natural:= 32);
port(
	clk,rstn: in std_logic;
	--------------CTRL UNIT PORTS--------------
	inst				: in std_logic_Vector(xlen -1 downto 0);
	imm				: out std_logic_vector(xlen -1 downto 0):= (others => '0');
	-- ALU	
	alu_ctrl			: out std_logic_vector(3 downto 0):= (others => '0');
	m_ext_en			: out std_logic;
	imm_to_B			: out std_logic:= '0';
	pc_to_a			: out std_logic:= '0';
	pc4_to_reg		: out std_logic:= '0';
	
	-- REG file	
--	rs1_en			: out std_logic;
--	rs2_en			: out std_logic;
--	rd_en				: out std_logic;
	rs1_add			: out std_logic_vector(4 downto 0):= (others => '0');
	rs2_add			: out std_logic_vector(4 downto 0):= (others => '0');
	rs1_data			: out std_logic_vector(xlen -1 downto 0);
	rs2_data			: out std_logic_vector(xlen -1 downto 0);
	rd_add			: out std_logic_vector(4 downto 0):= (others => '0');
	reg_write		: out std_logic; 
	
	-- MEM	
	store				: out std_logic:= '0';
	st_type			: out std_logic_vector(2 downto 0); --store type
	load				: out std_logic:= '0';
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
--	wb_to_id1		: in std_logic;
--	wb_to_id2		: in std_logic;
	fwd_mem_data	: in std_logic_vector(xlen -1 downto 0);
--	fwd_wb_data		: in std_logic_vector(xlen -1 downto 0);
	
	br_except		: out std_logic
	
);
end id_stage;


architecture struct of id_stage is
--------------CTRL UNIT SIGNALS--------------
signal imm_i: std_logic_vector(xlen -1 downto 0);
component control_unit is
generic(XLEN: natural:= 32);
port(
inst: in std_logic_Vector(31 downto 0);
imm: out std_logic_vector(xlen -1 downto 0):= (others => '0');
-- ALU
alu_ctrl: out std_logic_vector(3 downto 0):= (others => '0');
m_ext_en: out std_logic;

-- REG file
--rs1_en, rs2_en, rd_en: out std_logic;
rs1_add, rs2_add, rd_add: out std_logic_vector(4 downto 0):= (others => '0');
reg_write: out std_logic;

-- CTRL Signals
store, load, imm_to_B, pc_to_a, pc4_to_reg,
 jal, jalr, branch: out std_logic:= '0';
ld_type, st_type, br_type: out std_logic_vector(2 downto 0):= (others => '0');

opcode_except: out std_logic;
ctrl_except: out std_logic
);
end component;

--------------REG FILE SIGNALS--------------
component reg_file is
generic(XLEN: natural:= 32); -- 32-bit register
port(
clk,rstn: std_logic:= '0';
--Read
rs1_add, rs2_add: in std_logic_Vector(4 downto 0);
rs1_data, rs2_data: out std_logic_vector(xlen -1 downto 0);
--Write
we: in std_logic;
rd_add: in std_logic_Vector(4 downto 0);
rd_data: in std_logic_vector(xlen -1 downto 0)
);
end component;
signal rs1_add_i, rs2_add_i: std_logic_vector(4 downto 0);
signal rs1_data_i, rs2_data_i: std_logic_vector(xlen -1 downto 0);

--------------BRANCH UNIT SIGNALS--------------
component branch_unit is
generic(xlen: natural := 32);
port(
JAL			: in std_logic;
JALR			: in std_logic;
branch		: in std_logic;
br_type		: in std_logic_vector(2 downto 0);
	
IMM			: in std_logic_vector(xlen -1 downto 0);
rs1_data		: in std_logic_vector(xlen -1 downto 0);
rs2_data		: in std_logic_vector(xlen -1 downto 0);
PC				: in std_logic_vector(xlen -1 downto 0);
	
taken			: out std_logic;
target		: out std_logic_vector(xlen -1 downto 0);
	
br_except	: out std_logic
);
end component;
signal jal_i,jalr_i,branch_i: std_logic;
signal br_type_i: std_logic_vector(2 downto 0);
signal br_rs1_data,br_rs2_data: std_logic_vector(xlen -1 downto 0);
begin

--------------CTRL UNIT ASSIGNMENTS--------------
imm <= imm_i;
ctrl: control_unit
generic map(xlen => xlen)
port map(
	inst				=> inst,
	imm				=> imm_i,
	-- ALU	
	alu_ctrl			=> alu_ctrl,
	m_ext_en			=> m_ext_en,
	imm_to_B			=> imm_to_B,
	pc_to_a			=> pc_to_a,
	pc4_to_reg		=> pc4_to_reg,
	-- REG file	
	rs1_add			=> rs1_add_i,
	rs2_add			=> rs2_add_i,
	rd_add			=> rd_add,
	reg_write		=> reg_write,
	-- MEM
	store				=> store,
	st_type			=> st_type,
	load				=> load,
	ld_type			=> ld_type,
	--JUMP AND BRANCH
	jal				=> jal_i,
	jalr				=> jalr_i,
	branch			=> branch_i,
	br_type			=> br_type_i,
	
	opcode_except	=> opcode_except,
	ctrl_except		=> ctrl_except
);
--------------REG FILE ASSIGNMENTS--------------
rs1_add	<= rs1_add_i;
rs2_add	<= rs2_add_i;
rs1_data <= rs1_data_i;
rs2_data <= rs2_data_i;

reg32: reg_file
generic map(xlen => xlen)
port map(
	clk		=> clk,
	rstn		=> rstn,
	rs1_add	=> rs1_add_i,
	rs2_add	=> rs2_add_i,
	rs1_data	=> rs1_data_i,
	rs2_data	=> rs2_data_i,
	we			=> wb_we,
	rd_add	=> wb_rd_add,
	rd_data	=> wb_rd_data
);

--------------BRANCH UNIT ASSIGNMENTS--------------
jal <= jal_i;
jalr <= jalr_i;
branch <= branch_i;

br_rs1_data <= fwd_mem_data when mem_to_id1 = '1' else
--					fwd_wb_data when wb_to_id1 = '1' else
					rs1_data_i;
					
br_rs2_data <= fwd_mem_data when mem_to_id2 = '1' else
--					fwd_wb_data when wb_to_id2 = '1' else
					rs2_data_i;

br: branch_unit
generic map(xlen => xlen)
port map(
	JAL			=> jal_i,
	JALR			=> jalr_i,
	branch		=> branch_i,
	br_type		=> br_type_i,
	IMM			=> imm_i,
	rs1_data		=> br_rs1_data,
	rs2_data		=> br_rs2_data,
	PC				=> PC,
	taken			=> taken,
	target		=> target,
	br_except	=> br_except
); 	

end struct;