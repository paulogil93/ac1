--------------------------------------------
-- Paulo Gil
-- paulogil@ua.pt
-- AC1-2017
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Mux2N is
	generic(NBITS : positive := 32);
	port(sel		: in	std_logic;
		  input0	: in	std_logic_vector(NBITS-1 downto 0);
		  input1 : in	std_logic_vector(NBITS-1 downto 0);
		  muxOut : out	std_logic_vector(NBITS-1 downto 0));
end Mux2N;

architecture Behavioral of Mux2N is
begin
	
	muxOut <= input0 when (sel = '0') else input1;

end Behavioral;
		  