library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ins_set is
port( reset,clock:in std_logic;
        next_s: in std_logic_vector(3 downto 0);
		  s: out std_logic_vector(3 downto 0)
		  );
end ins_set;

architecture exe of ins_set is
begin
clock_proc:process(clock,reset,next_s)
begin
    if(clock='1' and clock' event) then
        if(reset='1') then
            s<="0000";
        else
            s<=next_s;
        end if;
    end if;
    
end process;
end exe;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ins_decode is
port(
        next_s: out std_logic_vector(3 downto 0);
		  s: in std_logic_vector(3 downto 0);
		  opcode: in std_logic_vector(3 downto 0);
		  c: in std_logic;
		  z: in std_logic;
		  clk: in std_logic
--		  test_out: out std_logic_vector(0 downto 0)
		  );
end entity ins_decode;

architecture exe of ins_decode is
begin
next_s_process: process(s,clk,opcode)

begin
	case s is
	when ("1111" or "1100" or "1101" or "0011"or "1001" or "0110" or "1000"or "0111")=>
		next_s<="0000";
	when ("0000") =>
		if (opcode = "0000" or opcode="0001"or opcode="0010" or opcode="0100" or opcode="0101" or opcode="0110" or opcode="1001" or opcode="1010"or opcode="1011") then
		next_s<= "0001";
		elsif (opcode="0111") then
		next_s<="1000";
		elsif (opcode="1000") then
		next_s<="1001";
		elsif (opcode="1100"or opcode="1101") then
		next_s<="1011";
		elsif(opcode="0011") then 
		next_s<="1110";
		end if;
		
	when "0001"=>
		if(opcode="0000" or opcode="0001" or opcode="0010" or opcode="0100"or opcode="0101" or opcode="0110") then
		next_s<="0010";
		elsif(opcode="1001"or opcode="1010") then 
		next_s<="0100";
		elsif(opcode="1011") then
		next_s<="1010";
		end if;
	when ("0010") =>
		if(opcode="0000"or opcode="0001"or opcode="0010"or opcode="0011" or opcode="0100" or opcode="0101" or opcode="0110") then
		next_s<="0011";
		end if;
	when "0100"=>
	 if (opcode="1001") then
	  next_s<="0101";
	  elsif(opcode="1010") then
	  next_s<="0111";
	  end if;
	 
	when "0101"=> 
	  if(opcode="1001") then
	  next_s<="0110";
	  end if;
	  
	when "1010" =>
	 if(opcode="1011") then
	  if(z='1') then 
		next_s<="1111";
	  else
		next_s<="0000";
	end if;
	end if;
	when "1011" =>
		if(opcode="1100") then
		next_s<="1100";
		elsif(opcode="1101") then
		next_s<="1101";
		end if;
	
	when "1110" =>
		if(opcode="0011") then
		next_s<="0010";
		end if;
		
	when others =>
                next_s <= "0000"; -- Add the default value
      
	end case;
	end process;
	
	end exe;
			  
