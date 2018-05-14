library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity counter_12_bit_sincrono is
	generic ( N : integer:=12);
	port 
		(
		Cnt_EN, CLK, Clear: in std_logic; 
	   Q: buffer unsigned(N-1 downto 0)
		);
		end counter_12_bit_sincrono;
		
architecture struct of counter_12_bit_sincrono is

	begin
		process (clk, clear, cnt_en)
			begin
				if((CLK'event and CLK='1') and Cnt_En ='1') then
					if (clear = '1') then
						Q <= (others => '0');
					elsif(Cnt_EN = '1') then
                  Q <= Q + 1;
					end if;
            end if;
			end process;
		
	end struct;