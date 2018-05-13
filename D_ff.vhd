library ieee;
use ieee.std_logic_1164.all;

entity D_ff is
port ( D, Rest, Clock : in std_logic;
       Q : out std_logic);
end D_ff;

architecture Behav of D_ff is
begin 
process(Rest, Clock)
begin
if (Rest = '0') then
Q <= '0';
elsif (Clock'event and Clock = '1') then
Q <= D;
end if;
end process;
end Behav;