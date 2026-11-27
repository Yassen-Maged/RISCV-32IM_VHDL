library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_stage is
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
end mem_stage;

architecture beh of mem_stage is
component data_ram
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		byteena	: IN STD_LOGIC_VECTOR (3 DOWNTO 0) :=  (OTHERS => '1');
		clock		: IN STD_LOGIC  := '1';
		clken		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
signal address: std_logic_vector(a_width -1 downto 0);
signal clken,rden,wren,misaligned: std_logic;
signal byteen: std_logic_vector(7 downto 0);
signal offset: std_logic_vector(1 downto 0);
signal data	: std_logic_vector(xlen -1 downto 0); -- write data
begin

clken <= '1' when rstn = '1' else --and flush = '0' else
			'0';
rden <= load and (not misaligned); --reads only when load = 1 and no misalignment
wren <= '1' when store = '1' and misaligned = '0' and flush = '0' else
		  '0'; --write only when store = 1 and no misalignment
address <= alu_result(a_width +1 downto 2);
offset <= alu_result(1 downto 0);
mem_except <= misaligned;

process(all)
begin
byteen <= (others => '0');
data <= rs2_data;
misaligned <= '0';

if store = '1' then
	storing: case st_type is
	when "000" =>	--SB (store the first byte)
		case offset is
		when "00" => --store at byte0
			byteen(0) <= '1';
			data(7 downto 0) <= rs2_data(7 downto 0);
		when "01" => --store at byte1
			byteen(1) <= '1';
			data(15 downto 8) <= rs2_data(7 downto 0);
		when "10" => --store at byte2
			byteen(2) <= '1';
			data(23 downto 16) <= rs2_data(7 downto 0);
		when "11" => --store at byte3
			byteen(3) <= '1';
			data(31 downto 24) <= rs2_data(7 downto 0);
		when others =>
			misaligned <= '1';
		end case;
		
	when "001" =>	--SH (store the first half-word (16 bits))
		case offset is
		when "00" => --store at half0
			byteen(1 downto 0) <= (others => '1');
			data(15 downto 0) <= rs2_data(15 downto 0);
		when "10" => --store at half1
			byteen(3 downto 2) <= (others => '1');
			data(31 downto 16) <= rs2_data(15 downto 0);
		when others =>
			misaligned <= '1';
		end case;
		
	when "010" =>	--SW (store the first word (32 bits))
		if offset = "00" then
			byteen(3 downto 0) <= (others => '1');
		else
			misaligned <= '1';
		end if;
	--when "011" =>	--SD (store double-word (64 bits))
	--	byteen <= (others => '1');

	when others =>
		misaligned <= '1';
	end case storing;
end if;

if load = '1' then
	loading: case ld_type is
	when "000" | "100" => --LB or LBU
		if (offset = "00") or (offset = "01") or (offset = "10") or (offset = "11") then
		else
			misaligned <= '1';
		end if;
		
	when "001" | "101" => --LH or LHU
		if (offset = "00") or (offset = "10") then
		else
			misaligned <= '1';
		end if;
		
	when "010" => --LW
		if offset /= "00" then
			misaligned <= '1';
		end if;
		
	when others =>
		misaligned <= '1';
	end case loading;
end if;
end process;


mem: data_ram PORT MAP (
	address	 => address, 
	byteena	 => byteen(byteen_width -1 downto 0), 
	clock	 => clk,
	clken  => clken,
	data	 => data, 
	rden	 => rden, 
	wren	 => wren, 
	q	 => ld_data 
);
end beh;
