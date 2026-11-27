library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
generic(XLEN: natural:= 32);
port(
inst: in std_logic_Vector(31 downto 0);
imm: out std_logic_vector(xlen -1 downto 0):= (others => '0');
-- ALU
alu_ctrl: out std_logic_vector(3 downto 0):= (others => '0');
m_ext_en: out std_logic;

-- REG file
--rs1_en, rs2_en, rd_en: out std_logic;
rs1_add, rs2_add, rd_add: out std_logic_vector(4 downto 0):= (others => '0');
reg_write: out std_logic;

-- CTRL Signals
store, load, imm_to_B, pc_to_a, pc4_to_reg,
 jal, jalr, branch: out std_logic:= '0';
ld_type, st_type, br_type: out std_logic_vector(2 downto 0):= (others => '0'); --load, store, and branch type.

opcode_except: out std_logic;
ctrl_except: out std_logic
);
end control_unit;

architecture beh of control_unit is
component imm_generator is
generic(XLEN: natural:= 32);
port(
	inst: in std_logic_Vector(31 downto 0);
	R,I,S,B,U,J: out std_logic; --type define
	imm: out std_logic_vector(xlen -1 downto 0);
	opcode_except: out std_logic
);
end component;
signal RISBUJ: std_logic_vector(5 downto 0):= (others => '0'); --type define
signal opcode: std_logic_vector(4 downto 0):= (others => '0');
signal funct3: std_logic_vector(2 downto 0):= (others => '0');
signal funct7: std_logic_vector(6 downto 0):= (others => '0');

begin

opcode <= inst(6 downto 2);
funct3 <= inst(14 downto 12);
funct7 <= inst(31 downto 25);


process(all)
begin
--rs1_en	<= '0';
--rs2_en	<= '0';
--rd_en		<= '0';
rd_add  <= inst(11 downto 7);
rs1_add <= inst(19 downto 15);
rs2_add <= inst(24 downto 20);

branch 		<= '0';
pc4_to_reg 	<= '0';
jal			<= '0';
jalr 			<= '0';
pc_to_a 		<= '0';
m_ext_en 	<= '0';
store		 	<= '0';
load 			<= '0';
imm_to_B 	<= '0';
reg_write 	<= '0';
alu_ctrl 	<= (others => '0');
st_type 		<= (others => '0');
ld_type 		<= (others => '0');
br_type 		<= (others => '0');
ctrl_except <= '0';

case RISBUJ is
when "100000" => -- R-type
--	rs1_en	<= '1';
--	rs2_en	<= '1';
--	rd_en		<= '1';
	reg_write <= '1';
	alu_ctrl <= funct7(5) & funct3;
	if funct7(0) = '1' then --multiply
		m_ext_en <= '1';
	end if;
	
when "010000" => -- I-type
--	rs1_en	<= '1';
--	rd_en		<= '1';
	rs2_add 	<= (others => '0');
	I:case opcode is
	when "11001" => -- JALR
		pc4_to_reg <= '1';
		JALR <= '1';
		imm_to_B <= '1';
		reg_write <= '1';
		
	when "00000" => -- LOAD
		load <= '1';
		imm_to_B <= '1';
		reg_write <= '1';
		ld_type <= funct3;
		
	when "00100" => -- OP-IMM
		imm_to_B <= '1';
		reg_write <= '1';
		alu_ctrl(2 downto 0) <= funct3;
		if funct3 = "101" then --SRAi
			alu_ctrl(3) <= funct7(5);
		end if;
	
	--when "11100" => -- SYSTEM
	when others =>
--		rs1_en <= '0';
--		rd_en	<= '0';
		rs1_add <= (others => '0');
		rd_add  <= (others => '0');
		ctrl_except <= '1';
	end case I;
	
when "001000" => -- S-type
	rd_add <= (others => '0');
	if opcode = "01000" then -- STORE
		store <= '1';
		imm_to_B <= '1';
		st_type <= funct3;
--		rs1_en <= '1';
--		rs2_en <= '1';
	else
		rs1_add <= (others => '0');
		rs2_add <= (others => '0');
		ctrl_except <= '1';
	end if;
	
when "000100" => -- B-type
--	rs1_en	<= '1';
--	rs2_en 	<= '1';
	branch <= '1';
	br_type <= funct3;
	imm_to_b <= '1';
	rd_add <= (others => '0');
	
when "000010" => -- U-type
--	rd_en	<= '1';
	rs1_add <= (others => '0');
	rs2_add <= (others => '0');
	if opcode = "00101" then -- AUIPC
		imm_to_b <= '1';
		pc_to_a <= '1';
		reg_write <= '1';
	elsif opcode = "01101" then -- LUI
		imm_to_b <= '1';
		reg_write <= '1';
	else
--		rd_en	<= '0';
		rd_add <= (others => '0');
		ctrl_except <= '1';
	end if;

when "000001" => -- J-type
	rs1_add <= (others => '0');
	rs2_add <= (others => '0');
	if opcode = "11011" then -- JAL
--		rd_en	<= '1';
		reg_write <= '1';
		JAL <= '1';
		pc_to_a <= '1';
		pc4_to_reg <= '1';
	else
		rd_add  <= (others => '0');
		ctrl_except <= '1';
	end if;
	
when others =>
	rd_add  <= (others => '0');
	rs1_add <= (others => '0');
	rs2_add <= (others => '0');
	ctrl_except <= '1';
end case;
end process;

imm_gen: imm_generator generic map (xlen => xlen)
port map(
	inst 				=> inst,
	R 					=> RISBUJ(5),
	I 					=> RISBUJ(4),
	S 					=> RISBUJ(3),
	B 					=> RISBUJ(2),
	U 					=> RISBUJ(1),
	J 					=> RISBUJ(0),
	imm 				=> imm,
	opcode_except 	=> opcode_except
);
end beh;