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
            enab_stat : out STD_LOGIC;
            states_out : out STD_LOGIC_VECTOR (5 downto 0)
        );
    end component;
    
    signal clk_tb      : STD_LOGIC := '0';
    signal rst_tb      : STD_LOGIC := '1';
    signal control_tb  : STD_LOGIC := '0';
    signal c_tb        : STD_LOGIC := '0';
    signal h_tb        : STD_LOGIC := '0';
    signal s_tb        : STD_LOGIC := '0';
    
    signal enab_max_min_tb : STD_LOGIC;
    signal enab_ext_int_tb : STD_LOGIC;
    signal enab_pow_tb     : STD_LOGIC;
    signal enab_stat_tb    : STD_LOGIC;
    signal states_out_tb   : STD_LOGIC_VECTOR(5 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    signal sim_ended : boolean := false;
    
begin
    
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
            enab_stat    => enab_stat_tb,
            states_out   => states_out_tb
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
        rst_tb <= '1';
        control_tb <= '0';
        wait for CLK_PERIOD * 3;
        assert enab_max_min_tb = '1' report "ERRO: enab_max_min deveria estar ativo no RESET" severity error;
        assert states_out_tb = "000001" report "ERRO: Estado incorreto (Esperado RESET)" severity error;
        
        rst_tb <= '0';
        control_tb <= '1';
        wait for CLK_PERIOD * 2;
        assert enab_ext_int_tb = '1' report "ERRO: Deveria estar lendo sensores (enab_ext_int)" severity error;
        assert states_out_tb = "000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        wait for CLK_PERIOD * 2;
        assert enab_pow_tb = '1' report "ERRO: Deveria estar calculando potência" severity error;
        assert enab_stat_tb = '1' report "ERRO: enab_stat deveria estar ativo em CALC" severity error;
        assert states_out_tb = "000100" report "ERRO: Estado incorreto (Esperado CALC)" severity error;
        
        h_tb <= '1';
        c_tb <= '0';
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "001000" report "ERRO: Estado incorreto (Esperado HEATING)" severity error;
        
        h_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        wait for CLK_PERIOD; 
        c_tb <= '1';
        h_tb <= '0';
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "010000" report "ERRO: Estado incorreto (Esperado COOLING)" severity error;
        
        c_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "000010" report "ERRO: Estado incorreto (Esperado RINTEXT)" severity error;
        
        wait for CLK_PERIOD; 
        h_tb <= '0';
        c_tb <= '0';
        s_tb <= '1';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "100000" report "ERRO: Estado incorreto (Esperado STABLE)" severity error;
        
        s_tb <= '0';
        wait for CLK_PERIOD * 2;
        
        control_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert states_out_tb = "000001" report "ERRO: Estado incorreto (Esperado RESET)" severity error;
        
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
