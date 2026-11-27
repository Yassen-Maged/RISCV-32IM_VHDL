library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_mem_reg is
generic(XLEN: natural:= 32);
port(
	--input
	clk,rstn: in std_logic;
	flush,stall: in std_logic;
	
	--EX
	ex_alu_result		: in std_logic_vector(xlen -1 downto 0);
	ex_pc4_to_reg		: in std_logic;
	
	--REG file
--	ex_rs2_data			: in std_logic_vector(xlen -1 downto 0);
	ex_rd_add			: in std_logic_vector(4 downto 0);
	ex_reg_write		: in std_logic;
	
	--MEM
--	ex_store				: in std_logic;
--	ex_st_type			: in std_logic_vector(2 downto 0); -- store type
	ex_load				: in std_logic;
	ex_ld_type			: in std_logic_vector(2 downto 0); -- load type
	
	--IF STAGE
	ex_pc4				: in std_logic_vector(xlen -1 downto 0);

	
	--output
	--EX
	mem_alu_result		: out std_logic_vector(xlen -1 downto 0);
	mem_pc4_to_reg		: out std_logic;
	
	--REG file
--	mem_rs2_data		: out std_logic_vector(xlen -1 downto 0);
	mem_rd_add			: out std_logic_vector(4 downto 0);
	mem_reg_write		: out std_logic;
	
	--MEM
--	mem_store			: out std_logic;
--	mem_st_type			: out std_logic_vector(2 downto 0); -- store type
	mem_load				: out std_logic;
	mem_ld_type			: out std_logic_vector(2 downto 0); -- load type
	
	--IF STAGE
	mem_pc4				: out std_logic_vector(xlen -1 downto 0)
	
);
end ex_mem_reg;

architecture beh of ex_mem_reg is
begin

process(clk)
begin
if rising_edge(clk) then
	if (rstn = '0') or (flush = '1') then
		--EX
		mem_alu_result	<= (others => '0');
		mem_pc4_to_reg	<= '0';
		--REG file
--		mem_rs2_data	<= (others => '0');
		mem_rd_add		<= (others => '0');
		mem_reg_write	<= '0';
		--MEM
--		mem_store		<= '0';
--		mem_st_type		<= (others => '0');
		mem_load			<= '0';
		mem_ld_type		<= (others => '0');
		--IF STAGE
		mem_pc4			<= (others => '0');
		
	elsif stall = '0' then
		--EX
		mem_alu_result	<= ex_alu_result	;
		mem_pc4_to_reg	<= ex_pc4_to_reg	;
		--REG file
--		mem_rs2_data	<= ex_rs2_data		;
		mem_rd_add		<= ex_rd_add		;
		mem_reg_write	<= ex_reg_write	;
		--MEM
--		mem_store		<= ex_store			;
--		mem_st_type		<= ex_st_type		;
		mem_load			<= ex_load			;
		mem_ld_type		<= ex_ld_type		;
		--IF STAGE
		mem_pc4			<= ex_pc4			;
	end if;
end if;
end process;
end beh;