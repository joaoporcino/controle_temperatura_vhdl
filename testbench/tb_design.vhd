library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_design is
end tb_design;

architecture Behavioral of tb_design is

    component controle_temperatura
        Port (
            clk_sys      : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            temp_int_min : in  STD_LOGIC_VECTOR(6 downto 0);
            temp_ext_max : in  STD_LOGIC_VECTOR(6 downto 0);
            states_out   : out STD_LOGIC_VECTOR(5 downto 0);
            motor_pow_c  : out STD_LOGIC;
            motor_pow_h  : out STD_LOGIC;
            led_alert    : out STD_LOGIC;
            hex0         : out STD_LOGIC_VECTOR(6 downto 0);
            hex1         : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    
    signal input_1 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); 
    signal input_2 : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); 
    
    signal states_out : STD_LOGIC_VECTOR(5 downto 0);
    signal led_heat, led_cool, led_alert : STD_LOGIC;
    signal hex0, hex1 : STD_LOGIC_VECTOR(6 downto 0);
    
    constant CLK_PERIOD : time := 20 ns;
    signal sim_ended : boolean := false;

begin

    uut: controle_temperatura Port Map (
        clk_sys => clk,
        rst => rst,
        temp_int_min => input_1,
        temp_ext_max => input_2,
        states_out => states_out,
        motor_pow_c => led_cool,
        motor_pow_h => led_heat,
        led_alert => led_alert,
        hex0 => hex0,
        hex1 => hex1
    );

    process begin
        while not sim_ended loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    process begin
        rst <= '1'; 
        
        input_1 <= std_logic_vector(to_unsigned(100, 7)); 
        input_2 <= std_logic_vector(to_unsigned(100, 7)); 
        
        wait for 100 ns; 
        
        rst <= '0';
        wait for 50 ns;
        
        wait for 200 ns; 

        input_1 <= std_logic_vector(to_unsigned(0, 7)); 
        input_2 <= std_logic_vector(to_unsigned(0, 7)); 
        
        wait for 800 ns; 
        
        input_1 <= std_logic_vector(to_unsigned(10, 7));
        wait for 800 ns;
        
        assert led_heat = '1' report "ERRO [3]: Deveria estar AQUECENDO." severity error;

        input_1 <= std_logic_vector(to_unsigned(50, 7));
        wait for 800 ns;
        
        assert led_cool = '1' report "ERRO [4]: Deveria estar RESFRIANDO." severity error;

        wait for 50 ns;
        
        rst <= '1'; 
        
        input_1 <= std_logic_vector(to_unsigned(50, 7)); 
        input_2 <= std_logic_vector(to_unsigned(60, 7)); 
        
        wait for 100 ns;
        
        rst <= '0'; 
        wait for 50 ns;
        
        wait for 200 ns; 
        
        input_1 <= std_logic_vector(to_unsigned(50, 7)); 
        input_2 <= std_logic_vector(to_unsigned(55, 7)); 
        
        wait for 800 ns;
        
        assert led_cool = '0' report "ERRO [5]: Ainda acha que 50 eh calor (nao carregou novo Max)." severity error;

        sim_ended <= true;
        wait;
    end process;

end Behavioral;