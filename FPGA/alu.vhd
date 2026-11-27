library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
generic(XLEN: natural:= 32);
port(
A,B: in std_logic_Vector(xlen -1 downto 0);
M_ext_en: in std_logic;
ctrl: in std_logic_vector(3 downto 0);
Result: out std_logic_vector(xlen -1 downto 0);

alu_except: out std_logic
);
end alu;

architecture beh of alu is
	component m_ext is
	generic(XLEN: natural:= 32);
	port(
		A,B: in std_logic_Vector(xlen -1 downto 0);
		ctrl: in std_logic_vector(1 downto 0);
		Mult_Res: out std_logic_vector(xlen -1 downto 0)
	);
	end component;
	signal Mult_Res: std_logic_vector(xlen -1 downto 0):= (others => '0');
	
	function add(A,B: std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector(unsigned(A) + unsigned(B));
	end add;
	
	--subtract
	function sub(A,B: std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector(unsigned(A) - unsigned(B));
	end sub;
	
	--shift right arithmetic	
	function SRAn(A,n: std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector( shift_right(signed(A), to_integer(unsigned(n(4 downto 0)))) );
	end SRAn;
	
	--shift right logical
	function SRLn(A,n: std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector( shift_right(unsigned(A), to_integer(unsigned(n(4 downto 0)))) );
	end SRLn;
	
	--shift left logical
	function SLLn(A,n: std_logic_vector) return std_logic_vector is
	begin
		return std_logic_vector( shift_left(unsigned(A), to_integer(unsigned(n(4 downto 0)))) );
	end SLLn;
	
	--set less than (signed)
	function SLT(A,B: std_logic_vector) return std_logic_vector is
	begin
		if signed(A) < signed(B) then
			return std_logic_vector(to_unsigned(1,xlen));
		else
			return std_logic_vector(to_unsigned(0,xlen));
		end if;
	end SLT;
	
	--set less than (unsigned)
	function SLTU(A,B: std_logic_vector) return std_logic_vector is
	begin
		if unsigned(A) < unsigned(B) then
			return std_logic_vector(to_unsigned(1,xlen));
		else
			return std_logic_vector(to_unsigned(0,xlen));
		end if;
	end SLTU;
---------------------
begin

process(all)
begin
alu_except <= '0';
if m_ext_en = '1' then
	result <= Mult_Res;
else
	case ctrl is
	when "0000" => --add
		Result <= add(A,B);
		
	when "0001" => --shift left logic
		Result <= slln(A,B);
		
	when "0010" => --set less than
		Result <= slt(A,B);
		
	when "0011" => --set less than unsigned
		Result <= sltu(A,B);
		
	when "0100" => --XOR
		Result <= A xor B;
		
	when "0101" => --shift right logic
		Result <= srln(A,B);

	when "0110" => --OR
		Result <= A OR B;
		
	when "0111" => --AND
		Result <= A AND B;

	when "1000" => --sub
		Result <= sub(A,B);
		
	when "1101" => --shift right Arithmetic
		Result <= sran(A,B);

	when others =>
		Result <= (others => '0');
		alu_except <= '1';
	end case;
end if;
end process;

Mult_ext: m_ext generic map(xlen => xlen)
port map(
	A => A,
	B => B,
	ctrl => ctrl(1 downto 0),
	Mult_Res => Mult_Res
);
end beh;