library ieee;
use ieee.std_logic_1164.all;
entity DUT is
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
end entity;
architecture DutWrap of DUT is
	signal state: std_logic_vector(3 downto 0 ):="0000";
	signal next_state: std_logic_vector(3 downto 0 ):="0000";
	signal clk: std_logic;
	signal rst: std_logic;
	signal curr_ins, ze, w_se6,w_se9,w_t3_in,w_t3_alu,w_pc_aluin,
	ze_shifted,w_pc_outreg,w_d_alu_t1,w_d_alu_t2,w_1s, w_2s,w_alu_pcout,
	w_addr_3, w_pc_reg,w_din_t3, w_din_t1, ir_d,w_d_t3, w_t3, w_t2,
	w_t1, w_ins_addr: std_logic_vector(15 downto 0);
	signal w1,w2,w3: std_logic_vector(2 downto 0);
	signal w4: std_logic_vector(8 downto 0);
	signal w5: std_logic_vector(5 downto 0);
	signal w6: std_logic_vector(8 downto 0);
	signal carry, zero: std_logic;

component ins_decode is
port(   next_s: out std_logic_vector(3 downto 0);
		  s: in std_logic_vector(3 downto 0);
		  opcode: in std_logic_vector(3 downto 0);
		  c: in std_logic;
		  z: in std_logic;
		  clk: in std_logic);
end component ins_decode;

component ins_set is
port( reset,clock:in std_logic;
        next_s: in std_logic_vector(3 downto 0);
		  s: out std_logic_vector(3 downto 0)
		  );
end component ins_set;

	
component ins_reg is
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
	);
	end component;
	
component memry is
	port(data_t2: in std_logic_vector(15 downto 0);
	 s: in std_logic_vector(3 downto 0);
	 t3_addr: in std_logic_vector(15 downto 0);
	 data_3: out std_logic_vector(15 downto 0);--jo yeh code se output hoga
	 ir_d: out std_logic_vector(15 downto 0);
	 ins_addr: in std_logic_vector(15 downto 0);
	 clk : in std_logic;
	 t1_d: out std_logic_vector(15 downto 0);
	 t3_d: out std_logic_vector(15 downto 0)
	 );
	 end component;
	
component regfile is 
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
	end component;
	
component temp_1 is
	port(
		alu_in: out std_logic_vector(15 downto 0);
		clk: in std_logic;
		reg: in std_logic_vector(15 downto 0);
		s: in std_logic_vector(3 downto 0);
		mem_1: out std_logic_vector(15 downto 0)
		
	);
	end component;
	
	
component sign_extender_6_bit is
	port(input: in std_logic_vector(5 downto 0);
	s: in std_logic_vector(3 downto 0);
	alu_b: out std_logic_vector(15 downto 0));
end component;
	
	
component sign_extender_9_bit is
	port(input: in std_logic_vector(8 downto 0); 
	s: in std_logic_vector(3 downto 0); 
	alu_b: out std_logic_vector(15 downto 0));
end component;
	
component shifter_left_8_bit is 
	port (input: in std_logic_vector(15 downto 0);
			d_3: out std_logic_vector(15 downto 0);
			s: in std_logic_vector(3 downto 0));
end component;
	
	
component shifter_1_bit is 
	port (input: in std_logic_vector(15 downto 0);
			alu_b: out std_logic_vector(15 downto 0);
			s: in std_logic_vector(3 downto 0);
			clk: in std_logic);
	end component;

	
component pro_count is 
port (alu_c: in std_logic_vector(15 downto 0);
			data_1: out std_logic_vector(15 downto 0);
			reg: in std_logic_vector(15 downto 0);
			reg_out: out std_logic_vector(15 downto 0);
			alu_a: out std_logic_vector(15 downto 0);
			s: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			pc1:out std_logic_vector(15 downto 0)
	);
	end component;
	

component temp_2 is 
port(
		alu_in: out std_logic_vector(15 downto 0);--input ot
		clk: in std_logic;
		s: in std_logic_vector(3 downto 0);
		reg: in std_logic_vector(15 downto 0);
		signed_extension_6:in std_logic_vector(15 downto 0)
	);
end component;
component  zero_extender_9_bit is
	port(input: in std_logic_vector(8 downto 0); 
	s: in std_logic_vector(3 downto 0); 
	ze: out std_logic_vector(15 downto 0);
	clk: in std_logic);
end component;

component temp_3 is 
		port(
		alu_c: in std_logic_vector(15 downto 0);
		clk: in std_logic;
		reg: out std_logic_vector(15 downto 0);
		data_3: in std_logic_vector(15 downto 0);
		s: in std_logic_vector(3 downto 0);
		mem:out std_logic_vector(15 downto 0)
	);
end component;

component alu is
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
	 --one_bit_shifter: in std_logic_vector(15 downto 0);
	);
	end component;
begin
	output_vector(3 downto 0) <= state;
	output_vector(4) <= carry;
	stateTrans_instance: ins_decode
			port map (
					next_s => next_state,
					s => state,
					opcode => curr_ins(15 downto 12),
					c=> carry,
					z=> zero,
					clk=> input_vector
 					);
	stateSet_instance: ins_set
		port map (
			clock => input_vector,
			next_s => next_state,
			s => state,
			reset => rst
		);
	
		ir_instance: ins_reg
			port map(
			clk => input_vector,
			s => state,
			mem => curr_ins(7 downto 0),
			pmem=> curr_ins(15 downto 8),
			zero_extender_9 => w4,
			reg_a1=> w1,
			reg_a2 => w2,
			reg_a3 => w3,
			sign_extender_6 => w5,
			sign_extender_9 => w6
			);
			
			sign_extender_9: sign_extender_9_bit
					port map (
						s=> state,
						input=> w6,
						alu_b=> w_se9
					);		
		sign_extender_6: sign_extender_6_bit
					port map (
						s=> state,
						input=> w5,
						alu_b=> w_se6
					);	
				
			zero_ext: zero_extender_9_bit		
			   	port map (
					 s=> state,
					 input=>w4,
					 ze=>ze,
					 clk=>input_vector
					);	
					
			ls_8_bit: shifter_left_8_bit
			   	port map (
					 s=> state,
					 input=> ze,
					 d_3=>ze_shifted
					);	
					memry_instance: memry
			port map(
				s => state,
				clk => input_vector,
				data_3 => w_d_t3,
				data_t2=> w_din_t1,
				t3_addr=>w_addr_3,
				ir_d=> curr_ins,
				ins_addr => w_ins_addr,
				t1_d=>t1_d,
				t3_d=>t3_d
			);
		reg_instance: regfile
				port map(
					reg_a1 => w1,
					reg_a2 => w2,
					reg_a3 => w3,
					s => state,
					clk => input_vector,
					pc_in => w_pc_reg,
					ZERO_EXTENDER=>ze_shifted,
					t3 => w_t3_in,
					t2_in => w_t2,--reg
					pc_out => w_pc_outreg,
					t1_in => w_t1,
					v1=>v1,
					v2=>v2
				);
				
		t1_instance: temp_1
				port map (
					s => state,
					clk => input_vector,
					reg=>w_t1,
					alu_in => w_d_alu_t1,--(for_alua)
					mem_1=> w_din_t1
					--written at clock is ok
					--at clock data is written in t1, t2, t3
				);	
				
		t2_instance: temp_2
					port map (
						s => state,
						clk => input_vector,
						alu_in=> w_d_alu_t2,--(for alub)
						reg=> w_t2,
						signed_extension_6=>w_se6
					);
			t3_instance: temp_3
					port map(
						s=> state,
						clk => input_vector,
						data_3=>w_d_t3,
						reg=>w_t3_in,
						mem=>w_addr_3,
						alu_c => w_t3_alu--put input for value of alu_c
					);
			
			shift1: shifter_1_bit port map(input=>w_se9,
			alu_b=>w_2s,
			s=>state, clk=>input_vector);
			alu_instance: alu
					port map(
						s => state,
						t1 => w_d_alu_t1,
						opcode=>curr_ins(15 downto 12),
						t2 => w_d_alu_t2,
						pc_in => w_pc_aluin,
						sign_extender_9=>w_2s,
						sign_extender_6=>w_se6,
						t3 => w_t3_alu,
						pc_out => w_alu_pcout,
						carry_out=> carry,
						clk=>input_vector,
						zero_out=> zero
					);
				pc_instance: pro_count
					port map (
					s=> state,
					clk => input_vector,
					alu_c => w_alu_pcout,
					alu_a=> w_pc_aluin,
					reg=>w_pc_outreg,
					reg_out=>w_pc_reg,
					data_1=> w_ins_addr,
					pc1=>q
					);
					pc<=w_alu_pcout;
					s6<=w_se6;
					s9<=w_2s;
					curr_i<=curr_ins;
					alup<=w_t3_alu;
					alut1<=w_d_alu_t1;
					alut2<=w_d_alu_t2;
					st<=state;
					zeroflagtest<=zero;
					crryflagtest<= carry;
					
					
end DutWrap;


