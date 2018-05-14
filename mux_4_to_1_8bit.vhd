library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

--Multiplexer da usare per il saturatore. Parallelismo da 8 bit

entity mux_4_to_1_8bit is
	port(
			sel	: in std_logic_vector (1 downto 0);
			y1, y2, y3, y4 		: in signed (7 downto 0);
			y_sat	: out signed (7 downto 0)
		);
end mux_4_to_1_8bit;

architecture behav of mux_4_to_1_8bit is
	begin
		
		process (sel, y1, y2, y3, y4)
			begin
				if (sel= "00") then
					y_sat <= y1;
				elsif(sel = "01") then
					y_sat <= y2;
				elsif( sel = "10") then
					y_sat <= y3;
				else
					y_sat <= y4;
				end if;
		end process;
end behav;