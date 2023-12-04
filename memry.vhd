library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memry is
	port( 
	data_t2: in std_logic_vector(15 downto 0);
	 s: in std_logic_vector(3 downto 0);
	 t3_addr: in std_logic_vector(15 downto 0);
	 data_3: out std_logic_vector(15 downto 0);--jo yeh code se output hoga
	 ir_d: out std_logic_vector(15 downto 0);
	 ins_addr: in std_logic_vector(15 downto 0);
	 clk : in std_logic;
	 t1_d: out std_logic_vector(15 downto 0);
	 t3_d: out std_logic_vector(15 downto 0)
	 );
	 end entity;
	 
architecture exe of memry is
	type mem_array is array (0 to 31) of std_logic_vector(7 downto 0);
    signal mem_data : mem_array := (
        "11111111", "11111111", "00000011", "00000000",
        "11111111", "11111111", "00000011", "00000000",
        "11111111", "00000000", "00000011", "00000011",
        "11111111", "00000011", "00000011", "00000011",
        "00000011", "00000011", "00000011", "11111111",
        "11111111", "00000000", "00000011", "11111111",
        "00000000", "00000000", "00000000", "00000011",
        "11111111", "11111111", "11111111", "00000000"
    );
	 
	signal mem_inst : mem_array := (
         "01011010", "00000000", "01011010", "00010000",
        "01011010", "00100000", "01011010", "00110000",
        "01011010", "01000000", "01011010", "01010000",
        "01011010", "01100000", "01011010", "01110000",
        "01011010", "10000000", "01011010", "10010000",
        "01011010", "10100000", "01011010", "10110000",
        "01011010", "11000000", "01011010", "11010000",
        "01011010", "11100000", "01011010", "00000000"
    );
	
	begin
	mem_w: process(clk,ins_addr,t3_addr,data_t2,ins_addr,s,mem_data)
	begin
	if (clk='1' and clk'event) then
	if(s="0111") then
	 mem_data(to_integer(unsigned(t3_addr))) <= data_t2(7 downto 0);--actually t1
	 mem_data(to_integer(unsigned(t3_addr))+1) <= data_t2(15 downto 8);
	 t1_d(7 downto 0)<=mem_data(to_integer(unsigned(t3_addr)));
	 t1_d(15 downto 8)<=mem_data(to_integer(unsigned(t3_addr))+1);
	end if;
	end if;
--	ir_d(15 downto 8) <= mem_inst(to_integer(unsigned(ins_addr))+1);
--	ir_d(7 downto 0) <= mem_inst(to_integer(unsigned(ins_addr)));
	end process;
	
	
	mem_r: process(s,t3_addr,mem_data,clk)
	begin
		if (s="0101") then
			data_3(7 downto 0)<= mem_data(to_integer(unsigned(t3_addr)));
			data_3(15 downto 8)<= mem_data(to_integer(unsigned(t3_addr))+1);
			t3_d(7 downto 0)<=mem_data(to_integer(unsigned(t3_addr)));
	 t3_d(15 downto 8)<=mem_data(to_integer(unsigned(t3_addr))+1);
		end if;	
	end process;
	ir_d(15 downto 8) <= mem_inst(to_integer(unsigned(ins_addr))+1);
	ir_d(7 downto 0) <= mem_inst(to_integer(unsigned(ins_addr)));
end exe;
	
	
	
	