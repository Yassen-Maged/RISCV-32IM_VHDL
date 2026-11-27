library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_stage is
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
end if_stage;

architecture beh of if_stage is
constant a_max: unsigned(a_width -1 downto 0):= (others => '1');
component instruction_rom
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
constant NOP_inst: std_logic_vector(31 downto 0):= x"00000013"; --ADDI x0, x0, 0
signal address,nxt_address: std_logic_vector(xlen -1 downto 0):= (others => '0');
signal inst_i: std_logic_vector(xlen -1 downto 0):= NOP_inst;
signal clken: std_logic:= '0';
begin

clken <= '1';
inst <= NOP_inst when (rstn = '0') or (flush = '1') or (taken  and (branch or jal or jalr)) = '1' else
			inst_i;
nxt_address <= (others => '0') when (rstn = '0') or (flush = '1') else
					address when stall = '1' else
					target when (taken  and (branch or jal or jalr)) else
					std_logic_vector(unsigned(address) +4) when stall = '0';
pc_out <= address;
pc4_out <= std_logic_vector(unsigned(address) +4);
process(clk)
begin
if rising_edge(clk) then
	IF_except <= '0';
	if (rstn = '0') or (flush = '1') then
		address <= (others => '0');
--		inst <= NOP_inst;
--		inst <= inst_i;
	elsif stall = '0' then
--		inst <= inst_i;
		--if (taken = '1') then
		if taken  and (branch or jal or jalr) then
			if unsigned(target(xlen -1 downto 2)) > a_max then
				IF_except <= '1';
				if unsigned(address(xlen -1 downto 2)) >= a_max then
					address <= (others => '0');
				else
					address <= std_logic_vector(unsigned(address) +4);
				end if; --unsigned(target(xlen -1 downto 2)) > a_max
			else
				address <= target;
--				inst <= NOP_inst;
			end if; --unsigned(target(xlen -1 downto 2)) > a_max
		elsif unsigned(address(xlen -1 downto 2)) >= a_max then
			IF_except <= '1';
			address <= (others => '0');
		else
			address <= std_logic_vector(unsigned(address) +4);
		end if; --taken = '1' - unsigned(address(xlen -1 downto 2)) >= a_max
	end if; --rstn = '0' - stall = '0'
end if;
end process;

rom : instruction_rom PORT MAP (
		address	 => nxt_address(a_width +1 downto 2),
		clken	 => clken,
		clock	 => clk,
		q	 => inst_i
	);

end beh;