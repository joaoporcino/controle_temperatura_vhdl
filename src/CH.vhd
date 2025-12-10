library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CH is
    Port (
        sinal_input     : in  STD_LOGIC;
        enable          : in  STD_LOGIC;
		  enab            : in  STD_LOGIC;
        sinal_output    : out STD_LOGIC
    );
end CH;

architecture Dataflow of CH is
begin
    PROCESS(enable, sinal_input)
    BEGIN
        IF enable = '1' THEN
            sinal_output <= sinal_input;
        ELSE
            sinal_output <= '0';
        END IF;
    END PROCESS;

end Dataflow;