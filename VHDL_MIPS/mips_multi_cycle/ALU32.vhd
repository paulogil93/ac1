--------------------------------------------
-- Paulo Gil
-- paulogil@ua.pt
-- AC1-2017
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library work;
use work.DisplayUnit_pkg.all;

entity ALU32 is
	port(op		: in	std_logic_vector(2 downto 0);
		  inputA	: in	std_logic_vector(31 downto 0);
		  inputB	: in	std_logic_vector(31 downto 0);
		  result	: out	std_logic_vector(31 downto 0);
		  zero	: out std_logic);
end ALU32;

architecture Behavioral of ALU32 is

	signal s_res		:	std_logic_vector(31 downto 0);
	signal s_inputB	:	unsigned(31 downto 0);
	
begin

	s_inputB <= not(unsigned(inputB)) + 1 when (op = "110") else
					unsigned(inputB);
	
	process(op, inputA, inputB, s_inputB)
	begin
		case op is
			when "000" => --AND
				s_res <= inputA and inputB;
			when "001" => --OR
				s_res <= inputA or inputB;
			when "010" => --ADD
				s_res <= std_logic_vector(unsigned(inputA) + s_inputB);
			when "110" => --SUB
				s_res <= std_logic_vector(unsigned(inputA) + s_inputB);
			when "111" => --SLT
				if(signed(inputA) < signed(inputB)) then
					s_res <= X"00000001";
				else
					s_res <= (others => '0');
				end if;
			when others =>
				s_res <= (others => '-');
		end case;
	end process;
	
	result	<= s_res;
	zero	<= '1' when (s_res = X"00000001") else '0';
	DU_IMdata <= s_res;
	
end Behavioral;