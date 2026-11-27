library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_stage is
generic(XLEN: natural:= 32);
port(
	--ALU
	imm				: in std_logic_Vector(xlen -1 downto 0);
	ctrl				: in std_logic_vector(3 downto 0);
	M_ext_en			: in std_logic;
	imm_to_B			: in std_logic;
	pc_to_a			: in std_logic;
	pc4_to_reg		: in std_logic;
	
	--REG file
	rs1_data			: in std_logic_Vector(xlen -1 downto 0);
	rs2_data			: in std_logic_Vector(xlen -1 downto 0);
	
	--IF STAGE
	pc					: in std_logic_Vector(xlen -1 downto 0);
	pc4				: in std_logic_Vector(xlen -1 downto 0);

	ex_rs2_data		: out std_logic_vector(xlen -1 downto 0);
	result			: out std_logic_vector(xlen -1 downto 0);
	
	--FWD AND HAZARD
	mem_to_ex1		: in std_logic;
	mem_to_ex2		: in std_logic;
	wb_to_ex1		: in std_logic;
	wb_to_ex2		: in std_logic;
	fwd_mem_data	: in std_logic_vector(xlen -1 downto 0);
	fwd_wb_data		: in std_logic_vector(xlen -1 downto 0);
	
	alu_except		: out std_logic
);
end ex_stage;

architecture beh of ex_stage is
component alu is
generic(XLEN: natural:= 32);
port(
A,B: in std_logic_Vector(xlen -1 downto 0);
M_ext_en: in std_logic;
ctrl: in std_logic_vector(3 downto 0);
result: out std_logic_vector(xlen -1 downto 0);
alu_except		: out std_logic
);
end component;
signal alu_a, alu_b, rs1, rs2: std_logic_vector(xlen -1 downto 0);
signal alu_res: std_logic_vector(xlen -1 downto 0);
begin

rs1 <= fwd_mem_data when mem_to_ex1 = '1' else
		 fwd_wb_data when wb_to_ex1 = '1' else
		 rs1_data;
rs2 <= fwd_mem_data when mem_to_ex2 = '1' else
		 fwd_wb_data when wb_to_ex2 = '1' else
		 rs2_data;
ex_rs2_data <=rs2;

alu_a <= pc when pc_to_a = '1' else
			rs1;
alu_b <= imm when imm_to_b = '1' else
			rs2;

result <= pc4 when pc4_to_reg = '1' else
			 alu_res;

alu_inst: alu generic map(xlen => xlen)
port map(
	A				=>	alu_a			,
	B				=>	alu_b			,
	M_ext_en		=>	M_ext_en		,
	ctrl			=>	ctrl			,
	result		=>	alu_res		,
	alu_except 	=> alu_except
);


end beh;