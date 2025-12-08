library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fsm is
end tb_fsm;

architecture Behavioral of tb_fsm is
    
    component controller is
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            control  : in  STD_LOGIC;
            c : in std_logic;
            h : in std_logic;
            s : in std_logic;
            enab_max_min : out STD_LOGIC;
            enab_ext_int : out STD_LOGIC;
            enab_pow : out STD_LOGIC;
            states_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    -- Sinais de teste
    signal clk_tb      : STD_LOGIC := '0';
    signal rst_tb      : STD_LOGIC := '1';
    signal control_tb  : STD_LOGIC := '0';
    signal c_tb        : STD_LOGIC := '0';
    signal h_tb        : STD_LOGIC := '0';
    signal s_tb        : STD_LOGIC := '0';
    
    signal enab_max_min_tb : STD_LOGIC;
    signal enab_ext_int_tb : STD_LOGIC;
    signal enab_pow_tb     : STD_LOGIC;
    signal states_out_tb   : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    signal sim_ended : boolean := false;
    
begin
    
    -- Instância do FSM
    uut: controller
        port map (
            clk          => clk_tb,
            rst          => rst_tb,
            control      => control_tb,
            c            => c_tb,
            h            => h_tb,
            s            => s_tb,
            enab_max_min => enab_max_min_tb,
            enab_ext_int => enab_ext_int_tb,
            enab_pow     => enab_pow_tb,
            states_out   => states_out_tb
        );
    
    -- Gerador de clock
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
    
    -- Processo de estímulo
    stimulus: process
    begin
        -- ========================================
        -- TESTE 1: RESET
        -- ========================================
        report "TESTE 1: Estado RESET";
        rst_tb <= '1';
        control_tb <= '0';
        wait for CLK_PERIOD * 3;
        assert enab_max_min_tb = '1' report "ERRO: enab_max_min deveria estar ativo no RESET" severity error;
        assert states_out_tb = "0000001" report "ERRO: Estado incorreto (Esperado RESET)" severity error;
        
        -- ========================================
        -- TESTE 2: Transição RESET -> RINTEXT
        -- ========================================
        report "TESTE 2: Transição RESET -> RINTEXT (control=1)";
        rst_tb <= '0';
        control_tb <= '1';
        wait for CLK_PERIOD * 2;
        -- Deve ir para RINTEXT
        assert enab_ext_int_tb = '1' report "ERRO: Deveria estar lendo sensores (enab_ext_int)" severity error;
        assert states_out_tb = "0000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        -- ========================================
        -- TESTE 3: RINTEXT -> CALC
        -- ========================================
        report "TESTE 3: Transição RINTEXT -> CALC";
        wait for CLK_PERIOD * 2;
        -- Deve ir para CALC
        assert enab_pow_tb = '1' report "ERRO: Deveria estar calculando potência" severity error;
        assert states_out_tb = "0000100" report "ERRO: Estado incorreto (Esperado CALC)" severity error;
        
        -- ========================================
        -- TESTE 4: CALC -> HEATING (h = 1)
        -- ========================================
        report "TESTE 4: Transição CALC -> HEATING (h=1)";
        h_tb <= '1';
        c_tb <= '0';
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "0001000" report "ERRO: Estado incorreto (Esperado HEATING)" severity error;
        
        -- ========================================
        -- TESTE 5: HEATING -> RINTEXT (h = 0)
        -- ========================================
        report "TESTE 5: Saída de HEATING (h=0)";
        h_tb <= '0';
        wait for CLK_PERIOD * 2;
        -- Deve voltar para RINTEXT
        assert states_out_tb = "0000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        -- ========================================
        -- TESTE 6: CALC -> COOLING (c = 1)
        -- ========================================
        report "TESTE 6: Transição CALC -> COOLING (c=1)";
        wait for CLK_PERIOD; -- Espera ir para CALC
        c_tb <= '1';
        h_tb <= '0';
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "0010000" report "ERRO: Estado incorreto (Esperado COOLING)" severity error;
        
        -- ========================================
        -- TESTE 7: COOLING -> RINTEXT (c = 0)
        -- ========================================
        report "TESTE 7: Saída de COOLING (c=0)";
        c_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "0000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        -- ========================================
        -- TESTE 8: CALC -> STABLE (s = 1)
        -- ========================================
        report "TESTE 8: Transição CALC -> STABLE (s=1)";
        wait for CLK_PERIOD; -- Espera ir para CALC
        h_tb <= '0';
        c_tb <= '0';
        s_tb <= '1';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "0100000" report "ERRO: Estado incorreto (Esperado STABLE)" severity error;
        
        -- ========================================
        -- TESTE 9: STABLE -> RINTEXT (s = 0)
        -- ========================================
        report "TESTE 9: Saída de STABLE (s=0)";
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        
        -- ========================================
        -- TESTE 10: Desligar sistema (control = 0)
        -- ========================================
        report "TESTE 10: Desligando sistema (control=0)";
        control_tb <= '0';
        wait for CLK_PERIOD * 2;
        -- Deve voltar para RESET
        assert states_out_tb = "0000001" report "ERRO: Estado incorreto (Esperado RESET)" severity error;
        
        -- ========================================
        -- FIM DOS TESTES
        -- ========================================
        report "======================================";
        report "TODOS OS TESTES DA FSM CONCLUIDOS!";
        report "======================================";
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
