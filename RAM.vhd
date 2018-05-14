library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity RAM is 
port (Locate : in std_logic_vector (7 downto 0);
      Input : in signed(7 downto 0);
		Output : out signed(7 downto 0);
		En_0, W_0, R_0, clock_0 : in std_logic);
end RAM;

architecture Struct of RAM is
signal dt : std_logic_vector(7 downto 0);
signal Cn_0, W, O, clock : std_logic;
signal dt_in, dt_out : signed(7 downto 0);
signal addr : integer range 0 to 256;

begin 
p0 : process(addr, dt_in, Cn_0, W, O, clock, dt_out) is
type ram_array is array (0 to 256 ) of std_logic_vector(7 downto 0);
variable mem: ram_array;
begin
dt_in <= (others => 'Z');
dt_out <= (others => 'Z');
if Cn_0 ='1' then
if O = '1' then
dt_out <= signed(mem(addr));
elsif ((not(W) and clock) = '1') then
mem(addr) := dt;

end if;
end if;
end process p0;
Cn_0 <= En_0;
W <= W_0;
O <= R_0;
clock <= clock_0;
dt_in <= Input;
dt <= std_logic_vector(dt_in);
Output <= dt_out;
addr <= to_integer(unsigned(Locate));
end Struct;