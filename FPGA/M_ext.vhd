library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity M_ext is
generic(XLEN: natural:= 32);
port(
A,B: in std_logic_Vector(xlen -1 downto 0);
ctrl: in std_logic_vector(1 downto 0);
Mult_Res: out std_logic_vector(xlen -1 downto 0)
);
end M_ext;

architecture beh of M_ext is
signal a_sign,b_sign: std_logic:= '0';
signal res: std_logic_vector(2*xlen +1 downto 0);
begin

res <= std_logic_vector(signed(a_sign & A) * signed(b_sign & B));

a_sign <= '0' when ctrl = "11" else
			 A(xlen -1);
			 
b_sign <= '0' when (ctrl = "10") or (ctrl = "11") else
			 B(xlen -1);

mult_res <= res(xlen -1 downto 0) when ctrl = "00" else
				res(2*xlen -1 downto xlen);


--case ctrl is
--when "00" => -- MUL:	 	lower 32 bits 	s*s
	
--when "01" => -- MULH:	 	higher 32 bits s*s

--when "10" => -- MULHSU: 	higher 32 bits s*u

--when "11" => -- MULHU:	higher 32 bits u*u

end beh;