library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fwd_hazard_unit_v1 is
generic(xlen: natural:= 32);
port(
-------------------- hazard-only ports --------------------
	flush				: out std_logic_vector(4 downto 0);
	stall				: out std_logic_vector(4 downto 0);
-- 0:IF stage, 1:IF_ID_REG, 2:ID_EX_REG, 3:EX_MEM_REG, 4:MEM_WB_REG
-------------------- hazard & FWD ports --------------------
	--ID & EX inputs
	id_branch		: in std_logic;
	id_jalr			: in std_logic;
	id_rs1_add		: in std_logic_vector(4 downto 0);
	id_rs2_add		: in std_logic_vector(4 downto 0);
	ex_rs1_add		: in std_logic_vector(4 downto 0);
	ex_rs2_add		: in std_logic_vector(4 downto 0);
	--ID/EX register output
	ex_rd_add		: in std_logic_vector(4 downto 0);
	ex_reg_write	: in std_logic;
	--EX/MEM register output
	mem_rd_add		: in std_logic_vector(4 downto 0);
	mem_reg_write	: in std_logic;
	mem_rd_data		: in std_logic_vector(xlen -1 downto 0); --alu_result
	mem_load			: in std_logic; --decides whether to get data from ex_mem_reg or ram.dout
	--MEM/WB register output
	wb_rd_add		: in std_logic_vector(4 downto 0);
	wb_reg_write	: in std_logic;
	wb_rd_data		: in std_logic_vector(xlen -1 downto 0); --wb.data_out
	--FWD indicator signals to ID
	mem_to_id1		: out std_logic;
	mem_to_id2		: out std_logic;
	--FWD indicator signals to EX
	mem_to_ex1		: out std_logic;
	mem_to_ex2		: out std_logic;
	wb_to_ex1		: out std_logic;
	wb_to_ex2		: out std_logic;
	--FWD Data
	fwd_mem_data	: out std_logic_vector(xlen -1 downto 0); --data from ex_mem_reg output
	fwd_wb_data		: out std_logic_vector(xlen -1 downto 0) --data from mem_wb_reg output
	
);
end fwd_hazard_unit_v1;

architecture beh of fwd_hazard_unit_v1 is
signal j: std_logic;
begin

j<= id_branch or id_jalr;
----------------------Hazard----------------------
hazard:process(all)
begin
flush <= (others => '0');
stall <= (others => '0');
--ID
if ( (id_rs1_add = ex_rd_add) or (id_rs2_add = ex_rd_add) ) and (ex_reg_write = '1')
  and (ex_rd_add /= "00000") and (j = '1') then
	stall(0) <= '1'; --stall IF stage: STOP it FROM READING MORE INSTRUCTIONS
	stall(1) <= '1'; --stall if_id_reg
	flush(2) <= '1'; --flush id_ex_reg: pass NOP instruction
elsif ( (id_rs1_add = mem_rd_add) or (id_rs2_add = mem_rd_add) ) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") and (j = '1') and (mem_load = '1') then
	stall(0) <= '1'; --stall IF stage: STOP it FROM READING MORE INSTRUCTIONS
	stall(1) <= '1'; --stall if_id_reg
	flush(2) <= '1'; --flush id_ex_reg: pass NOP instruction
end if;

--EX
if ((ex_rs1_add = mem_rd_add) or (ex_rs2_add = mem_rd_add)) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") and (mem_load = '1') then
	stall(0) <= '1'; --stall IF stage: STOP it FROM READING MORE INSTRUCTIONS
	stall(1) <= '1'; --stall if_id_reg
	stall(2) <= '1'; --stall id_ex_reg
	flush(3) <= '1'; --flush ex_mem_reg: pass NOP instruction
end if;
end process hazard;

----------------------FORWARD----------------------
fwd_mem_data <= mem_rd_data;
fwd_wb_data <= wb_rd_data;

FWD:process(all)
begin
mem_to_id1	<= '0';
mem_to_id2	<= '0';
mem_to_ex1	<= '0';
mem_to_ex2	<= '0';
wb_to_ex1	<= '0';
wb_to_ex2	<= '0';

--ID
if (id_rs1_add = mem_rd_add) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") then
	mem_to_id1 <= '1';
end if;

if (id_rs2_add = mem_rd_add) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") then
	mem_to_id2 <= '1';
end if;

--EX
if (ex_rs1_add = mem_rd_add) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") then
	mem_to_ex1 <= '1';
elsif (ex_rs1_add = wb_rd_add) and (wb_reg_write = '1')
  and (wb_rd_add /= "00000") then
	wb_to_ex1 <= '1';
end if;

if (ex_rs2_add = mem_rd_add) and (mem_reg_write = '1')
  and (mem_rd_add /= "00000") then
	mem_to_ex2 <= '1';
elsif (ex_rs2_add = wb_rd_add) and (wb_reg_write = '1')
  and (wb_rd_add /= "00000") then
	wb_to_ex2 <= '1';
end if;

end process FWD;

end beh;