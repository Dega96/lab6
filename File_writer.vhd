library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity file_writer is
    generic(bit_n: integer:=8);
    port(
    -- INPUT SIGNALS
        clock: in std_logic; -- clock signal
        enable: in std_logic; -- enable signal
        out_data_contents: in string; -- name of the output file
        data_in_f: in std_logic_vector(bit_n-1 downto 0); -- Data to be written on the file
        
		  done_writing: out std_logic
    );
end file_writer;

architecture Behaviour of file_writer is

    signal linenumber: integer:=1;
    

begin
    
    writing_process: process(clock, enable, data_in_f)
    file output_file: text open write_mode is out_data_contents; -- the file
    variable file_status: File_open_status; -- to check wether the file is already open
    variable line_buffer: line; -- read buffer
    --variable EOF : std_logic := '0';
    variable write_data: bit_vector(bit_n-1 downto 0); -- The line to write to the file
    
    
    begin
        write_data := to_bitvector(data_in_f);
        if(enable='1') then
            if(clock'event and clock='1') then
                   -- if(not endfile(output_file)) then
                    write(line_buffer, write_data, left, bit_n-1); -- writes the input data to the buffer
                    writeline(output_file, line_buffer); -- writes the buffer content to the file
            else
              --EOF := '1';
            --end if;
        end if;
      end if;
        --done_writing <= EOF;

       

    end process;

end architecture behaviour;