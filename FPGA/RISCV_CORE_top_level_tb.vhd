library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISCV_CORE_top_level_tb is
generic(xlen: natural:= 32;
a_width: natural := 10 -- --max = 30 (1G of memory)
);
end RISCV_CORE_top_level_tb;

architecture beh of RISCV_CORE_top_level_tb is
component RISCV_CORE_top_level is
generic(xlen: natural:= 32;
a_width: natural := 10 -- --max = 30 (1G of memory)
);
port(
	clk,rstn				: in std_logic;
	
	--- DEBUG PORTS
	--if
	dbg_pc				: out std_logic_vector(xlen-1 downto 0);
	dbg_inst				: out std_logic_vector(xlen-1 downto 0);
	dbg_ifr_pc			: out std_logic_vector(a_width-1 downto 0);
	dbg_ifr_inst		: out std_logic_vector(xlen-1 downto 0);
	
	--id	
	dbg_alu_ctrl		: out std_logic_vector(3 downto 0);
	dbg_m_ext_en		: out std_logic;
	dbg_imm_to_B		: out std_logic;
	dbg_pc4_to_reg		: out std_logic;
	dbg_pc_to_a			: out std_logic;
	dbg_rs1_add			: out std_logic_vector(4 downto 0);
	dbg_rs2_add			: out std_logic_vector(4 downto 0);
	dbg_rd_add			: out std_logic_vector(4 downto 0);
	dbg_branch			: out std_Logic;
	dbg_jal				: out std_Logic;
	dbg_jalr				: out std_Logic;
	dbg_taken			: out std_logic;
	dbg_target			: out std_logic_vector(xlen-1 downto 0);
	dbg_id_pc4			: out std_logic_vector(xlen-1 downto 0);
		
	--ex	
	dbg_ex_pc			: out std_logic_vector(xlen-1 downto 0);
	dbg_imm				: out std_logic_vector(xlen-1 downto 0);
	dbg_rs1_data		: out std_logic_vector(xlen-1 downto 0);
	dbg_rs2_data		: out std_logic_vector(xlen-1 downto 0);
	dbg_ex_result		: out std_logic_vector(xlen-1 downto 0);
		
	--mem	
	dbg_mem_rd_add		: out std_logic_vector(4 downto 0);
	dbg_st				: out std_logic;
	dbg_st_type			: out std_logic_vector(2 downto 0);
	dbg_st_data			: out std_logic_vector(xlen-1 downto 0);
	dbg_ld				: out std_logic;
	dbg_ld_type			: out std_logic_vector(2 downto 0);
	dbg_ld_data			: out std_logic_vector(xlen-1 downto 0);
		
	--wb	
	dbg_wb_pc4			: out std_logic_vector(xlen-1 downto 0);
	dbg_wb_add			: out std_logic_vector(4 downto 0);
	dbg_wb_dout			: out std_logic_vector(xlen-1 downto 0);
	dbg_wb_we			: out std_logic;
	
	--fwd and hazard
	dbg_stall			: out std_logic_vector(4 downto 0);
	dbg_flush			: out std_logic_vector(4 downto 0);
	--FWD indicator signals to ID
	dbg_mem_to_id1		: out std_logic;
	dbg_mem_to_id2		: out std_logic;
	--FWD indicator signals to EX
	dbg_mem_to_ex1		: out std_logic;
	dbg_mem_to_ex2		: out std_logic;
	dbg_wb_to_ex1		: out std_logic;
	dbg_wb_to_ex2		: out std_logic;
	--FWD Data
	dbg_fwd_mem_data	: out std_logic_vector(xlen -1 downto 0); --data from ex_mem_reg output
	dbg_fwd_wb_data	: out std_logic_vector(xlen -1 downto 0); --data from mem_wb_reg output
	-----------
	
	IF_except			: out std_logic;
	opcode_except		: out std_logic;
	ctrl_except			: out std_logic;
	br_except			: out std_logic;
	alu_except			: out std_logic;
	mem_except			: out std_logic;
	wb_except			: out std_logic
	-----------------------------------------------------------------------
);
end component;

signal clk					: std_logic:= '0';
signal rstn					: std_logic:= '0';

--- DEBUG PORTS
--if
signal dbg_pc				: std_logic_vector(xlen-1 downto 0);
signal dbg_inst			: std_logic_vector(xlen-1 downto 0);
signal dbg_ifr_pc			: std_logic_vector(a_width-1 downto 0);
signal dbg_ifr_inst		: std_logic_vector(xlen-1 downto 0);
--id
signal dbg_alu_ctrl		: std_logic_vector(3 downto 0);
signal dbg_m_ext_en		: std_logic;
signal dbg_imm_to_B		: std_logic;
signal dbg_pc4_to_reg	: std_logic;
signal dbg_pc_to_a		: std_logic;
signal dbg_rs1_add		: std_logic_vector(4 downto 0);
signal dbg_rs2_add		: std_logic_vector(4 downto 0);
signal dbg_rd_add			: std_logic_vector(4 downto 0);
signal dbg_branch			: std_Logic;
signal dbg_jal				: std_Logic;
signal dbg_jalr			: std_Logic;
signal dbg_taken			: std_logic;
signal dbg_target			: std_logic_vector(xlen-1 downto 0);
signal dbg_id_pc4			: std_logic_vector(xlen-1 downto 0);
--ex
signal dbg_ex_pc			: std_logic_vector(xlen-1 downto 0);
signal dbg_imm				: std_logic_vector(xlen-1 downto 0);
signal dbg_rs1_data		: std_logic_vector(xlen-1 downto 0);
signal dbg_rs2_data		: std_logic_vector(xlen-1 downto 0);
signal dbg_ex_result		: std_logic_vector(xlen-1 downto 0);
--mem	
signal dbg_mem_rd_add	: std_logic_vector(4 downto 0);
signal dbg_st				: std_logic;
signal dbg_st_type		: std_logic_vector(2 downto 0);
signal dbg_st_data		: std_logic_vector(xlen-1 downto 0);
signal dbg_ld				: std_logic;
signal dbg_ld_type		: std_logic_vector(2 downto 0);
signal dbg_ld_data		: std_logic_vector(xlen-1 downto 0);
--wb
signal dbg_wb_pc4			: std_logic_vector(xlen-1 downto 0);
signal dbg_wb_add			: std_logic_vector(4 downto 0);
signal dbg_wb_dout		: std_logic_vector(xlen-1 downto 0);
signal dbg_wb_we			: std_logic;

--fwd and hazard
signal dbg_stall			: std_logic_vector(4 downto 0);
signal dbg_flush			: std_logic_vector(4 downto 0);
--FWD Data
signal dbg_fwd_mem_data	: std_logic_vector(xlen -1 downto 0); --data from ex_mem_reg output
signal dbg_fwd_wb_data	: std_logic_vector(xlen -1 downto 0); --data from mem_wb_reg output
--FWD indicator signals to ID
signal dbg_mem_to_id1	: std_logic;
signal dbg_mem_to_id2	: std_logic;
--FWD indicator signals to EX
signal dbg_mem_to_ex1	: std_logic;
signal dbg_mem_to_ex2	: std_logic;
signal dbg_wb_to_ex1		: std_logic;
signal dbg_wb_to_ex2		: std_logic;
-----------

signal IF_except			: std_logic;
signal opcode_except		: std_logic;
signal ctrl_except		: std_logic;
signal br_except			: std_logic;
signal alu_except			: std_logic;
signal mem_except			: std_logic;
signal wb_except			: std_logic;

type mem is array(0 to 2**a_width -1) of std_logic_vector(xlen-1 downto 0);
signal test_mem: mem:=(others => (others => '0'));
begin

rstn <= '0', '1' after 20 ps;
process
begin
wait for 5 ps;
clk <= not clk;
--wait for 5 ps;
end process;

process(clk)
begin
if rising_edge(clk) then
	if dbg_st = '1' then
		test_mem(to_integer(unsigned(dbg_ex_result(a_width +1 downto 2)))) <= dbg_st_data;
		report "a new data is stored in memory" & LF &
           "address: 0x" & to_hstring(dbg_ex_result) & LF &
           "data is: 0x" & to_hstring(dbg_st_data) severity note;
	end if;
	if dbg_ifr_inst = x"0000006F" then -- done : j done
		assert false;
		report "SIMULATION IS DONE!!" severity failure;
	end if;
end if;
end process;
dut: RISCV_CORE_top_level
generic map (xlen => xlen, a_width => a_width)
port map(
clk				=> clk				,
rstn				=> rstn				,
--if
dbg_pc			=> dbg_pc			,
dbg_inst			=> dbg_inst			,	
dbg_ifr_pc		=> dbg_ifr_pc		,
dbg_ifr_inst	=> dbg_ifr_inst	,
--id
dbg_alu_ctrl	=> dbg_alu_ctrl	,	
dbg_m_ext_en	=> dbg_m_ext_en	,	
dbg_imm_to_B	=> dbg_imm_to_B	,
dbg_pc4_to_reg	=> dbg_pc4_to_reg	,
dbg_pc_to_a		=> dbg_pc_to_a		,
dbg_rs1_add		=> dbg_rs1_add		,
dbg_rs2_add		=> dbg_rs2_add		,	
dbg_rd_add		=> dbg_rd_add		,	
dbg_branch		=> dbg_branch		,
dbg_jal			=> dbg_jal			,
dbg_jalr			=> dbg_jalr			,
dbg_taken		=> dbg_taken		,	
dbg_target		=> dbg_target		,
dbg_id_pc4		=> dbg_id_pc4		,
--ex
dbg_ex_pc		=> dbg_ex_pc		,	
dbg_imm			=> dbg_imm			,	
dbg_rs1_data	=> dbg_rs1_data	,	
dbg_rs2_data	=> dbg_rs2_data	,
dbg_ex_result	=> dbg_ex_result	,	
--mem
dbg_mem_rd_add	=> dbg_mem_rd_add	,
dbg_st			=> dbg_st			,	
dbg_st_type		=> dbg_st_type		,
dbg_st_data		=> dbg_st_data		,
dbg_ld			=> dbg_ld			,
dbg_ld_type		=> dbg_ld_type		,	
dbg_ld_data		=> dbg_ld_data		,	
--wb
dbg_wb_pc4		=> dbg_wb_pc4		,
dbg_wb_add		=> dbg_wb_add		,
dbg_wb_dout		=> dbg_wb_dout		,	
dbg_wb_we		=> dbg_wb_we		,	

--fwd and hazard
dbg_stall			=> dbg_stall ,
dbg_flush			=> dbg_flush ,
--FWD indicator signals to ID
dbg_mem_to_id1		=> dbg_mem_to_id1,
dbg_mem_to_id2		=> dbg_mem_to_id2,
--FWD indicator signals to EX
dbg_mem_to_ex1		=> dbg_mem_to_ex1	,
dbg_mem_to_ex2		=> dbg_mem_to_ex2	,
dbg_wb_to_ex1		=> dbg_wb_to_ex1	,
dbg_wb_to_ex2		=> dbg_wb_to_ex2	,
--FWD Data
dbg_fwd_mem_data	=> dbg_fwd_mem_data	, --data from ex_mem_reg output
dbg_fwd_wb_data	=> dbg_fwd_wb_data,	--data from mem_wb_reg output

-----------

IF_except		=> IF_except		,	
opcode_except	=> opcode_except	,	
ctrl_except		=> ctrl_except		,	
br_except		=> br_except		,
alu_except		=> alu_except		,
mem_except		=> mem_except		,
wb_except		=> wb_except		
);

end beh;