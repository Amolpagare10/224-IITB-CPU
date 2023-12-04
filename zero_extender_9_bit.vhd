library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;


entity zero_extender_9_bit is
	port(input: in std_logic_vector(8 downto 0); 
	s: in std_logic_vector(3 downto 0); 
	ze: out std_logic_vector(15 downto 0);
	clk:in std_logic);
end entity;
	 
architecture exe of zero_extender_9_bit is

begin
	ze_proc: process(input, s,clk)
--	variable temp: integer;
	begin
	 if (s = "1000" or s="1001") then
		for i in 9 to 15 loop
		ze(i) <= '0';
		end loop;
	ze(8 downto 0) <= input;
	end if;
	
	end process;
end exe;