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

entity mips_multi_cycle is
	port(CLOCK_50	: in	std_logic;
		  SW			: in	std_logic_vector(7 downto 0);
		  KEY			: in	std_logic_vector(3 downto 0);
		  LEDG		: out std_logic_vector(6 downto 0);
		  LEDR		: out std_logic_vector(8 downto 0);
		  HEX0		: out std_logic_vector(6 downto 0);
		  HEX1		: out std_logic_vector(6 downto 0);
		  HEX2		: out std_logic_vector(6 downto 0);
		  HEX3		: out std_logic_vector(6 downto 0);
		  HEX4		: out std_logic_vector(6 downto 0);
		  HEX5		: out std_logic_vector(6 downto 0);
		  HEX6		: out std_logic_vector(6 downto 0);
		  HEX7		: out std_logic_vector(6 downto 0));
end mips_multi_cycle;

architecture Structural of mips_multi_cycle is
	signal s_clk, s_reset, s_zero, s_PCWrite	: std_logic;
	signal s_PCWriteCond, s_IorD, s_IRWrite	: std_logic;
	signal s_RegDst, s_MemRead, s_MemWrite		: std_logic;
	signal s_MemToReg, s_ALUSelA, s_RegWrite	: std_logic;
	signal s_PCSource, s_ALUSelB, s_ALUop		: std_logic_vector(1 downto 0);
	signal s_op											: std_logic_vector(2 downto 0);
	signal s_rs, s_rt, s_rd, s_shamt, s_mux2	: std_logic_vector(4 downto 0);
	signal s_opcode, s_funct						: std_logic_vector(5 downto 0);
	signal s_imm										: std_logic_vector(15 downto 0);
	signal s_PC4, s_BTA, s_pc, s_ALUout			: std_logic_vector(31 downto 0);
	signal s_mux1, s_RAMOut, s_RegisterA		: std_logic_vector(31 downto 0);
	signal s_IROut, s_DROut, s_mux3, s_mux4	: std_logic_vector(31 downto 0);
	signal s_RFOut1, s_RFOut2, s_RegisterB		: std_logic_vector(31 downto 0);
	signal s_imm32, s_shift, s_mux5, s_ALUres	: std_logic_vector(31 downto 0);
	signal s_jAddr										: std_logic_vector(25 downto 0);
begin

	--Debouncer
	deb: entity work.DebounceUnit(Behavioral)
			generic map(mSecMinInWidth	=> 200,
						inPolarity		=> '0',
						outPolarity		=> '1')
				port map(refClk		=> CLOCK_50,
							dirtyIn		=> KEY(0),
							pulsedOut	=> s_clk);
	
	--Control Unit
	ctrl: entity work.ControlUnit(Behavioral)
				port map(clock			=> s_clk,
							reset			=> not KEY(1),
							opCode		=> s_opcode,
							PCWrite		=> s_PCWrite,
							IRWrite		=> s_IRWrite,
							IorD			=> s_IorD,
							PCSource		=> s_PCSource,
							RegDst		=> s_RegDst,
							PCWriteCond	=> s_PCWriteCond,
							MemRead		=> s_MemRead,
							MemWrite		=> s_MemWrite,
							MemToReg		=> s_MemToReg,
							ALUSelA		=> s_ALUSelA,
							ALUSelB		=> s_ALUSelB,
							RegWrite		=> s_RegWrite,
							ALUop			=> s_ALUop);
							
	--PC Update
	pc: entity work.PCupdate(Behavioral)
				port map(clk			=> s_clk,
							reset			=> not KEY(1),
							zero			=> s_zero,
							PCSource		=> s_PCSource,
							PCWrite		=> s_PCWrite,
							PCWriteCond => s_PCWriteCond,
							PC4			=> s_PC4,
							BTA			=> s_BTA,
							jAddr			=> s_jAddr,
							pc				=> s_pc);
							
	--Mux1
	mux1: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_IorD,
								input0	=> s_pc,
								input1	=> s_ALUout,
								muxOut	=> s_mux1);
							
	--Data Memory
	ram:	entity work.DataMemory(Behavioral)
		generic map(ADDR_BUS_SIZE	=> RAM_ADDR_SIZE,
						DATA_BUS_SIZE	=> 32)
				port map(clk			=> s_clk,
							readEn		=> s_MemRead,
							writeEn		=> s_MemWrite,
							address		=> s_mux1(RAM_ADDR_SIZE+1 downto 2),
							writeData	=> s_RegisterB,
							readData		=> s_RAMOut);
							
	--Instruction Register
	ir: entity work.Register32(Behavioral)
					port map(clk		=> s_clk,
								enable	=> s_IRWrite,
								dataIn	=> s_RAMOut,
								dataOut	=> s_IROut);
							
	--Data Register
	dr: entity work.Register32(Behavioral)
					port map(clk		=> s_clk,
								enable	=> '1',
								dataIn	=> s_RAMOut,
								dataOut	=> s_DROut);
								
	--Instruction Splitter
	splitter: entity work.InstrSplitter(Behavioral)
				port map(instruction => s_IROut,
							opcode		=> s_opcode,
							rs				=> s_rs,
							rt				=> s_rt,
							rd				=> s_rd,
							shamt			=> s_shamt,
							funct			=> s_funct,
							imm			=> s_imm,
							jAddr			=> s_jAddr);
							
	--Mux2
	mux2: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 5)
					port map(sel		=> s_RegDst,
								input0	=> s_rt,
								input1	=> s_rd,
								muxOut	=> s_mux2);
								
	--Mux3
	mux3: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_MemToReg,
								input0	=> s_ALUOut,
								input1	=> s_DROut,
								muxOut	=> s_mux3);
								
	--Register File
	rf: entity work.RegFile(Structural)
				port map(clk			=> s_clk,
							writeEnable	=> s_RegWrite,
							writeReg		=> s_mux2,
							writeData	=> s_mux3,
							readReg1		=> s_rs,
							readReg2		=> s_rt,
							readData1	=> s_RFOut1,
							readData2	=> s_RFOut2);
							
	--Register A
	r_a: entity work.Register32(Behavioral)
					port map(clk		=> s_clk,
								enable	=> '1',
								dataIn	=> s_RFOut1,
								dataOut	=> s_RegisterA);
								
	--Register A
	r_b: entity work.Register32(Behavioral)
					port map(clk		=> s_clk,
								enable	=> '1',
								dataIn	=> s_RFOut2,
								dataOut	=> s_RegisterB);
								
	--Mux4
	mux4: entity work.Mux2N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_ALUSelA,
								input0	=> s_pc,
								input1	=> s_RegisterA,
								muxOut	=> s_mux4);
								
								
	--Mux5
	mux5: entity work.Mux4N(Behavioral)
				generic map(NBITS		=> 32)
					port map(sel		=> s_ALUSelB,
								portA		=> s_RegisterB,
								portB		=> X"00000004",
								portC		=> s_imm32,
								portD		=> s_shift,
								muxOut	=> s_mux5);
								
	--Signal Extend
	ext: entity work.SignExtend(Behavioral)
					port map(dataIn	=> s_imm,
								dataOut	=> s_imm32);
								
	--Left Shifter
	sl: entity work.LeftShifter(Behavioral)
					port map(dataIn	=> s_imm32,
								dataOut	=> s_shift);
								
	--ALU Control
	alu_ctrl: entity work.ALUcontrol(Behavioral)
				port map(ALUop			=> s_ALUop,
							funct			=> s_funct,
							ALUcontrol	=> s_op);
								
	--ALU32
	alu32: entity work.ALU32(Behavioral)
					port map(op			=> s_op,
								inputA	=> s_mux4,
								inputB	=> s_mux5,
								zero		=> s_zero,
								result	=> s_ALUres);
								
	--ALU Out Register
	alu_out: entity work.Register32(Behavioral)
					port map(clk		=> s_clk,
								enable	=> '1',
								dataIn	=> s_ALUres,
								dataOut	=> s_ALUOut);
								
	--Display Unit
	disp: entity work.DisplayUnit(Behavioral)
		generic map(dataPathType	=> MULTI_CYCLE_DP,
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
						
	--LEDS
	LEDR(1 downto 0)	<= s_PCSource;
	LEDR(3 downto 2)	<= s_ALUop;
	LEDR(4) 				<= s_ALUSelA;
	LEDR(6 downto 5)	<= s_ALUSelB;
	LEDR(7)				<= s_RegWrite;
	LEDR(8)				<= s_RegDst;
	LEDG(0)				<= s_PCWrite;
	LEDG(1)				<= s_PCWriteCond;
	LEDG(2)				<= s_IorD;
	LEDG(3)				<= s_MemRead;
	LEDG(4)				<= s_MemWrite;
	LEDG(5)				<= s_IRWrite;
	LEDG(6)				<= s_MemToReg;
							
end Structural;
