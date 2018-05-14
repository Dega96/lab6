library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Registro con parallelismo da 18 bit
entity Reg_18_bit is
generic (n : integer := 18);
port ( D : in signed(n-1 downto 0);
       Rest, Clock, EN : in std_logic;
		 Q : out signed(N-1 downto 0)
		 );
end Reg_18_bit;

architecture Behav of Reg_18_bit is
begin 
process(Rest, Clock, EN)
begin
if(Rest = '0') then 
Q <= (others => '0');
elsif (Clock'event and Clock = '1' and EN ='1') then
Q <= D;
end if;
end process;
end Behav;