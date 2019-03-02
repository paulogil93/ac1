--------------------------------------------
-- Paulo Gil
-- paulogil@ua.pt
-- AC1-2017
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.MIPS_pkg.all;
use work.DisplayUnit_pkg.all;

entity mips_single_cycle is
	port(CLOCK_50	: in	std_logic;
		  SW			: in	std_logic_vector(7 downto 0);
		  KEY			: in	std_logic_vector(3 downto 0);
		  LEDR		: out std_logic_vector(9 downto 0);
		  HEX0		: out std_logic_vector(6 downto 0);
		  HEX1		: out std_logic_vector(6 downto 0);
		  HEX2		: out std_logic_vector(6 downto 0);
		  HEX3		: out std_logic_vector(6 downto 0);
		  HEX4		: out std_logic_vector(6 downto 0);
		  HEX5		: out std_logic_vector(6 downto 0);
		  HEX6		: out std_logic_vector(6 downto 0);
		  HEX7		: out std_logic_vector(6 downto 0));
end mips_single_cycle;

architecture Structural of mips_single_cycle is

	signal s_clk, s_zero, s_ovf, s_RegWrite	: std_logic;
	signal s_RegDst, s_Branch, s_MemRead		: std_logic;
	signal s_MemWrite, s_MemToReg, s_ALUsrc	: std_logic;
	signal s_Jump										: std_logic;
	signal s_offset, s_pc, s_instr, s_ALU		: std_logic_vector(31 downto 0);
	signal s_readData1, s_readData2, s_mux2	: std_logic_vector(31 downto 0);
	signal s_DataMemory, s_mux3					: std_logic_vector(31 downto 0);
	signal s_jAddr										: std_logic_vector(25 downto 0);
	signal s_imm										: std_logic_vector(15 downto 0);
	signal s_opcode, s_funct						: std_logic_vector(5 downto 0);
	signal s_rs, s_rt, s_rd, s_shamt, s_mux1	: std_logic_vector(4 downto 0);
	signal s_ALUcontrol								: std_logic_vector(2 downto 0);
	signal s_ALUop										: std_logic_vector(1 downto 0);
	
begin
	
	--Debouncer
	deb: entity work.DebounceUnit(Behavioral)
		generic map(mSecMinInWidth	=> 200,
						inPolarity		=> '0',
						outPolarity		=> '1')
			port map(refClk			=> CLOCK_50,
						dirtyIn			=> KEY(0),
						pulsedOut		=> s_clk);
	
	--PC Update
	pc_update: entity work.PCupdate(Behavioral)
					port map(clk		=> s_clk,
								reset		=> not KEY(1),
								zero		=> s_zero,
								branch	=> s_Branch,
								jump		=> s_Jump,
								jAddr26	=> s_jAddr,
								offset32	=> s_offset,
								pc			=> s_pc);
								
	--Instruction Memory
	im_mem: entity work.InstructionMemory(Behavioral)
		generic map(ADDR_BUS_SIZE	=> 6)
			port map(address			=> s_pc(ROM_ADDR_SIZE+1 downto 2),
						readData			=> s_instr);
						
	--Splitter
	spl: entity work.InstrSplitter(Behavioral)
				port map(instruction => s_instr,
							opcode		=> s_opcode,
							rs				=> s_rs,
							rt				=> s_rt,
							rd				=> s_rd,
							shamt			=> s_shamt,
							funct			=> s_funct,
							imm			=> s_imm,
							jAddr			=> s_jAddr);
							
	--Signal Extend
	s_ext: entity work.SignExtend(Behavioral)
					port map(dataIn	=> s_imm,
								dataOut	=> s_offset);
								
	--Mux1
	mux1: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 5)
					port map(sel		=> s_RegDst,
								input0	=> s_rt,
								input1	=> s_rd,
								muxOut	=> s_mux1);
								
	--Register File
	reg: entity work.RegFile(Structural)
				port map(clk			=> CLOCK_50,
							writeEnable => s_RegWrite,
							writeReg		=> s_mux1,
							writeData	=> s_mux3,
							readReg1		=> s_rs,
							readReg2		=> s_rt,
							readData1	=> s_readData1,
							readData2	=> s_readData2);
							
							
	--Mux2
	mux2: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_ALUsrc,
								input0	=> s_readData2,
								input1	=> s_offset,
								muxOut	=> s_mux2);
								
	--ALU Control
	alu_control: entity work.ALUcontrol(Behavioral)
				port map(ALUop			=> s_ALUop,
							funct			=> s_funct,
							ALUcontrol 	=> s_ALUcontrol);
								
	--ALU32
	alu32: entity work.ALU32(Behavioral)
					port map(op			=> s_ALUcontrol,
								inputA	=> s_readData1,
								inputB	=> s_mux2,
								res		=> s_ALU,
								zero		=> s_zero,
								ovf		=> s_ovf);
								
	--Data Memory
	dm_mem: entity work.DataMemory(Behavioral)
		generic map(ADDR_BUS_SIZE	=> 6,
						DATA_BUS_SIZE	=> 32)
				port map(clk			=> CLOCK_50,
							readEn		=> s_MemRead,
							writeEn		=> s_MemWrite,
							address		=> s_ALU(RAM_ADDR_SIZE+1 downto 2),
							writeData	=> s_readData2,
							readData		=> s_DataMemory);
	
	--Mux3
	mux3: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_MemToReg,
								input0	=> s_ALU,
								input1	=> s_DataMemory,
								muxOut	=> s_mux3);
	
	--ControlUnit
	ctrl: entity work.ControlUnit(Behavioral)
					port map(OpCode	=> s_opcode,
								RegDst	=> s_RegDst,
								Branch	=> s_Branch,
								MemRead	=> s_MemRead,
								MemWrite	=> s_MemWrite,
								MemToReg => s_MemToReg,
								ALUsrc	=> s_ALUsrc,
								RegWrite => s_RegWrite,
								Jump		=> s_Jump,
								ALUop		=> s_ALUop);
	
	--Display Unit
	disp: entity work.DisplayUnit(Behavioral)
		generic map(dataPathType	=> SINGLE_CYCLE_DP,
						IM_ADDR_SIZE	=> ROM_ADDR_SIZE,
						DM_ADDR_SIZE	=> RAM_ADDR_SIZE)
			port map(RefClk			=> CLOCK_50,
						InputSel			=> SW(1 downto 0),
						DispMode			=> SW(2),
						NextAddr			=> KEY(3),
						Dir				=> KEY(2),
						disp0				=> HEX0,
						disp1				=> HEX1,
						disp2				=> HEX2,
						disp3				=> HEX3,
						disp4				=> HEX4,
						disp5				=> HEX5,
						disp6				=> HEX6,
						disp7				=> HEX7);
						
	--Sinais de controlo -> LEDR
	LEDR(0) <= s_Jump;
	LEDR(1) <= s_Branch;
	LEDR(2) <= s_MemToReg;
	LEDR(3) <= s_MemWrite;
	LEDR(4) <= s_MemRead;
	LEDR(5) <= s_ALUsrc;
	LEDR(6) <= s_RegWrite;
	LEDR(7) <= s_RegDst;
	LEDR(9 downto 8) <= s_ALUop;
	
end Structural;