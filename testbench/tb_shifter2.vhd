library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_shifter2 is
end tb_shifter2;

architecture Behavioral of tb_shifter2 is

    -- O VHDL vai buscar direto na biblioteca 'work'

    -- Definimos o tamanho aqui APENAS para criar os fios do teste
    constant N_TB : integer := 9; 

    signal s_Din  : STD_LOGIC_VECTOR (N_TB-1 downto 0) := (others => '0');
    signal s_Dout : STD_LOGIC_VECTOR (N_TB-1 downto 0);
    
    constant WAIT_TIME : time := 20 ns;

begin

    uut: entity work.shifter
    port map (
        Din  => s_Din,
        Dout => s_Dout
    );

    stim_proc: process
    begin
        ------------------------------------------------------------
        -- Caso 1: 100 / 4 = 25
        ------------------------------------------------------------
        s_Din <= std_logic_vector(to_signed(100, N_TB));
        wait for WAIT_TIME;
        
        s_Din <= std_logic_vector(to_signed(16, N_TB));
        wait for WAIT_TIME;

        ------------------------------------------------------------
        ------------------------------------------------------------
        s_Din <= std_logic_vector(to_signed(-100, N_TB));
        wait for WAIT_TIME;
        

        ------------------------------------------------------------
        ------------------------------------------------------------
        s_Din <= std_logic_vector(to_signed(-16, N_TB));
        wait for WAIT_TIME;
        
        wait;
    end process;

end Behavioral;