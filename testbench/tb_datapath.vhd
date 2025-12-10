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
            enab_max_min: in STD_LOGIC;
            enab_ext_int : in STD_LOGIC;
            enab_pow : in STD_LOGIC;
            enab_stat : in STD_LOGIC;
            c : out STD_LOGIC;
            h : out STD_LOGIC;
            s : out STD_LOGIC;
            pow_c : out STD_LOGIC;
            pow_h : out STD_LOGIC;
            ctrl  : out STD_LOGIC;
            alert     : out STD_LOGIC;
            hex0      : out STD_LOGIC_VECTOR(6 downto 0);
            hex1      : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal clk_tb      : STD_LOGIC := '0';
    signal rst_tb      : STD_LOGIC := '1';
    signal temp_int_min_tb : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal temp_ext_max_tb : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal enab_max_min_tb   : STD_LOGIC := '0';
    signal enab_ext_int_tb   : STD_LOGIC := '0';
    signal enab_pow_tb   : STD_LOGIC := '0';
    signal enab_stat_tb  : STD_LOGIC := '0';
    
    signal c_tb : STD_LOGIC;
    signal h_tb : STD_LOGIC;
    signal s_tb : STD_LOGIC;
    signal pow_c_tb : STD_LOGIC;
    signal pow_h_tb : STD_LOGIC;
    signal ctrl_tb : STD_LOGIC;
    signal alert_tb : STD_LOGIC;
    signal hex0_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal hex1_tb : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    signal sim_ended : boolean := false;
    
begin
    
    uut: datapath
        port map (
            clk          => clk_tb,
            rst          => rst_tb,
            temp_int_min => temp_int_min_tb,
            temp_ext_max => temp_ext_max_tb,
            enab_max_min => enab_max_min_tb,
            enab_ext_int => enab_ext_int_tb,
            enab_pow     => enab_pow_tb,
            enab_stat    => enab_stat_tb,
            c            => c_tb,
            h            => h_tb,
            s            => s_tb,
            pow_c        => pow_c_tb,
            pow_h        => pow_h_tb,
            ctrl         => ctrl_tb,
            alert        => alert_tb,
            hex0         => hex0_tb,
            hex1         => hex1_tb
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
        wait for CLK_PERIOD * 3;
        rst_tb <= '0';
        wait for CLK_PERIOD;
        
        temp_int_min_tb <= std_logic_vector(to_unsigned(20, 7)); 
        temp_ext_max_tb <= std_logic_vector(to_unsigned(80, 7)); 
        enab_max_min_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_max_min_tb <= '0';
        
        temp_int_min_tb <= std_logic_vector(to_unsigned(15, 7)); 
        temp_ext_max_tb <= std_logic_vector(to_unsigned(10, 7)); 
        enab_ext_int_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_ext_int_tb <= '0';
        
        enab_pow_tb <= '1';
        enab_stat_tb <= '1';
        wait for CLK_PERIOD * 3;
        
        assert h_tb = '1' report "ERRO: Flag H deveria estar ativa (temp < min)" severity error;
        assert c_tb = '0' report "ERRO: Flag C deveria estar inativa" severity error;
        
        enab_pow_tb <= '0';
        enab_stat_tb <= '0';
        
        temp_int_min_tb <= std_logic_vector(to_unsigned(85, 7)); 
        temp_ext_max_tb <= std_logic_vector(to_unsigned(90, 7)); 
        enab_ext_int_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_ext_int_tb <= '0';
        
        enab_pow_tb <= '1';
        enab_stat_tb <= '1';
        wait for CLK_PERIOD * 3;
        
        assert c_tb = '1' report "ERRO: Flag C deveria estar ativa (temp > max)" severity error;
        assert h_tb = '0' report "ERRO: Flag H deveria estar inativa" severity error;
        
        enab_pow_tb <= '0';
        enab_stat_tb <= '0';
        
        temp_int_min_tb <= std_logic_vector(to_unsigned(50, 7)); 
        temp_ext_max_tb <= std_logic_vector(to_unsigned(50, 7)); 
        enab_ext_int_tb <= '1';
        wait for CLK_PERIOD * 2;
        enab_ext_int_tb <= '0';
        
        enab_pow_tb <= '1';
        enab_stat_tb <= '1';
        wait for CLK_PERIOD * 3;
        
        assert s_tb = '1' report "ERRO: Flag S deveria estar ativa (temperatura OK)" severity error;
        assert h_tb = '0' report "ERRO: Flag H deveria estar inativa" severity error;
        assert c_tb = '0' report "ERRO: Flag C deveria estar inativa" severity error;
        
        enab_pow_tb <= '0';
        enab_stat_tb <= '0';
        
        sim_ended <= true;
        wait;
        
    end process;
    
end Behavioral;
