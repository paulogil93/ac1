library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.DisplayUnit_pkg.all;

entity ControlUnit is
	port(clock			: in	std_logic;
		  reset			: in	std_logic;
		  opCode			: in	std_logic_vector(5 downto 0);
		  PCWrite		: out std_logic;
		  IRWrite		: out std_logic;
		  IorD			: out std_logic;
		  PCSource		: out std_logic_vector(1 downto 0);
		  RegDst			: out std_logic;
		  PCWriteCond	: out std_logic;
		  MemRead		: out std_logic;
		  MemWrite		: out std_logic;
		  MemToReg		: out std_logic;
		  ALUSelA		: out std_logic;
		  ALUSelB		: out	std_logic_vector(1 downto 0);
		  RegWrite		: out std_logic;
		  ALUop			: out	std_logic_vector(1 downto 0));
end ControlUnit;

architecture Behavioral of ControlUnit is
	
	type TState is (E0, E1, E2, E3, E4, E5, E6,
						 E7, E8, E9, E10, E11);
	signal CS, NS : TState;
	
begin
	--Processo sincrono da ME
	process(clock)
	begin
		if(rising_edge(clock)) then
			if(reset = '1') then
				CS <= E0;
			else
				CS <= NS;
			end if;
		end if;
	end process;
	
	--Processo combinatorio da ME
	process(CS,opCode)
	begin
		PCWrite		<= '0';
		IRWrite		<= '0';
		IorD			<= '0';
		RegDst		<= '0';
		PCWriteCond	<= '0';
		MemRead		<= '0';
		MemWrite		<= '0';
		MemToReg		<= '0';
		RegWrite		<= '0';
		PCSource		<= "00";
		ALUop			<= "00";
		ALUSelA		<= '0';
		ALUSelB		<= "00";
		NS				<= CS;
		case CS is
			when E0 =>
				MemRead <= '1';
				PCWrite <= '1';
				IRWrite <= '1';
				ALUSelB <= "01";
				NS		  <= E1;
			when E1 =>
				ALUSelB <= "11";
				if(opCode = "000000") then NS <= E6;		--R-Type
				elsif(opCode = "100011" or opCode = "101011" or
						opCode = "001000") then
						NS <= E2;									--LW,SW,ADDI
				elsif(opCode = "001010") then NS <= E8;	--SLTI
				elsif(opCode = "000100") then NS <= E10;	--BEQ
				elsif(opCode = "000010") then NS <= E11;	--J
				end if;
			when E2 =>
				ALUSelA	<= '1';
				ALUSelB	<= "10";
				if(opCode = "100011") then NS <= E3;			--LW
				elsif(opCode = "101011") then NS <= E5;		--SW
				elsif(opCode = "001000") then NS <= E9;		--ADDI
				end if;
			when E3 =>
				MemRead	<= '1';
				IorD		<= '1';
				NS			<= E4;
			when E4 =>
				RegWrite	<= '1';
				MemToReg <= '1';
				NS			<= E0;
			when E5 =>
				MemWrite <= '1';
				IorD		<= '1';
				NS			<= E0;
			when E6 =>
				ALUSelA	<= '1';
				ALUop		<= "10";
				NS <= E7;
			when E7 =>
				RegWrite <= '1';
				RegDst	<= '1';
				NS <= E0;
			when E8 =>
				ALUSelA	<= '1';
				ALUSelB	<= "10";
				ALUop		<= "11";
				NS			<= E9;
			when E9 =>
				RegWrite <= '1';
				NS			<= E0;
			when E10 =>
				ALUSelA	<= '1';
				ALUop		<= "01";
				PCWriteCond <= '1';
				PCSource	<= "01";
				NS			<= E0;
			when E11 =>
				PCWrite	<= '1';
				PCSource	<= "01";
				NS			<= E0;
			when others =>
				NS			<= E0;
		end case;
	end process;
	
	DU_CState <= "00000" when (CS = E0) else
					 "00001" when (CS = E1) else
					 "00010" when (CS = E2) else
					 "00011" when (CS = E3) else
					 "00100" when (CS = E4) else
					 "00101" when (CS = E5) else
					 "00110" when (CS = E6) else
					 "00111" when (CS = E7) else
					 "01000" when (CS = E8) else
					 "01001" when (CS = E9) else
					 "01010" when (CS = E10) else
					 "01011" when (CS = E11) else
					 "11111";
					 
end Behavioral;