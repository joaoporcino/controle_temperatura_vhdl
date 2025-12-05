library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stable_control is
end tb_stable_control;

architecture Behavioral of tb_stable_control is

    -- Componente a testar
    component stable_control
        Port ( 
            proc    : in STD_LOGIC;    
            read    : in STD_LOGIC;
            h       : in STD_LOGIC; 
            c       : in STD_LOGIC; 
            stb     : out STD_LOGIC
        );
    end component;

    -- Sinais do testbench (SEM "in" ou "out")
    signal proc_tb : STD_LOGIC := '0';
    signal read_tb : STD_LOGIC := '0';
    signal h_tb    : STD_LOGIC := '0';
    signal c_tb    : STD_LOGIC := '0';
    signal stb_tb  : STD_LOGIC;

    constant PERIOD : time := 10 ns;

begin

    -- Instância correta
    uut: stable_control
        port map (
            proc => proc_tb,
            read => read_tb,
            h    => h_tb,
            c    => c_tb,
            stb  => stb_tb
        );

    -- PROCESSO DE ESTIMULO
    stimulus : process
    begin

        -- TESTE 1: Ativacao (h=0, read=0, c=0, proc=1) => stb = 1
        report "Teste 1: stb deve ser 1";
        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '1'
            report "ERRO: stb deveria ser 1 no Teste 1"
            severity error;

        -- TESTE 2: h = 1 => stb = 0
        report "Teste 2: stb deve ser 0 (h=1)";
        h_tb    <= '1';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 2"
            severity error;

        -- TESTE 3: read = 1 => stb = 0
        report "Teste 3: stb deve ser 0 (read=1)";
        h_tb    <= '0';
        read_tb <= '1';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 3"
            severity error;

        -- TESTE 4: c = 1 => stb = 0
        report "Teste 4: stb deve ser 0 (c=1)";
        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '1';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 4"
            severity error;

        -- TESTE 5: proc = 0 => stb = 0
        report "Teste 5: stb deve ser 0 (proc=0)";
        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '0';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 5"
            severity error;

        report "Todos os testes finalizados." severity note;
        wait;

    end process;

end Behavioral;
