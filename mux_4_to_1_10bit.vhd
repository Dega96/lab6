library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

--Multiplexer da usare per scegliere i dati da far sommare. Parallelismo da 10 bit

entity mux_4_to_1_10bit is
	port(
			sel	: in std_logic_vector (1 downto 0);
			Data_00		: in signed (9 downto 0);
			Data_01		: in signed(9 downto 0);
			Data_10_11	: in signed (9 downto 0);
			y				: out signed (9 downto 0)
		);
end mux_4_to_1_10bit;

architecture behav of mux_4_to_1_10bit is
	begin
		
		process (sel, Data_00, Data_01, Data_10_11)
			begin
				if (sel= "00") then
					y <= Data_00;
				elsif(sel = "01") then
					y <= Data_01;
				elsif( sel = "10") then
					y <= Data_10_11;
				else
					y <= Data_10_11;
				end if;
		end process;
end behav;