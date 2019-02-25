LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TwoBitBCDRippleCounter IS
	PORT (
		KEY0, CLK_50 : IN STD_LOGIC;
		MSD, LSD : OUT STD_LOGIC_VECTOR (0 TO 6);
		MAX_MAJOR_DIGIT, MAX_MINOR_DIGIT: IN INTEGER
	);
END TwoBitBCDRippleCounter;

ARCHITECTURE MAIN OF TwoBitBCDRippleCounter IS
	SIGNAL ClkFlag : STD_LOGIC;
	SIGNAL Internal_Count : STD_LOGIC_VECTOR(28 DOWNTO 0);
	SIGNAL HighDigit, LowDigit : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MSD_7SEG, LSD_7SEG : STD_LOGIC_VECTOR(0 TO 6);

BEGIN
	LSD <= LSD_7SEG;
	MSD <= MSD_7SEG;
	PROCESS (CLK_50)
	BEGIN
		IF (CLK_50'EVENT AND CLK_50 = '1') THEN
			IF Internal_Count < 25000000 THEN
				Internal_Count <= Internal_Count + 1;
			ELSE
				Internal_Count <= (OTHERS => '0');
				ClkFlag <= NOT ClkFlag;
			END IF;
		END IF;
	END PROCESS;
 
	PROCESS (ClkFlag, KEY0)
		BEGIN
			IF (KEY0 = '0') THEN -- reset
				LowDigit <= "0000";
				HighDigit <= "0000";
			ELSIF (ClkFlag'EVENT AND ClkFlag = '1') THEN
				IF (LowDigit = MAX_MINOR_DIGIT AND HighDigit = MAX_MAJOR_DIGIT) THEN
					LowDigit <= "0000";
					HighDigit <= "0000";
				ELSIF (LowDigit = 9) THEN
					HighDigit <= HighDigit + '1';
					LowDigit <= "0000";
				ELSE
					LowDigit <= LowDigit + '1';
				END IF;
			END IF;
	END PROCESS;

	PROCESS (LowDigit, HighDigit)
		BEGIN
			CASE LowDigit IS
				WHEN "0000" => LSD_7SEG <= "0000001";
				WHEN "0001" => LSD_7SEG <= "1001111";
				WHEN "0010" => LSD_7SEG <= "0010010";
				WHEN "0011" => LSD_7SEG <= "0000110";
				WHEN "0100" => LSD_7SEG <= "1001100";
				WHEN "0101" => LSD_7SEG <= "0100100";
				WHEN "0110" => LSD_7SEG <= "0100000";
				WHEN "0111" => LSD_7SEG <= "0001111";
				WHEN "1000" => LSD_7SEG <= "0000000";
				WHEN "1001" => LSD_7SEG <= "0000100";
				WHEN OTHERS => LSD_7SEG <= "1111111";
			END CASE;

			CASE HighDigit IS
				WHEN "0000" => MSD_7SEG <= "0000001";
				WHEN "0001" => MSD_7SEG <= "1001111";
				WHEN "0010" => MSD_7SEG <= "0010010";
				WHEN "0011" => MSD_7SEG <= "0000110";
				WHEN "0100" => MSD_7SEG <= "1001100";
				WHEN "0101" => MSD_7SEG <= "0100100";
				WHEN "0110" => MSD_7SEG <= "0100000";
				WHEN "0111" => MSD_7SEG <= "0001111";
				WHEN "1000" => MSD_7SEG <= "0000000";
				WHEN "1001" => MSD_7SEG <= "0000100";
				WHEN OTHERS => MSD_7SEG <= "1111111";
			END CASE;
	END PROCESS;
END MAIN;