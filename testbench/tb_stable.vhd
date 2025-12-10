library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stable is
end tb_stable;

architecture Behavioral of tb_stable is

    component stable_control
        Port ( 
            proc    : in STD_LOGIC;    
            read    : in STD_LOGIC;
            h       : in STD_LOGIC; 
            c       : in STD_LOGIC; 
            stb     : out STD_LOGIC
        );
    end component;

    signal proc_tb : STD_LOGIC := '0';
    signal read_tb : STD_LOGIC := '0';
    signal h_tb    : STD_LOGIC := '0';
    signal c_tb    : STD_LOGIC := '0';
    signal stb_tb  : STD_LOGIC;

    constant PERIOD : time := 10 ns;

begin

    uut: stable_control
        port map (
            proc => proc_tb,
            read => read_tb,
            h    => h_tb,
            c    => c_tb,
            stb  => stb_tb
        );

    stimulus : process
    begin

        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '1'
            report "ERRO: stb deveria ser 1 no Teste 1"
            severity error;

        h_tb    <= '1';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 2"
            severity error;

        h_tb    <= '0';
        read_tb <= '1';
        c_tb    <= '0';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 3"
            severity error;

        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '1';
        proc_tb <= '1';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 4"
            severity error;

        h_tb    <= '0';
        read_tb <= '0';
        c_tb    <= '0';
        proc_tb <= '0';
        wait for PERIOD;
        assert stb_tb = '0'
            report "ERRO: stb deveria ser 0 no Teste 5"
            severity error;

        wait;

    end process;

end Behavioral;
