
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pro_count is 
	port (alu_c: in std_logic_vector(15 downto 0);
			data_1: out std_logic_vector(15 downto 0);
			reg: in std_logic_vector(15 downto 0);
			reg_out: out std_logic_vector(15 downto 0);
			alu_a: out std_logic_vector(15 downto 0);
			s: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			pc1:out std_logic_vector(15 downto 0)
	);
	end entity;
	
architecture exe of pro_count is  --program counter
signal pc: std_logic_vector(15 downto 0) := x"0000"; 
begin

pc_r: process(s,pc,clk)
begin 
	if (s = "0000") then
		data_1<=pc;
		alu_a <= pc;	
	elsif (s="1111" or s="1100") then
		 alu_a <=pc;
		 elsif(s="1011") then
		 reg_out<=pc;
	end if;
 end process;
-- 
pc_w: process(clk, alu_c,reg,s)
begin
 if (clk='1' AND CLK'EVENT) then
	if (s = "0000" or s="0100" or s="1100" or s="1111") then
		pc <= alu_c;
		pc1<=pc;
	elsif (s="1101") then
		pc <=reg; 
	end if;
end if;	
end process;
end exe;