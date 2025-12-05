library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_registrador is
end tb_registrador;

architecture testbench of tb_registrador is

    component registrador
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            en    : in  std_logic;
            d_in  : in  std_logic_vector(6 downto 0);
            q_out : out std_logic_vector(6 downto 0)
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;
    signal CLK_ENABLE : std_logic := '1';

    signal CLK   : std_logic := '0';
    signal RST   : std_logic := '1';
    signal EN    : std_logic := '0';
    signal D_IN  : std_logic_vector(6 downto 0) := (others => '0');
    signal Q_OUT : std_logic_vector(6 downto 0);

begin

    CLK <= CLK_ENABLE and not CLK after CLK_PERIOD / 2;

    -- Instancia do DUT
    DUT: registrador 
        port map (
            clk   => CLK,
            rst   => RST,
            en    => EN,
            d_in  => D_IN,
            q_out => Q_OUT
        );

    -- Processo de estimulos
    stimulus: process
    begin
    
        -- RESET INICIAL
        RST <= '1';
        EN  <= '0';
        D_IN <= "0000000";
        wait for CLK_PERIOD * 2;

        -- SAI DO RESET
        RST <= '0';
        wait for CLK_PERIOD;

        -- TESTE 1: ENABLE = 0 (registrador não muda)
        D_IN <= "1010101";
        EN <= '0';
        wait for CLK_PERIOD * 2;

        -- TESTE 2: ENABLE = 1 (carrega valor)
        EN <= '1';
        wait for CLK_PERIOD;

        -- TESTE 3: Carrega novo valor
        D_IN <= "0101010";
        wait for CLK_PERIOD * 2;

        -- TESTE 4: DISABLE novamente (valor deve se manter)
        EN <= '0';
        D_IN <= "1111111";  -- nao deve carregar
        wait for CLK_PERIOD * 2;

        -- FIM DA SIMULACAO
        CLK_ENABLE <= '0';

        wait;
    end process stimulus;

end testbench;
