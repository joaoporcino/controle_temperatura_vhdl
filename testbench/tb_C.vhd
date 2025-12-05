library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_comparadorC_7bits is
end tb_comparadorC_7bits;

architecture Behavioral of tb_comparadorC_7bits is
    component comparadorC_7bits
        Port ( 
            int : in STD_LOGIC_VECTOR(6 downto 0);
            max : in STD_LOGIC_VECTOR(6 downto 0);
            c   : out STD_LOGIC
        );
    end component;
    
    signal input_a_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal input_b_tb : STD_LOGIC_VECTOR(6 downto 0);
    signal equal_out_tb : STD_LOGIC;
    
    constant PERIOD : time := 10 ns;
begin
    uut: comparadorC_7bits port map (
        int => input_a_tb,
        max => input_b_tb,
        c => equal_out_tb
    );
    
    stimulus: process
    begin
        
        input_a_tb <= "1010101";
        input_b_tb <= "1010101";
        wait for PERIOD;
        assert equal_out_tb = '1' report "Erro Teste 1" severity error;
        
        input_a_tb <= "1010101";
        input_b_tb <= "1010100";
        wait for PERIOD;
        assert equal_out_tb = '0' report "Erro Teste 2" severity error;
        
        input_a_tb <= "0000000";
        input_b_tb <= "0000000";
        wait for PERIOD;
        assert equal_out_tb = '1' report "Erro Teste 3" severity error;
        
        
        input_a_tb <= "0000001";
        input_b_tb <= "0000000";
        wait for PERIOD;
        assert equal_out_tb = '1' report "Erro Teste 3" severity error;
        
        input_a_tb <= "1111111";
        input_b_tb <= "1111111";
        wait for PERIOD;
        assert equal_out_tb = '1' report "Erro Teste 4" severity error;
        
        input_a_tb <= "1111111";
        input_b_tb <= "1111110";
        wait for PERIOD;
        assert equal_out_tb = '0' report "Erro Teste 5" severity error;
        
        wait;
    end process;
end Behavioral;