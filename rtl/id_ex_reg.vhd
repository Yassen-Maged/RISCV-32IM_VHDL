library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_ex_reg is
generic(XLEN: natural:= 32);
port(
	--inputs
	clk,rstn: in std_logic;
	flush,stall: in std_logic;
	
	id_imm			: in std_logic_vector(xlen -1 downto 0):= (others => '0');
	
	--ALU
	id_alu_ctrl		: in std_logic_vector(3 downto 0):= (others => '0');
	id_m_ext_en		: in std_logic;
	id_imm_to_B		: in std_logic:= '0';
	id_pc_to_a		: in std_logic:= '0';
	id_pc4_to_reg	: in std_logic:= '0';

	--REG file
--	id_rs1_en		: in std_logic;
--	id_rs2_en		: in std_logic;
--	id_rd_en			: in std_logic;
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
	
	--JUMP AND BRANCH
--	id_jal			: out std_logic:= '0';
--	id_jalr			: out std_logic:= '0';
	
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
--	ex_rs1_en		: out std_logic;
--	ex_rs2_en		: out std_logic;
--	ex_rd_en			: out std_logic;
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
	
	--JUMP AND BRANCH
--	ex_jal			: out std_logic:= '0';
--	ex_jalr			: out std_logic:= '0';
	
	--IF STAGE
	ex_pc				: out std_logic_vector(xlen -1 downto 0);	
	ex_pc4			: out std_logic_vector(xlen -1 downto 0)
);
end id_ex_reg;

architecture beh of id_ex_reg is

begin

process(clk)
begin
if rising_edge(clk) then
	if (rstn = '0') or (flush = '1') then
		ex_imm			<= (others => '0');
		
		--ALU
		ex_alu_ctrl		<= (others => '0');	
		ex_m_ext_en		<= '0';
		ex_imm_to_B		<= '0';
		ex_pc_to_a		<= '0';
		ex_pc4_to_reg	<= '0';
		
		-- REG file
--		ex_rs1_en		<= '0';
--		ex_rs2_en		<= '0';
--		ex_rd_en			<= '0';
		ex_rs1_add		<= (others => '0');
		ex_rs2_add		<= (others => '0');
		ex_rs1_data		<= (others => '0');
		ex_rs2_data		<= (others => '0');
		ex_rd_add		<= (others => '0');
		ex_reg_write	<= '0';
		
		--MEM
		ex_store			<= '0';
		ex_st_type		<= (others => '0');
		ex_load			<= '0';
		ex_ld_type		<= (others => '0');
		
		--JUMP AND BRANCH
--		ex_jal			<= '0';
--		ex_jalr			<= '0';
	
		--IF STAGE
		ex_pc				<= (others => '0');
		ex_pc4			<= (others => '0');	
		
	elsif stall = '0' then
		ex_imm			<= id_imm			;
		
		--ALU
		ex_alu_ctrl		<= id_alu_ctrl		;	
		ex_m_ext_en		<= id_m_ext_en		;
		ex_imm_to_B		<= id_imm_to_B		;
		ex_pc_to_a		<= id_pc_to_a		;
		ex_pc4_to_reg	<= id_pc4_to_reg	;
		
		-- REG file
--		ex_rs1_en		<= id_rs1_en		;
--		ex_rs2_en		<= id_rs2_en		;
--		ex_rd_en			<= id_rd_en			;
		ex_rs1_add		<= id_rs1_add		;
		ex_rs2_add		<= id_rs2_add		;
		ex_rs1_data		<= id_rs1_data		;
		ex_rs2_data		<= id_rs2_data		;
		ex_rd_add		<= id_rd_add		;
		ex_reg_write	<= id_reg_write	;
		
		--MEM
		ex_store			<= id_store			;
		ex_st_type		<= id_st_type		;
		ex_load			<= id_load			;
		ex_ld_type		<= id_ld_type		;
		
		--JUMP AND BRANCH
--		ex_jal			<= id_jal			;
--		ex_jalr			<= id_jalr			;
		
		--IF STAGE
		ex_pc				<= id_pc				;
		ex_pc4			<= id_pc4			;
		
	end if;
end if;
end process;
end beh;
