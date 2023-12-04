library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Testbench is
end entity;
architecture beh of Testbench is
component DUT is
port ( input_vector : in std_logic;
	curr_i: out std_logic_vector(15 downto 0);
			output_vector: out std_logic_vector(4 downto 0);
			pc: out std_logic_vector(15 downto 0);
			alup: out std_logic_vector(15 downto 0);
			alut1:out std_logic_vector(15 downto 0);
			alut2:out std_logic_vector(15 downto 0);
			s6: out std_logic_vector(15 downto 0);
			s9: out std_logic_vector(15 downto 0); 
st: out std_logic_vector(3 downto 0);
v1:out std_logic_vector(15 downto 0);
v2:out std_logic_vector(15 downto 0);
q:out std_logic_vector(15 downto 0);
t1_d: out std_logic_vector(15 downto 0);
t3_d: out std_logic_vector(15 downto 0);
zeroflagtest: out std_logic;
crryflagtest: out std_logic);
end component;


signal input_vector: std_logic:='0';
signal curr_i,pc,alup,s6, s9, alut1, alut2,v1,v2,q,t1_d,t3_d: std_logic_vector(15 downto 0);
signal output_vector:std_logic_vector(4 downto 0);
signal st: std_logic_vector(3 downto 0);
signal zeroflagtest: std_logic:='0';
signal crryflagtest: std_logic:='0';

begin
input_vector<= not input_vector after 100ns;
dut_instance: DUT port map(input_vector,curr_i,output_vector, pc, alup, alut1,alut2,s6, s9, st, v1, v2,q,t1_d,t3_d, zeroflagtest, crryflagtest);
end beh;