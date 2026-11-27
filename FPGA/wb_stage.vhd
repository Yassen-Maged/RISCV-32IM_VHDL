library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_stage is
generic(xlen: natural:= 32);
port(
	--inputs
	--EX
	alu_result	: in std_logic_vector(xlen -1 downto 0);
	pc4_to_reg	: in std_logic;
	--MEM
	load			: in std_logic;
	ld_type		: in std_logic_vector(2 downto 0);
	ld_data		: in std_logic_vector(xlen -1 downto 0);
	--IF Stage
	pc4			: in std_logic_vector(xlen -1 downto 0);
	
	--outputs
	data_out		: out std_logic_vector(xlen -1 downto 0);
	wb_except	: out std_logic
);
end wb_stage;

architecture beh of wb_stage is
signal offset: std_logic_vector(1 downto 0);
begin

offset <= alu_result(1 downto 0);
process(all)
begin
data_out <= (others => '0');
wb_except <= '0';

if pc4_to_reg = '1' then --JALR cmd
	data_out <= pc4;
	
elsif load = '1' then --LOAD cmd
	loading: case ld_type is
	when "000" =>	--LB (load to the first byte and sign extend)
		case offset is
		when "00" => --load byte0
			data_out <= std_logic_vector(resize(signed(ld_data(7 downto 0)) , xlen));
		when "01" => --load byte1
			data_out <= std_logic_vector(resize(signed(ld_data(15 downto 8)) , xlen));
		when "10" => --load byte2
			data_out <= std_logic_vector(resize(signed(ld_data(23 downto 16)) , xlen));
		when "11" => --load byte3
			data_out <= std_logic_vector(resize(signed(ld_data(31 downto 24)) , xlen));
		when others =>
			wb_except <= '1';
		end case;
		
	when "001" =>	--LH (load to the first half-word (16 bits) and sign extend)
		case offset is
		when "00" => --load half0
			data_out <= std_logic_vector(resize(signed(ld_data(15 downto 0)) , xlen));
		when "10" => --load half1
			data_out <= std_logic_vector(resize(signed(ld_data(31 downto 16)) , xlen));
		when others =>
			wb_except <= '1';
		end case;
		
	when "010" =>	--LW (load the first word (32 bits))
		if offset = "00" then
			data_out(31 downto 0) <= ld_data(31 downto 0);
		else
			wb_except <= '1';
		end if;
	
	when "100" =>	--LBU (load to the first byte and ZERO extend)
		case offset is
		when "00" => --load byte0
			data_out <= std_logic_vector(resize(unsigned(ld_data(7 downto 0)) , xlen));
		when "01" => --load byte1
			data_out <= std_logic_vector(resize(unsigned(ld_data(15 downto 8)) , xlen));
		when "10" => --load byte2
			data_out <= std_logic_vector(resize(unsigned(ld_data(23 downto 16)) , xlen));
		when "11" => --load byte3
			data_out <= std_logic_vector(resize(unsigned(ld_data(31 downto 24)) , xlen));
		when others =>
			wb_except <= '1';
		end case;
	
	when "101" =>	--LHU (load to the first half-word (16 bits) and ZERO extend)
		case offset is
		when "00" => --load half0
			data_out <= std_logic_vector(resize(unsigned(ld_data(15 downto 0)) , xlen));
		when "10" => --load half1
			data_out <= std_logic_vector(resize(unsigned(ld_data(31 downto 16)) , xlen));
		when others =>
			wb_except <= '1';
		end case;

	when others =>
		wb_except <= '1';
	end case loading;

else
	data_out <= alu_result;
end if;
end process;
end beh;