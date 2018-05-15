library IEEE;
use IEEE.std_logic_1164.all;

entity Decoder is
	port(
			EN					: in std_logic;
			D	: out std_logic_vector( 3 downto 0);
			sel				: in std_logic_vector( 1 downto 0)
		 );
end Decoder;

Architecture behav of Decoder is 

	begin
		process(EN, sel)
			begin
				if(sel = "00") then					
					D <= "0001";
				elsif (sel = "01") then
					D <= "0010";
				elsif (sel = "10") then
					D <= "0100";
				else
					D <= "1000";
				end if;
			end process;
end behav;