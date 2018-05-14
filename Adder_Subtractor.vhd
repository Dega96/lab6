library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder_Subtractor is
	port(
			c_in : IN std_logic;
			a, b : IN signed (9 downto 0);
			y	  : Out signed (9 downto 0)
		 );
end Adder_Subtractor;

architecture behav of Adder_Subtractor is

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