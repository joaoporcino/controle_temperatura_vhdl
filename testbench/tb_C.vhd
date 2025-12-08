library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_C is
end tb_C;

architecture Behavioral of tb_C is
    component comparador_7bits
        Port ( 
            enab : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR(6 downto 0);
            B : in STD_LOGIC_VECTOR(6 downto 0);
            O : out STD_LOGIC

        );
    end component;
    
    signal enab_tb : STD_LOGIC := '1';
    signal input_a_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal input_b_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal equal_out_tb : STD_LOGIC;
    
    constant PERIOD : time := 10 ns;
begin
    uut: comparador_7bits port map (
        enab => enab_tb,
        A => input_a_tb,
        B => input_b_tb,
        O => equal_out_tb
    );
    
    stimulus: process
    begin
        enab_tb <= '1';
        
        -- Teste 1: A > B (100 > 20) -> O=1
        input_a_tb <= std_logic_vector(to_unsigned(100, 7));
        input_b_tb <= std_logic_vector(to_unsigned(20, 7));
        wait for PERIOD;
        assert equal_out_tb = '1' report "Erro Teste 1" severity error;
        
        wait;
    end process;
end Behavioral;