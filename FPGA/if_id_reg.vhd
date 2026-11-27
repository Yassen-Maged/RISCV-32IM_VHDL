library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id_reg is
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
end if_id_reg;

architecture beh of if_id_reg is
constant NOP_inst: std_logic_vector(31 downto 0):= x"00000013"; --ADDI x0, x0, 0
begin

process(clk)
begin
if rising_edge(clk) then
	if (rstn = '0') or (flush = '1') then
		id_pc <= (others => '0');
		id_pc4 <= (others => '0');
		id_inst <= NOP_inst;
		
	elsif stall = '0' then
		id_pc <= if_pc;
		id_pc4 <= if_pc4;
		id_inst <= if_inst;
	end if;
end if;
end process;

end beh;