library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_decoder is
    Port (
        reset     : in  STD_LOGIC;
        not_reset : out STD_LOGIC
    );
end control_decoder;

architecture Dataflow of control_decoder is
begin

    not_reset <= not reset;

end Dataflow;
