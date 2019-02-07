LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY full_adder IS
	PORT (
		Cin, A, B: IN std_logic;
		S, Cout: OUT std_logic
	); 
END;

ARCHITECTURE main OF full_adder IS

	BEGIN
	
	S <= Cin XOR A XOR B;
	
	Cout <= (A AND B) OR (Cin AND B) OR (Cin AND A);
	
END main;