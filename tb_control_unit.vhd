library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU_tb is
  port(
       --INPUTS
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
end Cu_tb;

architecture Behaviour of CU_tb is
  --state signlas
  type state_type is (RST, IDLE, READ_FILE_IN, CHECK_EOF, START_STATE, SEND_IN , SAVE_OUT);
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
state_progression : process(pres_state, start, output_memB_ready, output_avg_ready, reader_done)
begin
case pres_state is
 when RST => next_state <= IDLE;
  
 when IDLE => if (start = '1') then 
               next_state <= READ_FILE_IN;
             else 
               next_state <= IDLE;
             end if;
 when READ_FILE_IN => next_state <= CHECK_EOF;
 
 when CHECK_EOF => if (reader_done = '0')then 
                  next_state <= START_STATE;
                  else
                  next_state <= IDLE;
                end if;
when START_STATE => next_state <= SEND_IN;
  
when SEND_IN => if((output_memB_ready and output_avg_ready) = '1') then 
                next_state <= SAVE_OUT;
                else 
                next_state <= SEND_IN;
              end if;
when SAVE_OUT => next_state <= READ_FILE_IN;

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
  
when IDLE => dig_fil_reset <= '1';
  
when READ_FILE_IN => en_rd_file_in <= '1';
                  dig_fil_reset <= '1';

when CHECK_EOF => dig_fil_reset <= '1';
  
when START_STATE => dig_fil_start <= '1';
                    dig_fil_reset <= '0';
                    
when SEND_IN => dig_fil_reset <= '0';

when SAVE_OUT => dig_fil_reset <= '0';
                 read_memB <= '1';
                 en_wr_file_memB <= '1';
                 en_wr_file_averg <= '1';  
 end case;
end process;

end Behaviour;


                    
       
 
    