library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
entity reg_file is
generic(XLEN: natural:= 32); -- 32-bit register
port(
clk,rstn: std_logic:= '0';
--Read
rs1_add, rs2_add: in std_logic_Vector(4 downto 0);
rs1_data, rs2_data: out std_logic_vector(xlen -1 downto 0);
--Write
we : in std_logic;
rd_add: in std_logic_Vector(4 downto 0);
rd_data: in std_logic_vector(xlen -1 downto 0)
);
end reg_file;

architecture beh of reg_file is
type register_file is array (0 to 31) of std_logic_vector(xlen -1 downto 0);
signal regs: register_file;
begin

--rd
writing: process(clk)
begin
if rising_edge(clk) then
	if rstn = '0' then
		regs <= (others => (others => '0'));
	else
		if we = '1' then
			if unsigned(rd_add) = 0 then
				regs(0) <= (others => '0');
			else
				regs(to_integer(unsigned(rd_add))) <= rd_data;
			end if;
		end if;
	end if;
end if;
end process writing;

--rs1
reading1: process(all)
begin
	if unsigned(rs1_add) = 0 then
		rs1_data <=(others => '0');
	elsif (rs1_add = rd_add) and (we = '1') then
		rs1_data <= rd_data;
	else
		rs1_data <= regs(to_integer(unsigned(rs1_add)));
	end if;
end process reading1;

--rs2
reading2: process(all)
begin
	if unsigned(rs2_add) = 0 then
		rs2_data <=(others => '0');
	elsif (rs2_add = rd_add) and (we = '1') then
		rs2_data <= rd_data;
	else
		rs2_data <= regs(to_integer(unsigned(rs2_add)));
	end if;
end process reading2;

end beh;