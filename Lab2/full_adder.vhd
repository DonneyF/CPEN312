LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY full_adder IS
	PORT (
		Cin, A, B, M: IN std_logic;
		S, Cout: OUT std_logic
	); 
END;

ARCHITECTURE main OF full_adder IS

	BEGIN
		
	S <= Cin XOR A XOR (B XOR M);
	Cout <= (A AND B) OR (Cin AND B) OR (Cin AND A);
	
END main;