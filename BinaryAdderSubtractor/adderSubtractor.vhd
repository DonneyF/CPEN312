LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY adderSubtractor IS
	PORT (
		-- Adder Logic
		--Cin: IN std_logic;
 		Cout: OUT std_logic;
		-- Display/control
		KEY0, KEY1, KEY2 : in STD_LOGIC;
		DISPLAY: OUT std_logic_vector(7 downto 0);
		ADD_SUB_TOGGLE: in STD_LOGIC;
		SWITCHES: IN std_logic_vector(7 downto 0)
	); 
END;

ARCHITECTURE main OF adderSubtractor IS

	COMPONENT full_adder
		PORT(
			Cin, A, B: IN std_logic; 
			S, Cout: OUT std_logic
			);
	END COMPONENT;
	
	-- Temporary carry signal
	SIGNAL carry: std_logic_vector(8 downto 0) := "000000000";
	-- Signals for values
	SIGNAL A, B: std_logic_vector(7 downto 0);
	SIGNAL S: std_logic_vector(7 downto 0);

	BEGIN
		-- Create the 8 adders and assign their pins
		-- Default carry intialization
		carry(0) <= ADD_SUB_TOGGLE;
		Cout <= carry(8);
		FA_f: for i in 0 to 7 generate
			FA_i: full_adder PORT MAP (carry(i), A(i), B(i) XOR ADD_SUB_TOGGLE, S(i), carry(i+1));
		end generate;
		
		PROCESS (KEY0, KEY1, KEY2)
		begin
			-- Assign the data conditionally. (Implicit latch)
			  if KEY1 = '0' then
					A <= SWITCHES;
			  elsif KEY0 = '0' then
					B <= SWITCHES;
			  elsif KEY2 = '0'then
					DISPLAY <= S;
			  else
					DISPLAY <= SWITCHES;
			  end if;
		 end process;
	
END main;