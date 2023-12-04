library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is 
	port (reg_a1: in std_logic_vector(2 downto 0);  --IR 9-11
			reg_a2: in std_logic_vector(2 downto 0);	--IR 6-8
			reg_a3: in std_logic_vector(2 downto 0); --IR 3-5
--			RF_D1: out std_logic_vector(15 downto 0);
--			RF_D2: out std_logic_vector(15 downto 0);
			pc_in: in std_logic_vector(15 downto 0);
			pc_out: out std_logic_vector(15 downto 0);
			clk: in std_logic;
			s: in std_logic_vector(3 downto 0);
			t3: in std_logic_vector(15 downto 0);
			t1_in: out std_logic_vector(15 downto 0);
			t2_in: out std_logic_vector(15 downto 0);--now data stored here
			ZERO_EXTENDER: in std_logic_vector(15 downto 0);
			v1: out std_logic_vector(15 downto 0);
			v2:out std_logic_vector(15 downto 0)
	);
end entity;
architecture exe of regfile is
type reg_array is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal regs: reg_array :=(
   x"FFFF",x"FFFF", x"0010", x"0011",
	x"0100",x"0101", x"0110", x"0111" -- 'F' is in hexa decimal , 15 = "1111"
   ); 
begin

regs_read: process(reg_a1, reg_a2, s, clk)
begin 
	--s1: Read Operands
	if (s = "0001") then  
	
		t1_in <= regs(to_integer(unsigned(reg_a1)));
		t2_in <= regs(to_integer(unsigned(reg_a2)));
	
	--s13: Store data of A2 in D1	
	elsif (s="1101") then 
			pc_out <= regs(to_integer(unsigned(reg_a2)));
			
	--S14: Signed extension of 6 bit and store in T2		
	elsif (s="1110") then  
		t1_in <= regs(to_integer(unsigned(reg_a1)));
		
		
	end if;
 end process;
 
regs_write: process(clk,t3,zero_extender, pc_in,s)
begin
 if (clk='1' and clk'event) then
 
	--s3: Update Register
	if (s = "0011") then 	
		regs(to_integer(unsigned(reg_a3)))<= t3;
		
	--s6:	
	elsif (s="0110") then 
		regs(to_integer(unsigned(reg_a1)))<= t3;
		
	--s9:	
	elsif (s="1001" or s="1000") then 
		regs(to_integer(unsigned(reg_a1))) <= ZERO_EXTENDER; -- change the name for zero extender
		
	--s11:	
	elsif (s="1011") then	 
		regs(to_integer(unsigned(reg_a1))) <= pc_in;
	end if;
	end if;
end process;
v1<=regs(to_integer(unsigned(reg_a1)));
v2<=regs(to_integer(unsigned(reg_a2)));
end exe;
 