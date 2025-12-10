library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_decoder7seg is
end tb_decoder7seg;

architecture Behavioral of tb_decoder7seg is
    
    component decodificador_7seg is
        Port (
            nibble : in  STD_LOGIC_VECTOR (3 downto 0);
            seg    : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    signal nibble_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal seg_tb    : STD_LOGIC_VECTOR(6 downto 0);
    
    constant WAIT_TIME : time := 20 ns;
    
begin
    
    uut: decodificador_7seg
        port map (
            nibble => nibble_tb,
            seg    => seg_tb
        );
    
    stimulus: process
    begin
        
        for i in 0 to 15 loop
            nibble_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for WAIT_TIME;
        end loop;
        
        nibble_tb <= "0000"; wait for WAIT_TIME;
        nibble_tb <= "1111"; wait for WAIT_TIME;
        nibble_tb <= "0101"; wait for WAIT_TIME;
        nibble_tb <= "1010"; wait for WAIT_TIME;
        
        wait;
        
    end process;
    
end Behavioral;
