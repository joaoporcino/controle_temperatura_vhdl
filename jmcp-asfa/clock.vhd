library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk_in  : in  STD_LOGIC; -- Clock de 50 MHz da placa
        rst     : in  STD_LOGIC;
        clk_out : out STD_LOGIC  -- Clock de 1 Hz (Saída)
    );
end clock_divider;

architecture Behavioral of clock_divider is
    -- Constante para dividir 50MHz para 1Hz
    -- 50.000.000 Hz / 1 Hz / 2 (meio ciclo) = 25.000.000
    -- constant MAX_COUNT : integer := 25000000 - 1;
    
    -- Se quiser simular rápido, descomente a linha de baixo e comente a de cima:
    constant MAX_COUNT : integer := 5 - 1; -- Apenas para teste no ModelSim/GHDL

    signal counter : integer range 0 to MAX_COUNT := 0;
    signal temp_clk : std_logic := '0';

begin

    process(clk_in, rst)
    begin
        if rst = '1' then
            counter <= 0;
            temp_clk <= '0';
        elsif rising_edge(clk_in) then
            if counter = MAX_COUNT then
                counter <= 0;
                temp_clk <= not temp_clk; -- Inverte o sinal (0 vira 1, 1 vira 0)
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= temp_clk;

end Behavioral;