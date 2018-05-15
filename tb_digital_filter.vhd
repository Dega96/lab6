library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity tb_digital_filter is
  generic (bit_n : integer := 8);
end tb_digital_filter;

architecture test of tb_digital_filter is
  --Component declaretion
  component Digital_filter 
    port ( clk : in std_logic; --from main control generator 
           start, rst : in std_logic; --from tb_CU
           Data_IN : in signed(7 downto 0); --from file reader in
           M : out signed(7 downto 0); -- from datapath
           M_disp, done : out std_logic;  --
           Data_out_mem_B : out signed(7 downto 0) --
        );
end component;

component CU_tb 
  port (--INPUTS
       clock, start, reset : in std_logic; --from main control generator
       reader_done : in std_logic; -- from file reader
       output_memB_ready : in std_logic; --from datapath
       output_avg_ready : in std_logic; --
       --OUTPUTS
       --to the DP
       dig_fil_start : out std_logic; --start for DP
       dig_fil_reset : out std_logic; --reset for DP
       read_memB : out std_logic; -- start reading mem B
       --to the file readers
       en_wr_file_memB : out std_logic; --enable writer for mem B
       en_wr_file_averg : out std_logic; --enable writer for averg
       en_rd_file_in : out std_logic --eneble file reader in
     );
end component;

 component file_reader
        generic(bit_n: integer:=8);
        port( -- INPUT SIGNALS
            clock: in std_logic; -- clock signal
            enable: in std_logic; -- enable signal
            file_name: in string; -- name of the file to read the files from
              -- OUTPUT SIGNALS
            data: out signed(bit_n-1 downto 0);
            done: out std_logic
        );
    end component;
    
component file_writer
        generic(bit_n: integer:=8);
        port( -- INPUT SIGNALS
            clock: in std_logic; -- clock signal
            enable: in std_logic; -- enable signal
            file_name: in string; -- name of the output file
            data_in: in signed(bit_n-1 downto 0) -- Data to be written on the file
        );
    end component;
  
  signal clock, start, reset : std_logic; --signals from main control signal generator
  --CU signals
  signal digfil_start, digfil_reset : std_logic;
  signal en_write_file_memB, en_write_file_averg, en_read_file_in : std_logic;
  signal read_sig_memB : std_logic;
  --file reader signals
  signal en_read : std_logic;
  signal data_from_reader, data_from_file : signed(bit_n-1 downto 0);
  signal read_done :std_logic;
  --file writer signals
  signal en_write : std_logic;     
  signal data_output : std_logic_vector(bit_n-1 downto 0);  
   
  signal memB_ready, avg_ready : std_logic;
  signal out_mem_B : signed(7 downto 0);
  signal out_average : signed (7 downto 0);
  
  begin --instantiating the UUT
  --Clock gen
  clock <= not clock after 50 ns;
  --reset generation
  reset <= '1' after 50 ns, '0' after 80 ns;     ----------------DA AGGIUSTARE SECONDO SPECIFICHE
  --start generation
  start <= '1' after 100 ns, '0' after 200 ns;
  
  --control unit of testbench
  testb_CU : CU_tb port map 
  (clock, 
   start, 
   reset, 
   read_done, 
   memB_ready, 
   avg_ready, 
   digfil_start, 
   digfil_reset, 
   read_sig_memB, 
   en_write_file_memB, 
   en_write_file_averg,
   en_read_file_in
  );
  
  --DUT
  DigFil : Digital_filter port map
    (clock, 
     digfil_start,
     digfil_reset,
     data_from_reader,
     out_average,
     avg_ready,
     memB_ready,
     out_mem_B
   );
   
   --file reader
   Rd : file_reader port map 
   ( clock,
     en_read_file_in,
     "Input_contents.txt",
     data_from_file, 
     read_done
  );
  --file writer for memB
  WrMemB : file_writer port map
    (clock,
     en_write_file_memB, 
     "Out_MemB_contents.txt",
     out_mem_B
   );
  --file writer for average
  WrAvrg : file_writer port map
    (clock, 
     en_write_file_averg, 
     "Out_Avg_contents.txt",
     out_average
   );
   
 end test;
  