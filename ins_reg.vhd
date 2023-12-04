library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ins_reg is
	port (
		reg_a1: out std_logic_vector(2 downto 0);
		reg_a2: out std_logic_vector(2 downto 0);
		reg_a3: out std_logic_vector(2 downto 0);
		zero_extender_9:out std_logic_vector(8 downto 0);
		sign_extender_9: out std_logic_vector(8 downto 0);
		sign_extender_6: out std_logic_vector(5 downto 0);
		mem, pmem: in std_logic_vector(7 downto 0);
		clk: in std_logic;
		s: in std_logic_vector(3 downto 0)
	) ;
end ins_reg;

architecture exe of ins_reg is
signal ir_store: std_logic_vector(15 downto 0);
begin
	write_proc: process(clk, mem, pmem)
	begin
	if(clk='1' and clk'event) then
		if(s="0000") then
			ir_store(7 downto 0) <= mem;
			ir_store(15 downto 8) <= pmem;
			
	end if;
	end if;
	end process;
	
	read_proc: process(ir_store, s, clk)
	begin
	if(s="0001" ) then
		reg_a1<=ir_store(11 downto 9);
		reg_a2 <= ir_store(8 downto 6);
		
	elsif (s="0011") then
		reg_a3<= ir_store(5 downto 3);
		
	elsif (s="0100") then
		sign_extender_6<= ir_store(5 downto 0);
		
	elsif (s="0110") then
		reg_a2<= ir_store(8 downto 6);
		
	elsif (s="1001" or s="1000") then
		reg_a1<= ir_store(11 downto 9);
		zero_extender_9<= ir_store(8 downto 0);
		
	elsif (s="1011") then
		reg_a1<= ir_store(11 downto 9);
		
	elsif (s="1100") then
		sign_extender_9<= ir_store(8 downto 0);
		
	elsif (s="1101") then
		reg_a2<= ir_store(8 downto 6);
		
	elsif (s="1110") then
		reg_a1<= ir_store(11 downto 9);
		sign_extender_6<= ir_store(5 downto 0);
		
			
	elsif (s="1010") then
		sign_extender_6<= ir_store(5 downto 0);
		
	end if;
	end process;

end exe;