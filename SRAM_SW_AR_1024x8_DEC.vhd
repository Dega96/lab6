library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SRAM_SW_AR_1024x8_DEC is
port( ADDRESS : in std_logic_vector (9 downto 0);
      DATA_IN : in signed(7 downto 0);
		DATA_OUT : out signed(7 downto 0);--DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3 : out std_logic_vector(7 downto 0);
		CS, WR, RD, CLK : in std_logic
		);
end SRAM_SW_AR_1024x8_DEC;

architecture Stru of SRAM_SW_AR_1024x8_DEC is
signal Cs_mem : std_logic_vector(3 downto 0);
signal wrt, re, Cs_dec, clock : std_logic;
signal addre : std_logic_vector(9 downto 0);
signal ing, U : signed(7 downto 0);
signal DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3 : signed(7 downto 0);

component SRAM_SW_AR_1024x8 is
port( AD : in std_logic_vector (7 downto 0);
      DATA_INPUT : in signed(7 downto 0);
		DATA_OUT_A, DATA_OUT_B, DATA_OUT_C, DATA_OUT_D : out signed(7 downto 0);
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
component mux_4_to_1_8bit is
port(
			sel	: in std_logic_vector (1 downto 0);
			y1, y2, y3, y4		: in signed (7 downto 0);
			y_sat	: out signed (7 downto 0)
		);
end component;
begin
Dec: Decoder port map (CS_dec, Cs_mem, addre(9 downto 8));

Mem : SRAM_SW_AR_1024x8 port map (addre(7 downto 0), ing, DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3, CS_mem, wrt, re, clock );

mux : mux_4_to_1_8bit port map (addre(9 downto 8), DATA_OUT_0, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3, U);

Cs_dec <= CS;
addre <= ADDRESS;
wrt <= WR;
re <= RD;
ing <= DATA_IN;
clock <= CLK;
DATA_OUT <= U;
end Stru;



