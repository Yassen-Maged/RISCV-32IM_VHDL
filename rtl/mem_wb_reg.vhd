library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_wb_reg is
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
end mem_wb_reg;

architecture beh of mem_wb_reg is

begin

process(clk)
begin
if rising_edge(clk) then
	if (rstn = '0') or (flush = '1') then
		--EX
		wb_alu_result	<= (others => '0');
		wb_pc4_to_reg	<= '0';
		
		--REG file
		wb_rd_add		<= (others => '0');
		wb_reg_write	<= '0';
		
		--MEM
		wb_load			<= '0';
		wb_ld_type		<= (others => '0');
		wb_ld_data		<= (others => '0');
		
		--IF STAGE
		wb_pc4			<= (others => '0');
	
	elsif stall = '0' then
		--EX
		wb_alu_result	<= mem_alu_result	;
		wb_pc4_to_reg	<= mem_pc4_to_reg	;
		                  
		--REG file        --REG file
		wb_rd_add		<= mem_rd_add		;
		wb_reg_write	<= mem_reg_write	;
		                  
		--MEM             --MEM
		wb_load			<= mem_load			;
		wb_ld_type		<= mem_ld_type		;
		wb_ld_data		<= mem_ld_data		;
		                  
		--IF STAGE        --IF STAGE
		wb_pc4			<= mem_pc4			;
		
	end if;
end if;
end process;

end beh;
	
	