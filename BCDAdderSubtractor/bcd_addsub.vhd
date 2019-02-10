LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bcd_addsub IS
	PORT (
		a, b : IN std_logic_vector(3 DOWNTO 0);
		sub : IN std_logic; -- 1 to subtract
		carry_in : IN std_logic;
		sum : OUT std_logic_vector(3 DOWNTO 0);
		carry : OUT std_logic
	);
END bcd_addsub;

ARCHITECTURE a OF bcd_addsub IS
	SIGNAL sum_temp : std_logic_vector(4 DOWNTO 0);
	SIGNAL sum_temp_adjs : std_logic_vector(4 DOWNTO 0);
	SIGNAL b_temp : std_logic_vector(4 DOWNTO 0);
	
BEGIN

	PROCESS (b, sub) IS
	BEGIN
		--- 9's compliment selector
		IF sub = '1' THEN
			CASE b IS
				WHEN "0000" => b_temp <= "01001";
				WHEN "0001" => b_temp <= "01000";
				WHEN "0010" => b_temp <= "00111";
				WHEN "0011" => b_temp <= "00110";
				WHEN "0100" => b_temp <= "00101";
				WHEN "0101" => b_temp <= "00100";
				WHEN "0110" => b_temp <= "00011";
				WHEN "0111" => b_temp <= "00010";
				WHEN "1000" => b_temp <= "00001";
				WHEN "1001" => b_temp <= "00000";
				WHEN OTHERS => b_temp <= "00000";
			END CASE;
		ELSE
			b_temp <= ('0' & b);
		END IF;
	END PROCESS;

	PROCESS (a, b_temp, sum_temp, carry_in, sum_temp_adjs)
		BEGIN
			sum_temp <= ('0' & a) + b_temp + ("0000" & carry_in);
			sum_temp_adjs <= sum_temp + "00110";
			IF (sum_temp > 9) THEN
				carry <= '1';
				sum <= sum_temp_adjs(3 DOWNTO 0);
			ELSE
				carry <= '0';
				sum <= sum_temp(3 DOWNTO 0);
			END IF;
		END PROCESS;
END a;