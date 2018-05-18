library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity file_reader is
    generic(bit_n: integer:=8);
    port(
    -- INPUT SIGNALS
        clock: in std_logic; -- clock signal
        enable: in std_logic; -- enable signal
        in_data_contents: in string; -- name of the file to read the files from
        -- mode: in string;
    -- OUTPUT SIGNALS
        data: out signed(bit_n-1 downto 0);
        done: out std_logic
    );
end file_reader;

architecture Behaviour of file_reader is

    signal linenumber: integer:=1;

begin
    reading_process: process(clock, enable)
    file input_file: text open read_mode is in_data_contents; -- the file
    variable file_status: File_open_status; -- to check wether the file is already open
    variable line_buffer: line; -- read buffer
    variable EOF: std_logic:='0'; -- End Of File variable

    variable read_data: bit_vector(bit_n-1 downto 0); -- The line read from the file

    begin
        if(enable='1') then
            if(clock'event and clock='1') then
                if(not endfile(input_file)) then
                    readline(input_file, line_buffer); -- Reads the next full line from the file
                    read(line_buffer, read_data); -- Stores the first bit_n bits from the buffer into the output signal
                else
                    EOF:='1';
                end if;
            end if;
        end if;

        done <= EOF;
        data <= signed(to_stdlogicvector(read_data));

        -- file_close(input_file);

    end process;

end Behaviour;
