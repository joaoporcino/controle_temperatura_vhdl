library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_controle_temperatura is
end tb_controle_temperatura;

architecture Behavioral of tb_controle_temperatura is

    component controle_temperatura
        Port (
            clk_sys      : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            temp_int_min : in  STD_LOGIC_VECTOR(6 downto 0);
            temp_ext_max : in  STD_LOGIC_VECTOR(6 downto 0);
            led_heat     : out STD_LOGIC;
            led_cool     : out STD_LOGIC;
            led_stable   : out STD_LOGIC;
            led_alert    : out STD_LOGIC;
            motor_pow_c  : out STD_LOGIC;
            motor_pow_h  : out STD_LOGIC;
            hex0         : out STD_LOGIC_VECTOR(6 downto 0);
            hex1         : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Sinais
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    
    -- Inputs
    signal temp_int_min : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal temp_ext_max : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    
    -- Outputs
    signal led_heat, led_cool, led_stable, led_alert : STD_LOGIC;
    signal motor_pow_c, motor_pow_h : STD_LOGIC;
    signal hex0, hex1 : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 20 ns;
    signal sim_ended : boolean := false;

begin

    uut: controle_temperatura Port Map (
        clk_sys => clk,
        rst => rst,
        temp_int_min => temp_int_min,
        temp_ext_max => temp_ext_max,
        led_heat => led_heat,
        led_cool => led_cool,
        led_stable => led_stable,
        led_alert => led_alert,
        motor_pow_c => motor_pow_c,
        motor_pow_h => motor_pow_h,
        hex0 => hex0,
        hex1 => hex1
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
        report ">>> INICIO DO TESTE CONTROLE DE TEMPERATURA <<<";
        report "===========================================";
        
        report "[1] Configuração Inicial: Reset Ativo...";
        rst <= '1';
        
        -- Configurando valores iniciais
        -- temp_int_min = 20, temp_ext_max = 40
        temp_int_min <= std_logic_vector(to_unsigned(20, 7));
        temp_ext_max <= std_logic_vector(to_unsigned(40, 7));
        
        wait for 100 ns;
        
        report "[1.1] Soltando Reset...";
        rst <= '0';
        wait for 200 ns;

        report "[2] Teste ESTAVEL: Temp interna=30, externa=30 (Dentro de 20-40)";
        temp_int_min <= std_logic_vector(to_unsigned(30, 7)); -- Sensor Interno
        temp_ext_max <= std_logic_vector(to_unsigned(30, 7)); -- Sensor Externo
        
        wait for 800 ns;
        
        assert led_stable = '1' report "ERRO [2]: Deveria estar ESTAVEL." severity error;

        -- ---------------------------------------------------------
        -- [3] TESTE AQUECIMENTO
        -- ---------------------------------------------------------
        report "[3] Teste HEAT: Temp interna=10 (Abaixo de 20)";
        temp_int_min <= std_logic_vector(to_unsigned(10, 7));
        temp_ext_max <= std_logic_vector(to_unsigned(25, 7));
        wait for 800 ns;
        
        assert led_heat = '1' report "ERRO [3]: Deveria estar AQUECENDO." severity error;

        -- ---------------------------------------------------------
        -- [4] TESTE RESFRIAMENTO
        -- ---------------------------------------------------------
        report "[4] Teste COOL: Temp externa=50 (Acima de 40)";
        temp_int_min <= std_logic_vector(to_unsigned(35, 7));
        temp_ext_max <= std_logic_vector(to_unsigned(50, 7));
        wait for 800 ns;
        
        assert led_cool = '1' report "ERRO [4]: Deveria estar RESFRIANDO." severity error;

        report "[5] RECONFIGURANDO: Resetando para novos limites (Min=50, Max=60)";
        
        rst <= '1';
        
        -- Novos limites
        temp_int_min <= std_logic_vector(to_unsigned(50, 7));
        temp_ext_max <= std_logic_vector(to_unsigned(60, 7));
        
        wait for 100 ns;
        
        rst <= '0';
        wait for 200 ns;
        
        -- ---------------------------------------------------------
        -- [5.1] TESTE COM NOVOS LIMITES
        -- ---------------------------------------------------------
        report "[5.1] Testando Temp interna=55, externa=55 com novos limites (50-60)";
        
        temp_int_min <= std_logic_vector(to_unsigned(55, 7));
        temp_ext_max <= std_logic_vector(to_unsigned(55, 7));
        
        wait for 800 ns;
        
        assert led_stable = '1' report "ERRO [5]: 55 deveria ser ESTAVEL (novos limites 50-60)." severity error;

        report "===========================================";
        report ">>> SUCESSO: TESTE FINALIZADO <<<";
        report "===========================================";
        sim_ended <= true;
        wait;
    end process;

end Behavioral;