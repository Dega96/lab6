library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is 
port (Address : in std_logic_vector (7 downto 0);
      --Input : in signed(7 downto 0);
		--Output : inout signed(7 downto 0);
		Data : inout signed(7 downto 0);
		En_0, W_0, R_0, clock : in std_logic);
end RAM;

architecture Struct of RAM is

--signal Cn_0, W, O, clock : std_logic;
--signal dt_in, dt_out : signed(7 downto 0);
--signal dt: signed(7 downto 0);
--signal addr : integer range 0 to 255;

begin 
p0 : process(Address, Data, En_0, W_0, R_0, clock) is
     type ram_array is array (0 to 255 ) of signed(7 downto 0);
     variable  mem : ram_array;

begin
--dt_in <= (others => 'Z');
--dt_out <= (others => 'Z');
Data <= (others=> 'Z');
if En_0 ='1' then
if R_0 = '1' then
--dt_out <= mem(addr);
Data <= mem(to_integer(unsigned(Address)));
elsif ((not(W_0) and clock) = '1') then
mem(to_integer(unsigned(Address))) := Data;

end if;
end if;
end process p0;
--Cn_0 <= En_0;
--W <= W_0;
--O <= R_0;
--clock <= clock_0;
--dt_in <= Input;
--Output <= dt_out;
--addr <= to_integer(unsigned(Locate));
end Struct;
