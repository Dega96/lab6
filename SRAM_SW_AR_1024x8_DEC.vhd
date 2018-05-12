library ieee;
use ieee.std_logic_1164.all;

entity SRAM_SW_AR_1024x8_DEC is
port( ADDRESS : in std_logic_vector (9 downto 0);
      DATA_IN : in std_logic_vector(7 downto 0);
		DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3 : out std_logic_vector(7 downto 0);
		CSA, WR, RD, CLK : in std_logic
		);
end SRAM_SW_AR_1024x8_DEC;

architecture Stru of SRAM_SW_AR_1024x8_DEC is
signal Cs_mem : std_logic_vector(3 downto 0);
signal wrt, re, Cs_dec, clock : std_logic;
signal addre : std_logic_vector(9 downto 0);
signal ing : std_logic_vector(7 downto 0);

component SRAM_SW_AR_1024x8 is
port( AD : in std_logic_vector (7 downto 0);
      DATA_INPUT : in std_logic_vector(7 downto 0);
		DATA_OUT_A, DATA_OUT_B, DATA_OUT_C, DATA_OUT_D : out std_logic_vector(7 downto 0);
		CS_A :in std_logic_vector(3 downto 0);
		WR_A, RD_A, CLK_A : in std_logic
		);
end component;

component Decoder is
port(
			EN					: in std_logic;
			D	: out std_logic_vector( 3 downto 0);
			sel : in std_logic_vector( 1 downto 0)
		 );
end component;
begin
Dec: Decoder port map (CS_dec, Cs_mem, addre(9 downto 8));

Mem : SRAM_SW_AR_1024x8 port map (addre(7 downto 0), ing, DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3, CS_mem, wrt, re, clock );
Cs_dec <= CSA;
addre <= ADDRESS;
wrt <= WR;
re <= RD;
ing <= DATA_IN;
clock <= CLK;
end Stru;



