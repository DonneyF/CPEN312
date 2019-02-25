LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Mod6SynchrCounter IS
	PORT (
		Clock, Reset, Load: IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		LOAD_VAL, RESET_VAL: IN STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END Mod6SynchrCounter;

ARCHITECTURE Behavior OF Mod6SynchrCounter IS
	COMPONENT T_FlipFlop IS
		PORT (
			T, Reset, Load, CLK : IN std_logic;
			RESET_VAL, LOAD_VAL: IN STD_LOGIC;
			Q : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL D_TEMP: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL Q_TEMP: STD_LOGIC_VECTOR(2 downto 0);
	
BEGIN

	D_TEMP(0) <= '1';
	D_TEMP(1) <= Q_TEMP(0) AND NOT Q_TEMP(2);
	D_TEMP(2) <= Q_TEMP(0) AND (Q_TEMP(1) OR Q_TEMP(2));
	
	-- Create the 8 adders and assign their pins
	-- Default carry intialization
	FF_f: for i in 0 to 2 generate
		FF_i: T_FlipFlop PORT MAP (D_TEMP(i), Reset, Load, Clock, RESET_VAL(i), LOAD_VAL(i), Q_TEMP(i));
	end generate;
	
	Q <= Q_TEMP;
	
END Behavior;