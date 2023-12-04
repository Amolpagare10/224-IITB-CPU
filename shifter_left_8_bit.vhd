library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shifter_left_8_bit is 
	port (input: in std_logic_vector(15 downto 0);
			d_3: out std_logic_vector(15 downto 0);
			s: in std_logic_vector(3 downto 0)
	);
	end entity;
	
architecture exe of shifter_left_8_bit is
begin
	inputi: process(input,s)
	variable i: integer;
	begin
	 if (s="1000") then
	 d_3(7 downto 0) <= "00000000";
		 FOR i IN 8 TO 15 LOOP
	        d_3(i) <= input(i-8);
	      END LOOP;
	elsif(s="1001") then 
	d_3<=input;
	end if;
	end process;
end exe;