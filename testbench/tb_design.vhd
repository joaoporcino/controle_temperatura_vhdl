library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top_level is
end tb_top_level;

architecture Behavioral of tb_top_level is

    component top_level
        Port (
            clk_50MHz    : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            control_sw   : in  STD_LOGIC;
            temp_int_min : in  STD_LOGIC_VECTOR(6 downto 0);
            temp_ext_max : in  STD_LOGIC_VECTOR(6 downto 0);
            led_heat     : out STD_LOGIC;
            led_cool     : out STD_LOGIC;
            led_stable   : out STD_LOGIC;
            led_alert    : out STD_LOGIC;
            power_out    : out STD_LOGIC_VECTOR(6 downto 0);
            hex0         : out STD_LOGIC_VECTOR(6 downto 0);
            hex1         : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Sinais
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal control_sw : STD_LOGIC := '0';
    
    -- Inputs Compartilhados
    signal input_1 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); -- Min / Int
    signal input_2 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); -- Max / Ext
    
    -- Outputs
    signal led_heat, led_cool, led_stable, led_alert : STD_LOGIC;
    signal power_out, hex0, hex1 : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 20 ns;
    signal sim_ended : boolean := false;

begin

    uut: top_level Port Map (
        clk_50MHz => clk, rst => rst, control_sw => control_sw,
        temp_int_min => input_1, temp_ext_max => input_2,
        led_heat => led_heat, led_cool => led_cool, 
        led_stable => led_stable, led_alert => led_alert,
        power_out => power_out, hex0 => hex0, hex1 => hex1
    );

    -- Clock
    process begin
        while not sim_ended loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    process begin
        report "===========================================";
        report ">>> INICIO DO TESTE RTL (COM RESETS) <<<";
        report "===========================================";
        
        report "[1] Configuração Inicial: Reset Ativo...";
        rst <= '1'; 
        control_sw <= '0';
        
        -- Colocamos os valores nos pinos ENQUANTO o reset está apertado
        -- Min = 20, Max = 40
        input_1 <= std_logic_vector(to_unsigned(100, 7)); 
        input_2 <= std_logic_vector(to_unsigned(100, 7)); 
        
        wait for 100 ns; -- Garante que os sinais estabilizaram
        
        report "[1.1] Soltando Reset e Iniciando Carga...";
        rst <= '0';
        wait for 50 ns;
        
        -- Ao ligar o control_sw, a FSM vai para st_LOAD e captura o que está nos pinos (20 e 40)
        control_sw <= '1';
        wait for 200 ns; -- Tempo para carregar e estabilizar

        report "[2] Teste ESTAVEL: Temp=30 (Dentro de 20-40)";
        
        input_1 <= std_logic_vector(to_unsigned(0, 7)); -- Sensor Interno
        input_2 <= std_logic_vector(to_unsigned(0, 7)); -- Sensor Externo
        
        wait for 800 ns; 
        
        assert led_stable = '1' report "ERRO [2]: Deveria estar ESTAVEL." severity error;

        -- ---------------------------------------------------------
        -- [3] TESTE AQUECIMENTO
        -- ---------------------------------------------------------
        report "[3] Teste HEAT: Temp=10 (Abaixo de 20)";
        input_1 <= std_logic_vector(to_unsigned(10, 7));
        wait for 800 ns;
        
        assert led_heat = '1' report "ERRO [3]: Deveria estar AQUECENDO." severity error;

        -- ---------------------------------------------------------
        -- [4] TESTE RESFRIAMENTO
        -- ---------------------------------------------------------
        report "[4] Teste COOL: Temp=50 (Acima de 40)";
        input_1 <= std_logic_vector(to_unsigned(50, 7));
        wait for 800 ns;
        
        assert led_cool = '1' report "ERRO [4]: Deveria estar RESFRIANDO." severity error;

        report "[5] RECONFIGURANDO: Resetando para carregar novos limites (Min=50, Max=60)";
        
        control_sw <= '0'; -- Desliga sistema
        wait for 50 ns;
        
        rst <= '1'; -- 1. APERTA O RESET
        
        -- 2. MUDA OS PINOS PARA OS NOVOS LIMITES
        input_1 <= std_logic_vector(to_unsigned(50, 7)); -- Novo Min
        input_2 <= std_logic_vector(to_unsigned(60, 7)); -- Novo Max
        
        wait for 100 ns;
        
        rst <= '0'; -- 3. SOLTA O RESET
        wait for 50 ns;
        
        control_sw <= '1'; -- 4. LIGA O SISTEMA (FSM vai para st_LOAD e pega 50/60)
        wait for 200 ns; 
        
        -- ---------------------------------------------------------
        -- [5.1] TESTE COM NOVOS LIMITES
        -- ---------------------------------------------------------
        report "[5.1] Testando Temp=50 com novos limites";
        
        input_1 <= std_logic_vector(to_unsigned(50, 7)); 
        input_2 <= std_logic_vector(to_unsigned(55, 7)); 
        
        wait for 800 ns;
        
        -- Verifica se o sistema obedeceu os NOVOS limites carregados
        assert led_cool = '0' report "ERRO [5]: Ainda acha que 50 eh calor (nao carregou novo Max)." severity error;
        assert led_stable = '1' report "ERRO [5]: 50 deveria ser ESTAVEL (Novo Min)." severity error;

        report "===========================================";
        report ">>> SUCESSO: TESTE FINALIZADO <<<";
        report "===========================================";
        sim_ended <= true;
        wait;
    end process;

end Behavioral;