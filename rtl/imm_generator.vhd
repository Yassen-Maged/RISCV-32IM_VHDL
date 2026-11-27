library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_generator is
generic(XLEN: natural:= 32);
port(
inst: in std_logic_Vector(31 downto 0);
R,I,S,B,U,J: out std_logic; --type define
imm: out std_logic_vector(xlen -1 downto 0);

opcode_except: out std_logic
);
end imm_generator;

architecture beh of imm_generator is
signal opcode: std_logic_vector(4 downto 0);
begin

opcode <= inst(6 downto 2);

process(all)
begin
R <= '0';
I <= '0';
S <= '0';
B <= '0';
U <= '0';
J <= '0';
opcode_except <= '0';

case opcode is
when "01100" => -- R-type
	R <= '1';
	imm <= (others => '0');
	
when "11001" | "00000" | "00100" | "11100" => -- I-type
	imm(11 downto 0) <= inst(31 downto 20);
	imm(xlen-1 downto 12) <= (others => inst(31));
	I <= '1';
	
when "01000" => -- S-type
	imm(4 downto 0) <= inst(11 downto 7);
	imm(11 downto 5) <= inst(31 downto 25);
	imm(xlen -1 downto 12) <= (others => inst(31));
	S <= '1';
	
when "01101" | "00101" => -- U-type
	imm(31 downto 12) <= inst(31 downto 12);
	imm(11 downto 0) <= (others => '0');
	U <= '1';
	
when "11000" => -- B-type
	imm(0) <= '0';
	imm(4 downto 1) <= inst(11 downto 8);
	imm(10 downto 5) <= inst(30 downto 25);
	imm(11) <= inst(7);
	imm(12) <= inst(31);
	imm(xlen -1 downto 12) <= (others => inst(31));
	B <= '1';
	
when "11011" => -- J-type
	imm(0) <= '0';
	imm(10 downto 1) <= inst(30 downto 21);
	imm(11) <= inst(20);
	imm(19 downto 12) <= inst(19 downto 12);
	imm(20) <= inst(31);
	imm(xlen -1 downto 21) <= (others => inst(31));
	J <= '1';
	
when others =>
	imm <= (others => '0');
	opcode_except <= '1';
end case;
end process;
end beh;