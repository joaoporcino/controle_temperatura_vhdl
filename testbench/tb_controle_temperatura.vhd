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
            states_out   : out STD_LOGIC_VECTOR(6 downto 0);
            motor_pow_c  : out STD_LOGIC;
            motor_pow_h  : out STD_LOGIC;
            led_alert    : out STD_LOGIC;
            hex0         : out STD_LOGIC_VECTOR(6 downto 0);
            hex1         : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    
    signal temp_int_min : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal temp_ext_max : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    
    signal states_out : STD_LOGIC_VECTOR(6 downto 0);
    signal motor_pow_c, motor_pow_h : STD_LOGIC;
    signal led_alert : STD_LOGIC;
    signal hex0, hex1 : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 20 ns;
    signal sim_ended : boolean := false;

begin

    uut: controle_temperatura Port Map (
        clk_sys => clk,
        rst => rst,
        temp_int_min => temp_int_min,
        temp_ext_max => temp_ext_max,
        states_out => states_out,
        motor_pow_c => motor_pow_c,
        motor_pow_h => motor_pow_h,
        led_alert => led_alert,
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

    process 
        variable i : integer;
    begin
        report "INICIO DO TESTE CONTROLE DE TEMPERATURA";
        
        -- ============================================================
        -- FASE 1: Max=20, Min=10. Int 120->5. Ext=120.
        -- ============================================================
        report ">>> FASE 1: Configurando Max=20, Min=10";
        rst <= '1';
        temp_int_min <= std_logic_vector(to_unsigned(10, 7)); -- Min
        temp_ext_max <= std_logic_vector(to_unsigned(20, 7)); -- Max
        wait for 200 ns;
        
        report ">>> FASE 1: Iniciando varredura Temp Interna (120 downto 5)";
        rst <= '0';
        wait for 20 ns;
        temp_ext_max <= std_logic_vector(to_unsigned(120, 7)); -- Ext fixa em 120
        
        for i in 24 downto 1 loop -- 120 down to 5 step 5. (24*5=120, 1*5=5)
            temp_int_min <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
            report "Fase 1: Int=" & integer'image(i*5) & ", Ext=120. States=" & integer'image(to_integer(unsigned(states_out)));
        end loop;

        -- ============================================================
        -- FASE 2: Int=5. Ext 120->5.
        -- ============================================================
        report ">>> FASE 2: Iniciando varredura Temp Externa (120 downto 5)";
        temp_int_min <= std_logic_vector(to_unsigned(5, 7)); -- Int fixa em 5
        
        for i in 24 downto 1 loop
            temp_ext_max <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
            report "Fase 2: Int=5, Ext=" & integer'image(i*5) & ". States=" & integer'image(to_integer(unsigned(states_out)));
        end loop;

        -- ============================================================
        -- FASE 3: Reset. Max=120, Min=110. Int 10->115. Ext=10.
        -- ============================================================
        report ">>> FASE 3: Resetando. Configurando Max=120, Min=110";
        rst <= '1';
        temp_int_min <= std_logic_vector(to_unsigned(110, 7)); -- Min
        temp_ext_max <= std_logic_vector(to_unsigned(120, 7)); -- Max
        wait for 200 ns;
        
        report ">>> FASE 3: Iniciando varredura Temp Interna (10 a 115)";
        rst <= '0';
        wait for 20 ns;
        temp_ext_max <= std_logic_vector(to_unsigned(10, 7)); -- Ext fixa em 10
        
        for i in 2 to 23 loop -- 10 to 115 step 5. (2*5=10, 23*5=115)
            temp_int_min <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
            report "Fase 3: Int=" & integer'image(i*5) & ", Ext=10. States=" & integer'image(to_integer(unsigned(states_out)));
        end loop;

        -- ============================================================
        -- FASE 4: Int=115. Ext 10->115.
        -- ============================================================
        report ">>> FASE 4: Iniciando varredura Temp Externa (10 a 115)";
        temp_int_min <= std_logic_vector(to_unsigned(115, 7)); -- Int fixa em 115
        
        for i in 2 to 23 loop
            temp_ext_max <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
            report "Fase 4: Int=115, Ext=" & integer'image(i*5) & ". States=" & integer'image(to_integer(unsigned(states_out)));
        end loop;

        report "SUCESSO: TESTE FINALIZADO";
        sim_ended <= true;
        wait;
    end process;

end Behavioral;