library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk_in  : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        clk_out : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    -- Para simulacao: 5
    -- Para FPGA (1 Hz de 50 MHz): 25000000
    constant MAX_COUNT : integer := 5;
    
    signal count : integer range 0 to MAX_COUNT := 0;
    signal clk_sig : STD_LOGIC := '0';
begin

    process(clk_in, rst)
    begin
        if rst = '1' then
            count <= 0;
            clk_sig <= '0';
        elsif rising_edge(clk_in) then
            if count = MAX_COUNT - 1 then
                count <= 0;
                clk_sig <= not clk_sig;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_sig;

end Behavioral;
