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
    
    signal temp_int_min : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal temp_ext_max : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    
    signal states_out : STD_LOGIC_VECTOR(5 downto 0);
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
        rst <= '1';
        temp_int_min <= std_logic_vector(to_unsigned(10, 7)); 
        temp_ext_max <= std_logic_vector(to_unsigned(20, 7)); 
        wait for 200 ns;
        
        rst <= '0';
        wait for 20 ns;
        temp_ext_max <= std_logic_vector(to_unsigned(120, 7)); 
        
        for i in 24 downto 1 loop 
            temp_int_min <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
        end loop;

        temp_int_min <= std_logic_vector(to_unsigned(5, 7)); 
        
        for i in 24 downto 1 loop
            temp_ext_max <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
        end loop;

        rst <= '1';
        temp_int_min <= std_logic_vector(to_unsigned(110, 7)); 
        temp_ext_max <= std_logic_vector(to_unsigned(120, 7)); 
        wait for 200 ns;
        
        rst <= '0';
        wait for 20 ns;
        temp_ext_max <= std_logic_vector(to_unsigned(10, 7)); 
        
        for i in 2 to 23 loop 
            temp_int_min <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
        end loop;

        temp_int_min <= std_logic_vector(to_unsigned(115, 7)); 
        
        for i in 2 to 23 loop
            temp_ext_max <= std_logic_vector(to_unsigned(i * 5, 7));
            wait for 200 ns;
        end loop;

        sim_ended <= true;
        wait;
    end process;

end Behavioral;