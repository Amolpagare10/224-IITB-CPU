library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity temp_1 is 
	port(
		alu_in: out std_logic_vector(15 downto 0);
		clk: in std_logic;
		reg: in std_logic_vector(15 downto 0);
		s: in std_logic_vector(3 downto 0);
		mem_1: out std_logic_vector(15 downto 0)
		
	);
end entity;
architecture exe of temp_1 is
signal t1: std_logic_vector(15 downto 0);
begin
	read_proc: process(t1, s,clk)
	begin
		if (s="0010" or s="0100" or s="1010") then
		alu_in <= t1;
		elsif(s="0111") then
		mem_1<=t1;
		end if;
	end process;

	write_proc: process(s,clk, reg)
	begin 
		if(clk='1' and clk'event) then
			if (s="1110" or s="0001") then
			t1 <= reg;	
			end if;
		end if;
	end process;
end exe;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temp_2 is 
	port(
		alu_in: out std_logic_vector(15 downto 0);--input ot
		clk: in std_logic;
		s: in std_logic_vector(3 downto 0);
		reg: in std_logic_vector(15 downto 0);
		signed_extension_6:in std_logic_vector(15 downto 0)
	);
end entity temp_2;
architecture exe of temp_2 is
signal t2: std_logic_vector(15 downto 0);
begin
	read_proc: process(t2, s)
	begin
		if (s="0010" or s="1010") then
		alu_in <= t2;
		end if;
	end process;

	write_proc: process(s,clk,reg, signed_extension_6)
	begin 
		if(clk='1' and clk'event) then
			if (s="0001") then
			t2<=reg;
			elsif (s="1110") then
			t2<=signed_extension_6;
			end if;
		end if;
	end process;
end exe;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temp_3 is 
	port(
		alu_c: in std_logic_vector(15 downto 0);
		clk: in std_logic;
		reg: out std_logic_vector(15 downto 0);
		data_3: in std_logic_vector(15 downto 0);
		s: in std_logic_vector(3 downto 0);
		mem:out std_logic_vector(15 downto 0)
--		t3_in:out std_logic_vector(15 downto 0)
	);
end entity temp_3;

architecture exe of temp_3 is
signal t3: std_logic_vector(15 downto 0);
begin
	r_proc: process(t3,s)
	begin
	if(s="0011" or s="0110") then 
	reg<=t3;
	elsif(s="0101" or s="0111") then
	mem<=t3;
	end if;
	end process;
  w_proc: process(t3, s,clk,data_3, alu_c)
	begin
	if(clk='1' and clk'event) then
		if (s="0010" or s="0100" or s="1010") then
		t3<=alu_c;
--		t3_in<=alu_c;
		elsif(s="0101") then
		t3<=data_3;
			end if;
		end if;
	end process;
end exe;