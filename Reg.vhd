library ieee;
use ieee.std_logic_1164.all;

entity Reg is
generic (n : integer := 16);
port ( D : in std_logic_vector(n-1 downto 0);
       Rest, Clock : in std_logic;
		 Q : out std_logic_vector(N-1 downto 0)
		 );
end Reg;

architecture Behav of Reg is
begin 
process(Rest, Clock)
begin
if(Rest = '0') then 
Q <= (others => '0');
elsif (Clock'event and Clock = '1') then
Q <= D;
end if;
end process;
end Behav;