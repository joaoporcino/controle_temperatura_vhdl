library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_datapath is
end tb_datapath;

architecture Behavioral of tb_datapath is
    
    component datapath is
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            temp_int_min : in STD_LOGIC_VECTOR(6 downto 0);
            temp_ext_max : in STD_LOGIC_VECTOR(6 downto 0);
            enab_max : in STD_LOGIC;
            enab_min : in STD_LOGIC;
            enab_ext : in STD_LOGIC;
            enab_int : in STD_LOGIC;
            enab_pow : in STD_LOGIC;
            enab_flags : in STD_LOGIC;
            c : out STD_LOGIC;
            h : out STD_LOGIC;
            s : out STD_LOGIC;
            pow_c : out STD_LOGIC;
            pow_h : out STD_LOGIC;
            alert     : out STD_LOGIC;
            power_out : out STD_LOGIC_VECTOR(6 downto 0);
            hex0      : out STD_LOGIC_VECTOR(6 downto 0);
            hex1      : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    -- Sinais de teste
    signal clk_tb      : STD_LOGIC := '0';
    signal rst_tb      : STD_LOGIC := '1';
    signal temp_int_min_tb : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal temp_ext_max_tb : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal enab_max_tb   : STD_LOGIC := '0';
    signal enab_min_tb   : STD_LOGIC := '0';
    signal enab_ext_tb   : STD_LOGIC := '0';
    signal enab_int_tb   : STD_LOGIC := '0';
    signal enab_pow_tb   : STD_LOGIC := '0';
    signal enab_flags_tb : STD_LOGIC := '0';
    
    signal c_tb : STD_LOGIC;
    signal h_tb : STD_LOGIC;
    signal s_tb : STD_LOGIC;
    signal pow_c_tb : STD_LOGIC;
    signal pow_h_tb : STD_LOGIC;
    signal alert_tb : STD_LOGIC;
    signal power_out_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal hex0_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal hex1_tb : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    signal sim_ended : boolean := false;
    
begin
    
    -- Instância do datapath
    uut: datapath
        port map (
            clk          => clk_tb,
            rst          => rst_tb,
            temp_int_min => temp_int_min_tb,
            temp_ext_max => temp_ext_max_tb,
            enab_max     => enab_max_tb,
            enab_min     => enab_min_tb,
            enab_ext     => enab_ext_tb,
            enab_int     => enab_int_tb,
            enab_pow     => enab_pow_tb,
            enab_flags   => enab_flags_tb,
            c            => c_tb,
            h            => h_tb,
            s            => s_tb,
            pow_c        => pow_c_tb,
            pow_h        => pow_h_tb,
            alert        => alert_tb,
            power_out    => power_out_tb,
            hex0         => hex0_tb,
            hex1         => hex1_tb
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
    
    -- Helper procedure para aplicar temperaturas
    procedure apply_temps(
        constant temp_int : in integer;
        constant temp_min : in integer;
        constant temp_ext : in integer;
        constant temp_max : in integer;
        signal temp_int_min_sig : out STD_LOGIC_VECTOR(6 downto 0);
        signal temp_ext_max_sig : out STD_LOGIC_VECTOR(6 downto 0)
    ) is
    begin
        temp_int_min_sig <= std_logic_vector(to_unsigned(temp_int, 7));
        temp_ext_max_sig <= std_logic_vector(to_unsigned(temp_ext, 7));
        -- Nota: Este testbench simplificado assume temp_int = temp_min e temp_ext = temp_max
        -- para facilitar. No sistema real, esses valores são separados.
    end procedure;
    
    -- Processo de estímulo
    stimulus: process
    begin
        
        report "======================================";
        report "TESTBENCH DO DATAPATH";
        report "======================================";
        report "";
        
        -- ========================================
        -- TESTE 1: Reset
        -- ========================================
        report "TESTE 1: Aplicando RESET";
        rst_tb <= '1';
        wait for CLK_PERIOD * 3;
        rst_tb <= '0';
        wait for CLK_PERIOD;
        
        -- ========================================
        -- TESTE 2: Carregar valores mín/máx
        -- ========================================
        report "TESTE 2: Carregando temperaturas mín/máx";
        temp_int_min_tb <= std_logic_vector(to_unsigned(20, 7)); -- min = 20
        temp_ext_max_tb <= std_logic_vector(to_unsigned(80, 7)); -- max = 80
        enab_min_tb <= '1';
        enab_max_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_min_tb <= '0';
        enab_max_tb <= '0';
        report "  Carregado: min=20, max=80";
        report "";
        
        -- ========================================
        -- TESTE 3: Temperatura baixa (precisa aquecer)
        -- ========================================
        report "TESTE 3: Temperatura baixa (temp_int=15, precisa aquecer)";
        temp_int_min_tb <= std_logic_vector(to_unsigned(15, 7)); -- int

 = 15
        temp_ext_max_tb <= std_logic_vector(to_unsigned(10, 7)); -- ext = 10
        enab_int_tb <= '1';
        enab_ext_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_int_tb <= '0';
        enab_ext_tb <= '0';
        
        -- Habilitar flags
        enab_flags_tb <= '1';
        wait for CLK_PERIOD * 2;
        
        report "  Flags geradas:";
        report "    h (heat)   = " & std_logic'image(h_tb);
        report "    c (cool)   = " & std_logic'image(c_tb);
        report "    s (stable) = " & std_logic'image(s_tb);
        assert h_tb = '1' report "ERRO: Flag H deveria estar ativa (temp < min)" severity error;
        assert c_tb = '0' report "ERRO: Flag C deveria estar inativa" severity error;
        
        -- Calcular potência
        enab_pow_tb <= '1';
        wait for CLK_PERIOD * 3;
        report "  Potência calculada: " & integer'image(to_integer(unsigned(power_out_tb)));
        enab_pow_tb <= '0';
        enab_flags_tb <= '0';
        report "";
        
        -- ========================================
        -- TESTE 4: Temperatura alta (precisa resfriar)
        -- ========================================
        report "TESTE 4: Temperatura alta (temp_int=85, precisa resfriar)";
        temp_int_min_tb <= std_logic_vector(to_unsigned(85, 7)); -- int = 85
        temp_ext_max_tb <= std_logic_vector(to_unsigned(90, 7)); -- ext = 90
        enab_int_tb <= '1';
        enab_ext_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_int_tb <= '0';
        enab_ext_tb <= '0';
        
        enab_flags_tb <= '1';
        wait for CLK_PERIOD * 2;
        
        report "  Flags geradas:";
        report "    h (heat)   = " & std_logic'image(h_tb);
        report "    c (cool)   = " & std_logic'image(c_tb);
        report "    s (stable) = " & std_logic'image(s_tb);
        assert c_tb = '1' report "ERRO: Flag C deveria estar ativa (temp > max)" severity error;
        assert h_tb = '0' report "ERRO: Flag H deveria estar inativa" severity error;
        
        enab_pow_tb <= '1';
        wait for CLK_PERIOD * 3;
        report "  Potência calculada: " & integer'image(to_integer(unsigned(power_out_tb)));
        enab_pow_tb <= '0';
        enab_flags_tb <= '0';
        report "";
        
        -- ========================================
        -- TESTE 5: Temperatura estável
        -- ========================================
        report "TESTE 5: Temperatura estável (temp_int=50, dentro da faixa)";
        temp_int_min_tb <= std_logic_vector(to_unsigned(50, 7)); -- int = 50
        temp_ext_max_tb <= std_logic_vector(to_unsigned(50, 7)); -- ext = 50
        enab_int_tb <= '1';
        enab_ext_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_int_tb <= '0';
        enab_ext_tb <= '0';
        
        enab_flags_tb <= '1';
        wait for CLK_PERIOD * 2;
        
        report "  Flags geradas:";
        report "    h (heat)   = " & std_logic'image(h_tb);
        report "    c (cool)   = " & std_logic'image(c_tb);
        report "    s (stable) = " & std_logic'image(s_tb);
        assert s_tb = '1' report "ERRO: Flag S deveria estar ativa (temperatura OK)" severity error;
        assert h_tb = '0' report "ERRO: Flag H deveria estar inativa" severity error;
        assert c_tb = '0' report "ERRO: Flag C deveria estar inativa" severity error;
        
        enab_pow_tb <= '1';
        wait for CLK_PERIOD * 3;
        report "  Potência calculada: " & integer'image(to_integer(unsigned(power_out_tb)));
        enab_pow_tb <= '0';
        enab_flags_tb <= '0';
        report "";
        
        -- ========================================
        -- TESTE 6: Verificar status decoder (direção dos motores)
        -- ========================================
        report "TESTE 6: Verificando sinais de direção dos motores";
        report "  pow_h (motor aquecimento) = " & std_logic'image(pow_h_tb);
        report "  pow_c (motor resfriamento) = " & std_logic'image(pow_c_tb);
        report "";
        
        -- ========================================
        -- TESTE 7: Múltiplas leituras sequenciais
        -- ========================================
        report "TESTE 7: Sequência de leituras variadas";
        for temp in 10 to 90 loop
            if temp mod 10 = 0 then  -- A cada 10 graus
                temp_int_min_tb <= std_logic_vector(to_unsigned(temp, 7));
                temp_ext_max_tb <= std_logic_vector(to_unsigned(temp + 5, 7));
                enab_int_tb <= '1';
                enab_ext_tb <= '1';
                wait for CLK_PERIOD;
                enab_int_tb <= '0';
                enab_ext_tb <= '0';
                enab_flags_tb <= '1';
                enab_pow_tb <= '1';
                wait for CLK_PERIOD * 2;
                report "  Temp=" & integer'image(temp) & 
                       " → h=" & std_logic'image(h_tb) &
                       ", c=" & std_logic'image(c_tb) &
                       ", s=" & std_logic'image(s_tb) &
                       ", power=" & integer'image(to_integer(unsigned(power_out_tb)));
                enab_flags_tb <= '0';
                enab_pow_tb <= '0';
                wait for CLK_PERIOD;
            end if;
        end loop;
        report "";
        
        -- ========================================
        -- FIM DOS TESTES
        -- ========================================
        report "======================================";
        report "TODOS OS TESTES DO DATAPATH CONCLUÍDOS!";
        report "======================================";
        
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
