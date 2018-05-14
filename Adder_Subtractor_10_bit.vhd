library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Sommatore con parallelismo da 10 bit
entity Adder_Subtractor_10_bit is
generic (n : integer := 10);
	port(
			c_in : IN std_logic;
			a, b : IN signed (n-1 downto 0);
			y	  : Out signed (n-1 downto 0)
		 );
end Adder_Subtractor_10_bit;

architecture behav of Adder_Subtractor_10_bit is

begin
	process (a,b, c_in)
		begin	
			if(c_in = '1') then
				y<= a-b;
			else 
				y <= a+b;
			end if;   
		end process;
 
end behav;