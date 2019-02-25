LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY BCDSynchrCounter IS
	PORT (
		Clock, Reset, Load: IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		LOAD_VAL, RESET_VAL: IN STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END BCDSynchrCounter;

ARCHITECTURE Behavior OF BCDSynchrCounter IS
	COMPONENT T_FlipFlop IS
		PORT (
			T, Reset, Load, CLK : IN STD_LOGIC;
			RESET_VAL, LOAD_VAL: IN STD_LOGIC;
			Q : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL D_TEMP: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL Q_TEMP: STD_LOGIC_VECTOR(3 downto 0);
	
BEGIN

	D_TEMP(0) <= '1';
	D_TEMP(1) <= Q_TEMP(0) AND NOT Q_TEMP(3);
	D_TEMP(2) <= Q_TEMP(0) AND Q_TEMP(1);
	D_TEMP(3) <= (Q_TEMP(0) AND Q_TEMP(1) AND Q_TEMP(2)) OR (Q_TEMP(0) AND Q_TEMP(3));
	
	-- Create the 8 adders and assign their pins
	-- Default carry intialization
	FF_f: for i in 0 to 3 generate
		FF_i: T_FlipFlop PORT MAP (D_TEMP(i), Reset, Load, Clock, RESET_VAL(i), LOAD_VAL(i), Q_TEMP(i));
	end generate;
	
	Q <= Q_TEMP;
	
END Behavior;