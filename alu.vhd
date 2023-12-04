library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;

entity alu is
port(s: in std_logic_vector(3 downto 0);
		clk: in std_logic;
	 t1: in std_logic_vector(15 downto 0);
	 t2: in std_logic_vector(15 downto 0);
	 t3: out std_logic_vector(15 downto 0);
	 opcode: in std_logic_vector(3 downto 0);
	 
	 pc_in: in std_logic_vector(15 downto 0);
	 pc_out: out std_logic_vector(15 downto 0);
	 
	 sign_extender_9: in std_logic_vector(15 downto 0);
	 sign_extender_6: in std_logic_vector(15 downto 0);
	 
	 carry_out: out std_logic;
	 zero_out: out std_logic
	 
	 );
end entity;
	 
architecture exe of alu is
signal carry: std_logic:='0';
signal zero: std_logic:='0';	
signal t3_i, t2_i: std_logic_vector(15 downto 0);

begin
	carry_out <= carry;
	zero_out<= zero;
	compute : process(t1,t2, pc_in, sign_extender_9, sign_extender_6, s, clk)
	variable temp, temp1: integer;
 
   begin
	 if (s="0010") then --state 2
	 if (opcode="0000" or opcode="0011") then
		 --Execute Addition for data in 2 registers
		 temp := to_integer(unsigned(t1)) + to_integer(unsigned(t2));
		 if (temp>=65536) then
			carry <= '1';
			t3 <= std_logic_vector(to_unsigned(temp-65536,16));
		else
			carry <= '0';
			t3 <= std_logic_vector(to_unsigned(temp,16));
		end if; 
	elsif(opcode="0001") then
	temp := to_integer(unsigned(t1)) - to_integer(unsigned(t2));
		if (temp < 0) then
    carry <= '1';
    t3 <= std_logic_vector(to_unsigned(65536 + temp, 16));
		else
    carry <= '0';
    t3 <= std_logic_vector(to_unsigned(temp, 16));
		end if;
	elsif(opcode="0010") then
	temp := to_integer(unsigned(t1)) * to_integer(unsigned(t2));
    t3 <= std_logic_vector(to_unsigned(temp, 16));		
	elsif(opcode="0100") then
	t3<=(t1(15 downto 0) and t2(15 downto 0));
	if ((t1 and t2)= x"0000") then
			zero <= '1';
		end if;
	elsif(opcode="0101") then
	for i in 0 to 15 loop
	 t3(i)<=(t1(i) or t2(i));
	 end loop;
	 if ((t1 or t2)= x"0000") then
			zero <= '1';
		end if;
	elsif(opcode="0110") then
	t3<=(not t1 ) or t2;
	if ((not(t1) or t2)= x"0000") then
			zero <= '1';
		end if;
	end if;
	elsif (s="0100") then --s4
		 --Computing address of the memory destination
		 if(opcode="1010" or opcode="1001") then
		 
		 temp := to_integer(unsigned(t2)) + to_integer(unsigned(sign_extender_6));
		 if (temp>65535) then
			carry <= '1';
			t3 <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			carry <= '0';
			t3 <= std_logic_vector(to_unsigned(temp,16));
		end if;	
		end if;
	elsif (s="1010") then --s10 complete with s15	
		 --execute
		 temp1 := to_integer(unsigned(t1)) - to_integer(unsigned(t2));
		 if (temp1< 0) then
    carry <= '1';
    t3_i <= std_logic_vector(to_unsigned(65536 + temp1, 16));
	 t3<=std_logic_vector(to_unsigned(temp1,16));
		else
    carry <= '0';
    t3_i <= std_logic_vector(to_unsigned(temp1, 16));
	 t3<=std_logic_vector(to_unsigned(temp1,16));
		end if;
		 
		 temp := to_integer(unsigned(pc_in)) + to_integer(unsigned(sign_extender_6));
		 if (temp>65535) then
			carry <= '1';
			t2_i<= std_logic_vector(to_unsigned(temp-65535,16));
		else
			carry <= '0';
			t2_i<=std_logic_vector(to_unsigned(temp,16));
		end if;	
		zero <= not(t3_i(15) or t3_i(14) or t3_i(13) or t3_i(12) or t3_i(11) or t3_i(10) or t3_i(9) or t3_i(8) or t3_i(7) or t3_i(6) or t3_i(5) or t3_i(4) or t3_i(3) or t3_i(2) or t3_i(1) or t3_i(0));
		if (zero = '1')then 
				pc_out <= t2_i;
		else pc_out<=pc_in;	
		end if;	
	
	elsif (s="1100") then --s12
		 --Signed extension of 9 bits and Add
		 temp := to_integer(unsigned(pc_in)) + to_integer(unsigned(sign_extender_9));
		 if (temp>65535) then
			carry <= '1';
			pc_out <= std_logic_vector(to_unsigned(temp-65535,16));
		else
			carry <= '0';
			pc_out <= std_logic_vector(to_unsigned(temp,16));
		end if;
		
		
	elsif(s="0000") then --s0
	-- Fetching Instruction from memory
		temp := to_integer(unsigned(pc_in)) + 2;
		pc_out <= std_logic_vector(to_unsigned(temp,16));	
		
		end if;
	end process;
end exe;
		
		
		
		
		
		
		
		
		