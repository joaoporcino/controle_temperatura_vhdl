library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cool_control is
end tb_cool_control;

architecture Behavioral of tb_cool_control is
    component cool_control
        Port ( 
            clk     : in STD_LOGIC;
            c       : in STD_LOGIC;
            proc    : in STD_LOGIC;
            read    : in STD_LOGIC;
            cool    : out STD_LOGIC
        );
    end component;
    
    signal clk_tb    : STD_LOGIC := '0';
    signal reset_tb  : STD_LOGIC := '0';
    signal c_tb      : STD_LOGIC := '0';
    signal proc_tb   : STD_LOGIC := '0';
    signal read_tb   : STD_LOGIC := '0';
    signal cool_tb   : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
    signal sim_ended : boolean := false;  -- Controle de parada
    
begin
    uut: cool_control port map (
        clk => clk_tb,
        c => c_tb,
        proc => proc_tb,
        read => read_tb,
        cool => cool_tb
    );
    
    clk_process: process
    begin
        while not sim_ended loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;
    
    stimulus: process
    begin
    	
        read_tb <= '1';
        wait for CLK_PERIOD/2;
        
        -- TESTE 1: Condição ativa (c=1, proc=1, read=0)
        report "Teste 1: cool = 1 AND 1 AND NOT 0 = 1";
        c_tb <= '1';
        proc_tb <= '1';
        read_tb <= '0';
        wait for CLK_PERIOD;
        assert cool_tb = '1' report "ERRO: cool deveria ser 1" severity error;
        
        -- TESTE 2: Condição inativa (read=1)
        report "Teste 2: cool = 1 AND 1 AND NOT 1 = 0";
        c_tb <= '1';
        proc_tb <= '1';
        read_tb <= '1';
        wait for CLK_PERIOD;
        assert cool_tb = '0' report "ERRO: cool deveria ser 0" severity error;
        
        -- TESTE 3: Condição inativa (c=0)
        report "Teste 3: cool = 0 AND 1 AND NOT 0 = 0";
        c_tb <= '0';
        proc_tb <= '1';
        read_tb <= '0';
        wait for CLK_PERIOD;
        assert cool_tb = '0' report "ERRO: cool deveria ser 0" severity error;
        
        -- TESTE 4: Condição inativa (proc=0)
        report "Teste 4: cool = 1 AND 0 AND NOT 0 = 0";
        c_tb <= '1';
        proc_tb <= '0';
        read_tb <= '0';
        wait for CLK_PERIOD;
        assert cool_tb = '0' report "ERRO: cool deveria ser 0" severity error;
        
        -- TESTE 5: Transições rápidas
        report "Teste 5: Transições rápidas";
        
        -- Clock 1
        c_tb <= '1'; proc_tb <= '1'; read_tb <= '0';
        wait for CLK_PERIOD;
        assert cool_tb = '1' report "ERRO: Transição 1" severity error;
        
        -- Clock 2
        c_tb <= '1'; proc_tb <= '1'; read_tb <= '1';
        wait for CLK_PERIOD;
        assert cool_tb = '0' report "ERRO: Transição 2" severity error;
        
        -- Clock 3
        c_tb <= '1'; proc_tb <= '1'; read_tb <= '0';
        wait for CLK_PERIOD;
        assert cool_tb = '1' report "ERRO: Transição 3" severity error;
        
        -- TESTE 6: Reset durante operação
        report "Teste 6: Reset durante operação";
        c_tb <= '1'; proc_tb <= '1'; read_tb <= '0';
        wait for CLK_PERIOD/2;  -- Meio período
        reset_tb <= '1';
        wait for CLK_PERIOD/2;
        assert cool_tb = '0' report "ERRO: Reset não funcionou" severity error;
        reset_tb <= '0';
        
        sim_ended <= true;
        wait;
    end process;
    
end Behavioral;