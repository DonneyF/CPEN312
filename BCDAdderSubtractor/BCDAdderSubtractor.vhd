LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY BCDadderSubtractor IS
	PORT (
		-- Display/control
		KEY0, KEY1, KEY2 : in STD_LOGIC;
		--DISPLAY: OUT std_logic_vector(7 downto 0);
		SevSeg1, SevSeg2: OUT std_logic_vector(0 to 6);
		ADD_SUB_TOGGLE: in STD_LOGIC;
		OVERFLOW: OUT STD_LOGIC;
		SWITCHES: IN std_logic_vector(7 downto 0)
	); 
END;

ARCHITECTURE main OF BCDadderSubtractor IS
	
	-- Temporary carry signal
	SIGNAL carry: std_logic_vector(1 downto 0) := "00";
	-- Signals for values
	SIGNAL A, B: std_logic_vector(7 downto 0);
	SIGNAL S: std_logic_vector(7 downto 0);
	SIGNAL OUTVAL: std_logic_vector(7 downto 0);
	
	COMPONENT bcd_addsub
		PORT(
			a, b : IN std_logic_vector(3 DOWNTO 0);
			sub : IN std_logic; -- 1 to subtract
			carry_in : IN std_logic;
			sum : OUT std_logic_vector(3 DOWNTO 0);
			carry : OUT std_logic
			);
	END COMPONENT;
	
	COMPONENT BCDto7Seg
		PORT(
			BCD : in STD_LOGIC_VECTOR (3 downto 0);
			DISPLAY : out STD_LOGIC_VECTOR (0 to 6)
			);
	END COMPONENT;

BEGIN

	BCDAS_1: bcd_addsub PORT MAP(A(3 downto 0), B(3 downto 0), ADD_SUB_TOGGLE, ADD_SUB_TOGGLE, S(3 downto 0), carry(0));
	BCDAS_2: bcd_addsub PORT MAP(A(7 downto 4), B(7 downto 4), ADD_SUB_TOGGLE, carry(0), S(7 downto 4), carry(1));
	
	OVERFLOW <= CARRY(1);
	
	BCDDisplay1: BCDto7Seg PORT MAP(OUTVAL(3 downto 0), SevSeg1);
	BCDDisplay2: BCDto7Seg PORT MAP(OUTVAL(7 downto 4), SevSeg2);
	
	PROCESS (KEY0, KEY1, KEY2)
	begin
		-- Assign the data conditionally. (Implicit latch)
		if KEY1 = '0' then
			A <= SWITCHES;
		elsif KEY0 = '0' then
			B <= SWITCHES;
		elsif KEY2 = '0'then
			OUTVAL <= S;
		else
			OUTVAL <= SWITCHES;
		end if;
	 end process;
	
END main;