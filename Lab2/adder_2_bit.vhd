LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY adder_2_bit IS
	PORT (
		-- Adder Logic
		Cin: IN std_logic;
		-- A, B: IN std_logic_vector(1 downto 0);
 		Cout: OUT std_logic;
		-- Display/control
		KEY0, KEY1, KEY2 : in STD_LOGIC;
		DISPLAY: OUT std_logic_vector(0 to 1);
		SWITCHES: IN std_logic_vector(0 to 1)
	); 
END;

ARCHITECTURE ripple_2_arch OF adder_2_bit IS

	COMPONENT full_adder
		PORT(
			Cin, A, B: IN std_logic; 
			S, Cout: OUT std_logic
			);
	END COMPONENT;

	SIGNAL t1: std_logic; -- Temporary carry signal
	-- Signals for values
	SIGNAL A, B: std_logic_vector(0 to 1);
	SIGNAL S: std_logic_vector(0 to 1);

	BEGIN
		-- Create two full adders and map their pins.
		FA1: full_adder PORT MAP ('0', A(0), B(0), S(0), t1);
		FA2: full_adder PORT MAP (t1, A(1), B(1), S(1), Cout);
		
	PROCESS (KEY0, KEY1, KEY2)
    begin
		-- Assign the data conditionally. (Implicit latch)
        if KEY0 = '0' then
				A <= SWITCHES;
        elsif KEY1 = '0' then
            B <= SWITCHES;
		  elsif KEY2 = '0' then
				DISPLAY <= S;
        else
            DISPLAY <= SWITCHES;
        end if;
    end process;
END ripple_2_arch;