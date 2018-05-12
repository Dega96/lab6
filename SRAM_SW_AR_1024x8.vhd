library ieee;
use ieee.std_logic_1164.all;

entity SRAM_SW_AR_1024x8 is
port( AD : in std_logic_vector (7 downto 0);
      DATA_INPUT : in std_logic_vector(7 downto 0);
		DATA_OUT_A, DATA_OUT_B, DATA_OUT_C, DATA_OUT_D : out std_logic_vector(7 downto 0);
		CS_A : in std_logic_vector(3 downto 0);
		WR_A, RD_A, CLK_A : in std_logic
		);
end SRAM_SW_AR_1024x8;

architecture Struct of SRAM_SW_AR_1024x8 is
component SRAM_SW_AR_256x8 is
port( Addr : in std_logic_vector (7 downto 0);
      In_data : in std_logic_vector(7 downto 0);
		Out_data : out std_logic_vector(7 downto 0);
		En, W, R, clock_1 : in std_logic
		);
end component;
begin 
Ram_0 : SRAM_SW_AR_256X8 port map (AD, DATA_INPUT, DATA_OUT_A, CS_A(0), WR_A, RD_A, CLK_A);
Ram_1 : SRAM_SW_AR_256X8 port map (AD, DATA_INPUT, DATA_OUT_B, CS_A(1), WR_A, RD_A, CLK_A);
Ram_2 : SRAM_SW_AR_256X8 port map (AD, DATA_INPUT, DATA_OUT_C, CS_A(2), WR_A, RD_A, CLK_A);
Ram_3 : SRAM_SW_AR_256X8 port map (AD, DATA_INPUT, DATA_OUT_D, CS_A(3), WR_A, RD_A, CLK_A);
end Struct;