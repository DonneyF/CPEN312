LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Synchronous Positive edge T Flip-Flop with Reset
ENTITY T_FlipFlop IS
	PORT (
		T, Reset, Load, CLK : IN STD_LOGIC;
		RESET_VAL, LOAD_VAL: IN STD_LOGIC;
		Q : OUT STD_LOGIC
	);
END T_FlipFlop;

ARCHITECTURE MAIN OF T_FlipFlop IS 
	SIGNAL temp : std_logic;
BEGIN
	PROCESS (Reset, Load, CLK, RESET_VAL, LOAD_VAL)
	BEGIN
		IF Reset = '1' THEN 
			temp <= RESET_VAL; 
		ELSIF Load = '1' THEN
			temp <= LOAD_VAL;
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			temp <= T XOR temp;
		END IF;
	END PROCESS;
	Q <= temp; 
END MAIN;