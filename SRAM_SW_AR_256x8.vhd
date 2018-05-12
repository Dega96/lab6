library ieee;
use ieee.std_logic_1164.all;

entity SRAM_SW_AR_256x8 is
port( Addr : in std_logic_vector (7 downto 0);
      In_data : in std_logic_vector(7 downto 0);
		Out_data : out std_logic_vector(7 downto 0);
		En, W, R, clock_1 : in std_logic
		);
end SRAM_SW_AR_256x8;
architecture Struct of SRAM_SW_AR_256x8 is
component RAM is
port (Locate : in std_logic_vector (7 downto 0);
      Input: in std_logic_vector(7 downto 0);
		Output : out std_logic_vector(7 downto 0);
		En_0, W_0, R_0, clock_0 : in std_logic);
end component;
begin
Mem : RAM port map (Addr, In_data, Out_data, En, W, R, clock_1);
end Struct; 	