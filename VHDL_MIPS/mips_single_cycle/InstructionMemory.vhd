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

entity InstructionMemory is
	generic(ADDR_BUS_SIZE: positive := 6);
	port(address	: in	std_logic_vector(ADDR_BUS_SIZE - 1 downto 0);
		  readData	: out	std_logic_vector(31 downto 0));
end InstructionMemory;

architecture Behavioral of InstructionMemory is

	constant NUM_WORDS : positive := (2 ** ADDR_BUS_SIZE);
	subtype TData is std_logic_vector(31 downto 0);
	type TMemory is array(0 to NUM_WORDS - 1) of TData;
	constant s_memory : TMemory := (X"2002001A",	--addi $2,$0,0x1A
											  X"2003FFF9",	--addi $3,$0,-7
											  X"00821820",	--add	 $4,$2,$3
											  X"00A21822",	--sub	 $5,$2,$3
											  X"00C21824",	--and	 $6,$2,$3
											  X"00E21825",	--or	 $7,$2,$3
											  X"01021827",	--nor	 $8,$2,$3
											  X"01221826",	--xor	 $9,$2,$3
											  X"0142182A",	--slt	 $10,$2,$3
											  X"28EBFFFE",	--slti $11,$7,-2
											  X"292CFFE7",	--slti $12,$9,-25
											  X"00000000",	--nop
											  others => X"00000000");
	
begin
	
	readData 	<= s_memory(to_integer(unsigned(address)));
	DU_IMdata	<= s_memory(to_integer(unsigned(DU_IMaddr)));

end Behavioral;