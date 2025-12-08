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
    
    -- Sinais de teste
    signal clk_in_tb  : STD_LOGIC := '0';
    signal rst_tb     : STD_LOGIC := '1';
    signal clk_out_tb : STD_LOGIC;
    
    -- Clock de 50 MHz (periodo de 20 ns)
    constant CLK_50MHZ_PERIOD : time := 20 ns;
    
    -- Para simulacao rapida (a constante no clock.vhd deve estar em 5)
    -- Com MAX_COUNT = 5, sao necessarios 5 pulsos de clock_in para alternar clk_out
    -- Portanto, periodo de clk_out = 5 * 2 * 20ns = 200ns (5 MHz em vez de 1 Hz)
    constant EXPECTED_OUT_PERIOD : time := 200 ns;
    
    signal sim_ended : boolean := false;
    signal rising_count : integer := 0;
    signal last_clk_out : STD_LOGIC := '0';
    
    signal reset_count_tb : STD_LOGIC := '0';
    
begin
    
    -- Instancia do clock divider
    uut: clock_divider
        port map (
            clk_in  => clk_in_tb,
            rst     => rst_tb,
            clk_out => clk_out_tb
        );
    
    -- Gerador de clock de 50 MHz
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
    
    -- Contador de bordas de subida no clock de saida
    count_process: process(clk_out_tb, reset_count_tb)
    begin
        if reset_count_tb = '1' then
            rising_count <= 0;
        elsif rising_edge(clk_out_tb) then
            rising_count <= rising_count + 1;
        end if;
    end process;
    
    -- Processo de estimulo e verificacao
    stimulus: process
        variable time_start : time;
        variable time_end : time;
    begin
        -- ========================================
        -- TESTE 1: Reset assincrono
        -- ========================================
        report "TESTE 1: Verificando RESET";
        rst_tb <= '1';
        wait for CLK_50MHZ_PERIOD * 10;
        assert clk_out_tb = '0' 
            report "ERRO: Clock de saida deveria estar em 0 durante reset" 
            severity error;
        
        -- ========================================
        -- TESTE 2: Liberar reset e verificar divisao
        -- ========================================
        report "TESTE 2: Liberando RESET e verificando divisao de clock";
        rst_tb <= '0';
        wait for CLK_50MHZ_PERIOD;
        
        -- Espera primeira borda de subida
        wait until rising_edge(clk_out_tb);
        time_start := now;
        report "Primeira borda de subida detectada em: " & time'image(now);
        
        -- Espera segunda borda de subida
        wait until rising_edge(clk_out_tb);
        time_end := now;
        report "Segunda borda de subida detectada em: " & time'image(now);
        report "Periodo medido: " & time'image(time_end - time_start);
        
        -- Verifica se o periodo esta correto (com margem de erro)
        assert (time_end - time_start) = EXPECTED_OUT_PERIOD
            report "AVISO: Periodo do clock de saida nao esta exatamente como esperado"
            severity warning;
        
        -- ========================================
        -- TESTE 3: Contar multiplos ciclos
        -- ========================================
        report "TESTE 3: Contando multiplos ciclos";
        reset_count_tb <= '1';
        wait for 1 ns;
        reset_count_tb <= '0';
        wait for EXPECTED_OUT_PERIOD * 10;
        report "Bordas de subida contadas em 10 periodos: " & integer'image(rising_count);
        assert rising_count >= 8 and rising_count <= 12
            report "ERRO: Numero de bordas fora do esperado"
            severity error;
        
        -- ========================================
        -- TESTE 4: Reset durante operacao
        -- ========================================
        report "TESTE 4: Aplicando RESET durante operacao";
        wait until rising_edge(clk_out_tb);
        wait for EXPECTED_OUT_PERIOD/4; -- Meio caminho ate proxima borda
        rst_tb <= '1';
        wait for CLK_50MHZ_PERIOD * 2;
        assert clk_out_tb = '0' 
            report "ERRO: Reset nao zerou o clock de saida" 
            severity error;
        
        -- ========================================
        -- TESTE 5: Retomar apos reset
        -- ========================================
        report "TESTE 5: Retomando apos reset";
        rst_tb <= '0';
        wait for EXPECTED_OUT_PERIOD * 3;
        
        -- Verificar se esta oscilando novamente
        wait until rising_edge(clk_out_tb);
        report "Clock retomou apos reset";
        
        -- ========================================
        -- FIM DOS TESTES
        -- ========================================
        report "======================================";
        report "TODOS OS TESTES DO CLOCK CONCLUIDOS!";
        report "======================================";
        report "NOTA: Se estiver usando MAX_COUNT real (25000000),";
        report "      este teste levara MUITO tempo. Use MAX_COUNT=5";
        report "      no arquivo clock.vhd para simulacoes rapidas.";
        report "======================================";
        
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
