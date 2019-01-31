library ieee;
use ieee.std_logic_1164.all;

entity Lab2Part1 is
	port
	(
		-- Input ports
        SWITCHES : in STD_LOGIC_VECTOR (0 to 7);
		  KEY0, KEY1, KEY2 : in STD_LOGIC;
		-- Output ports
		DISPLAY : out STD_LOGIC_VECTOR (0 to 7)
	);
end Lab2Part1;

architecture BinaryAdder of Lab2Part1 is
	-- Declarations (optional)
    --signal switches_in : STD_LOGIC_VECTOR (0 to 7) := "00000000";
	--signal leds_out: STD_LOGIC_VECTOR (0 to 7);

    begin
    -- Get the inputs and assign the outputs
    process (KEY0, KEY1, KEY2)
	 -- Define variables to store our data
	 variable KEY0_ARR : STD_LOGIC_VECTOR (0 to 7);
	 variable KEY1_ARR : STD_LOGIC_VECTOR (0 to 7);
    begin
		-- Assign the data
        if KEY0 = '0' then
				KEY0_ARR := SWITCHES;
        elsif KEY1 = '0' then
            KEY1_ARR := SWITCHES;
		  elsif KEY2 = '0' then
				DISPLAY <= KEY0_ARR AND KEY1_ARR;
        else
            DISPLAY <= SWITCHES;
        end if;
    end process;
end BinaryAdder;