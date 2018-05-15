library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SRAM_SW_AR_256x8 is
port( Addr : in std_logic_vector (7 downto 0);
--      In_data : in signed(7 downto 0);
--		Out_data : out signed(7 downto 0);
      Data_A: inout signed(7 downto 0);
		En, W, R, clock_1 : in std_logic
		);
end SRAM_SW_AR_256x8;
architecture Struct of SRAM_SW_AR_256x8 is
component RAM is
port (Address : in std_logic_vector (7 downto 0);
      --Input : in signed(7 downto 0);
		--Output : inout signed(7 downto 0);
		Data : inout signed(7 downto 0);
		En_0, W_0, R_0, clock : in std_logic);
end component;
begin
Mem_m : RAM port map (Addr, Data_A, En, W, R, clock_1);
end Struct; 	
