LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY adderSubtractorArithmetic IS
	PORT (
		-- Display/control
		KEY0, KEY1, KEY2 : in STD_LOGIC;
		DISPLAY: OUT std_logic_vector(7 downto 0);
		ADD_SUB_TOGGLE: in STD_LOGIC;
		SWITCHES: IN std_logic_vector(7 downto 0)
	); 
END;

ARCHITECTURE main OF adderSubtractorArithmetic IS
	
	SIGNAL A, B, S : std_logic_vector(7 downto 0);

BEGIN
	
	process(ADD_SUB_TOGGLE)
	begin
		if ADD_SUB_TOGGLE = '0' THEN
			S <= A + B;
		ELSE
			S <= A - B;
		END IF;
	end process;
	
	PROCESS (KEY0, KEY1, KEY2)
	begin
		-- Assign the data conditionally. (Implicit latch)
		  if KEY0 = '0' then
				A <= SWITCHES;
		  elsif KEY1 = '0' then
				B <= SWITCHES;
		  elsif KEY2 = '0'then
				DISPLAY <= S;
		  else
				DISPLAY <= SWITCHES;
		  end if;
	 end process;
	
END main;