LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY Clock IS
	PORT (
		KEY0, KEY1, KEY2 : in STD_LOGIC;
		SevSeg0, SevSeg1, SevSeg2, SevSeg3, SevSeg4, SevSeg5: OUT STD_LOGIC_VECTOR(0 to 6);
		SWITCHES: IN STD_LOGIC_VECTOR(7 downto 0);
		OSCILLATOR: IN STD_LOGIC
	); 
END;

ARCHITECTURE main OF Clock IS
	COMPONENT BCDSynchrCounter IS
		PORT (
			Clock, Reset, Load: IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			RESET_VAL, LOAD_VAL: IN STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Mod6SynchrCounter IS
		PORT (
			Clock, Reset, Load: IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			RESET_VAL, LOAD_VAL: IN STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Mod13SynchrCounter IS
		PORT (
			Clock, Reset, Load: IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
			RESET_VAL, LOAD_VAL: IN STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT BCDto7Seg
		PORT(
			BCD : in STD_LOGIC_VECTOR (3 downto 0);
			DISPLAY : out STD_LOGIC_VECTOR (0 to 6)
		);
	END COMPONENT;
	
	SIGNAL Q_SECONDS: STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	SIGNAL Q_MINUTES: STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	SIGNAL Q_HOURS: STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	
	SIGNAL LOAD_VALUE: STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";

	SIGNAL CLOCK: STD_LOGIC;
	SIGNAL Internal_Count: STD_LOGIC_VECTOR(28 DOWNTO 0);
	SIGNAL COUNT: STD_LOGIC := '0';
	
	SIGNAL LOAD_SECONDS, LOAD_MINUTES, LOAD_HOURS: STD_LOGIC := '0';
	SIGNAL RESET_HOURS: STD_LOGIC;
	
	SIGNAL q0, q1, q2 : std_logic := '0';

BEGIN
	
	-- Create display and counters for seconds
	ADisp0: BCDto7Seg PORT MAP(Q_SECONDS(3 DOWNTO 0), SevSeg0);
	ADisp1: BCDto7Seg PORT MAP(Q_SECONDS(7 DOWNTO 4), SevSeg1);
	
	SECONDS_0: BCDSynchrCounter PORT MAP(CLOCK, '0', LOAD_SECONDS, Q_SECONDS(3 DOWNTO 0), "0000", LOAD_VALUE(3 DOWNTO 0));
	SECONDS_1: Mod6SynchrCounter PORT MAP(NOT Q_SECONDS(3), '0', LOAD_SECONDS, Q_SECONDS(6 DOWNTO 4), "000", LOAD_VALUE(6 DOWNTO 4));
	
	-- Create display and counters for minutes
	ADisp2: BCDto7Seg PORT MAP(Q_MINUTES(3 DOWNTO 0), SevSeg2);
	ADisp3: BCDto7Seg PORT MAP(Q_MINUTES(7 DOWNTO 4), SevSeg3);
	
	MINUTES_0: BCDSynchrCounter PORT MAP(NOT Q_SECONDS(6), '0', LOAD_MINUTES, Q_MINUTES(3 DOWNTO 0), "0000", LOAD_VALUE(3 DOWNTO 0));
	MINUTES_1: Mod6SynchrCounter PORT MAP(NOT Q_MINUTES(3), '0', LOAD_MINUTES, Q_MINUTES(6 DOWNTO 4), "000", LOAD_VALUE(6 DOWNTO 4));
	
	-- Create display and counters for hours
	ADisp4: BCDto7Seg PORT MAP(Q_HOURS(3 DOWNTO 0), SevSeg4);
	ADisp5: BCDto7Seg PORT MAP(Q_HOURS(7 DOWNTO 4), SevSeg5);
	
	-- Reset to 12:00
	HOURS: Mod13SynchrCounter PORT MAP(NOT Q_MINUTES(6), RESET_HOURS, LOAD_HOURS, Q_HOURS(4 DOWNTO 0), "00011", LOAD_VALUE(4 DOWNTO 0));
	
	LOAD_VALUE <= SWITCHES;
	
	-- Cycle the clock every 25E6 instances.
	PROCESS (OSCILLATOR)
	BEGIN
		IF (OSCILLATOR'EVENT AND OSCILLATOR = '1') THEN
			IF Internal_Count < 5000000 THEN
				Internal_Count <= Internal_Count + 1;
			ELSE
				Internal_Count <= (OTHERS => '0');
				CLOCK <= NOT CLOCK;
			END IF;
		END IF;
	END PROCESS;
	
	-- Start up reset
	PROCESS (Internal_Count)
	BEGIN
		IF Internal_Count < 25000000 THEN
			RESET_HOURS <= '0';
		ELSE
			RESET_HOURS <= '1';
		END IF;
	END PROCESS;

	-- Set values
	PROCESS (KEY0, KEY1, KEY2)
	begin
		-- Assign the data conditionally. (Implicit latch)
		IF KEY0 = '0' then
			LOAD_SECONDS <= '1';
		elsif KEY1 = '0' then
			LOAD_MINUTES <= '1';
		elsif KEY2 = '0' then
			LOAD_HOURS <= '1';
		ELSE
			LOAD_HOURS <= '0';
			LOAD_MINUTES <= '0';
			LOAD_SECONDS <= '0';
		end if;
	 end process;
END main;