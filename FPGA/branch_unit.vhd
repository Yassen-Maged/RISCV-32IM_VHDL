library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_unit is
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
end branch_unit;

architecture beh of branch_unit is
begin

--target <= std_logic_vector(signed(PC) + signed(IMM));

process(all)
begin
taken <= '0';
br_except <= '0';
target <= (others => '0');
if branch = '1' then
	target <= std_logic_vector(signed(PC) + signed(IMM));
	case br_type is
	when "000" => -- BEQ: Branch if EQual
		if rs1_data = rs2_data then
			taken <= '1';
		end if;
		
	when "001" => -- BNE: Branch if Not Equal
		if rs1_data /= rs2_data then
			taken <= '1';
		end if;

	when "100" => -- BLT: Branch if Less Than
		if signed(rs1_data) < signed(rs2_data) then
			taken <= '1';
		end if;

	when "101" => -- BGE: Branch if Greater than or Equal
		if signed(rs1_data) >= signed(rs2_data) then
			taken <= '1';
		end if;
		
	when "110" => -- BLTU: Branch if Less Than (Unsigned)
		if unsigned(rs1_data) < unsigned(rs2_data) then
			taken <= '1';
		end if;

	when "111" => -- BGEU: Branch if Greater than or Equal (Unsigned)
		if unsigned(rs1_data) >= unsigned(rs2_data) then
			taken <= '1';
		end if;
		
	when others =>
		br_except <= '1';
	end case;

elsif jal = '1' then
	target <= std_logic_vector(signed(PC) + signed(IMM));
	taken <= '1';

elsif jalr = '1' then
	if br_type = "000" then
		taken <= '1';
		target <= std_logic_vector(signed(rs1_data) + signed(IMM));
	else
		br_except <= '1';
	end if;
	
end if;
end process;

end beh;