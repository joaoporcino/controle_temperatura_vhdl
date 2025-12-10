library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock is
end tb_clock;

architecture Behavioral of tb_clock is
    
    component clock_divider is
        Port (
            clk_in  : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;
    
    signal clk_in_tb  : STD_LOGIC := '0';
    signal rst_tb     : STD_LOGIC := '1';
    signal clk_out_tb : STD_LOGIC;
    
    constant CLK_50MHZ_PERIOD : time := 20 ns;
    
    constant EXPECTED_OUT_PERIOD : time := 200 ns;
    
    signal sim_ended : boolean := false;
    signal rising_count : integer := 0;
    signal last_clk_out : STD_LOGIC := '0';
    
    signal reset_count_tb : STD_LOGIC := '0';
    
begin
    
    uut: clock_divider
        port map (
            clk_in  => clk_in_tb,
            rst     => rst_tb,
            clk_out => clk_out_tb
        );
    
    clk_process: process
    begin
        while not sim_ended loop
            clk_in_tb <= '0';
            wait for CLK_50MHZ_PERIOD/2;
            clk_in_tb <= '1';
            wait for CLK_50MHZ_PERIOD/2;
        end loop;
        wait;
    end process;
    
    count_process: process(clk_out_tb, reset_count_tb)
    begin
        if reset_count_tb = '1' then
            rising_count <= 0;
        elsif rising_edge(clk_out_tb) then
            rising_count <= rising_count + 1;
        end if;
    end process;
    
    stimulus: process
        variable time_start : time;
        variable time_end : time;
    begin
        rst_tb <= '1';
        wait for CLK_50MHZ_PERIOD * 10;
        assert clk_out_tb = '0' 
            report "ERRO: Clock de saida deveria estar em 0 durante reset" 
            severity error;
        
        rst_tb <= '0';
        wait for CLK_50MHZ_PERIOD;
        
        wait until rising_edge(clk_out_tb);
        time_start := now;
        
        wait until rising_edge(clk_out_tb);
        time_end := now;
        
        assert (time_end - time_start) = EXPECTED_OUT_PERIOD
            report "AVISO: Periodo do clock de saida nao esta exatamente como esperado"
            severity warning;
        
        reset_count_tb <= '1';
        wait for 1 ns;
        reset_count_tb <= '0';
        wait for EXPECTED_OUT_PERIOD * 10;
        assert rising_count >= 8 and rising_count <= 12
            report "ERRO: Numero de bordas fora do esperado"
            severity error;
        
        wait until rising_edge(clk_out_tb);
        wait for EXPECTED_OUT_PERIOD/4; 
        rst_tb <= '1';
        wait for CLK_50MHZ_PERIOD * 2;
        assert clk_out_tb = '0' 
            report "ERRO: Reset nao zerou o clock de saida" 
            severity error;
        
        rst_tb <= '0';
        wait for EXPECTED_OUT_PERIOD * 3;
        
        wait until rising_edge(clk_out_tb);
        
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
