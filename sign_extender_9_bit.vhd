library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;


entity sign_extender_9_bit is
	port(input: in std_logic_vector(8 downto 0); 
	s: in std_logic_vector(3 downto 0); 
	alu_b: out std_logic_vector(15 downto 0));
end entity;
	 
architecture exe of sign_extender_9_bit is

begin
	se_proc: process(input, s)
	variable temp: integer;
	begin
	 if (s="1100") then
	if (input(8)='1') then
	for i in 9 to 15 loop
	alu_b(i) <= '1';
	end loop;
	else 
	for i in 9 to 15 loop
	alu_b(i) <= '0';
	end loop;
	end if;
	alu_b(8 downto 0)<=input;
	end if;
	end process;
end exe;