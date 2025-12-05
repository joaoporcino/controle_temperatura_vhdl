library ieee;
use ieee.std_logic_1164.all;

entity tb_comparador_diferente is
end entity;

architecture tb of tb_comparador_diferente is

    signal A   : std_logic_vector(6 downto 0);
    signal B   : std_logic_vector(6 downto 0);
    signal DIF : std_logic;

begin

    -- Instancia do DUT
    uut: entity work.comparador_diferente
        port map(
            A   => A,
            B   => B,
            DIF => DIF
        );

    -- Estimulos
    stim: process
    begin

        -- Caso 1: iguais  DIF = 0
        A <= "0000000";
        B <= "0000000";
        wait for 20 ns;

        -- Caso 2: diferentes  DIF = 1
        A <= "1010101";
        B <= "1010111";
        wait for 20 ns;

        -- Caso 3
        A <= "1110001";
        B <= "1110001";
        wait for 20 ns;

        -- Caso 4
        A <= "0101010";
        B <= "1111111";
        wait for 20 ns;

        wait;
    end process;

end architecture;
