library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU_tb is
  port(
       --INPUTS
       clock, start, reset : in std_logic; --from main control generator
       reader_done : in std_logic; -- from file reader
       writer_done : in integer ;
       output_ready : in std_logic; --from datapath
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
end Cu_tb;

architecture Behaviour of CU_tb is
  --state signlas
  type state_type is (RST, IDLE,CHECK_EOF, SAVE_IN_B, START_OP);
    signal pres_state, next_state : state_type;
    begin 
    state_up : process(clock, reset)
    begin
    if(clock'event and clock ='1') then 
      if (reset = '1') then
          pres_state <= RST;
       else
       pres_state <= next_state;
     end if;
  end if;
end process;
--state progression
state_progression : process(pres_state, start, output_ready, reader_done)
begin
case pres_state is
 when RST => next_state <= IDLE;
  
 -----------------------------------------------------PUT DATA IN MEM A--------------------------
 when IDLE => if (start = '1') then 
               next_state <= CHECK_EOF;
             else 
               next_state <= IDLE;
             end if;
 
 when CHECK_EOF => if (reader_done = '0')then 
                  next_state <= CHECK_EOF;
                  else
                  next_state <= START_OP ;
                end if;
  

-------------------------------------------------------START OPERATION IN DIGITAL FILTER---------------------------------
when START_OP =>  if(output_ready = '1' ) then
                  next_state <= SAVE_IN_B;
                else
                  next_state <= START_OP;
                end if;
                
when SAVE_IN_B => if (writer_done = 1023) then
                      next_state <= RST;
                     else
                       next_state <= SAVE_IN_B;
                       end if;
when others => next_state <= RST;
  
end case;
end process;

--Signals control from the CU_tb
control_gen : process (pres_state)
begin
       --setting default values
       dig_fil_start <= '0';
       dig_fil_reset <= '0';
       read_memB <= '0';
       en_wr_file_memB <= '0';
       en_wr_file_averg <= '0';
       en_rd_file_in <= '0';
       
case pres_state is
when RST =>  dig_fil_reset <= '1';
             dig_fil_start <= '0';
            
  
when IDLE => dig_fil_reset <= '0';
             dig_fil_start <= '0';
             
  
when CHECK_EOF => dig_fil_reset <= '0';
                  en_rd_file_in <= '1';
                  dig_fil_start <= '1';
  
when START_OP =>dig_fil_reset <= '0';
                dig_fil_start <= '1';

when SAVE_IN_B => dig_fil_start <= '1';
                 dig_fil_reset <= '0';
                 read_memB <= '1';
                 en_wr_file_memB <= '1';
                 en_wr_file_averg <= '1';  
 end case;
end process;

end Behaviour;


                    
       
 
    