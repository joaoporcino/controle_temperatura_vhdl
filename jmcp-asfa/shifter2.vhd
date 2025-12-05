library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Realiza deslocamento aritmético para a direita (Preserva o sinal)
-- Equivale a divisão por 2^SHIFT_AMT
entity shifter is
    Generic ( 
        N : integer := 9;
        SHIFT_AMT : integer := 1
    );
    Port ( 
        Din  : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Dout : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end shifter;

architecture Behavioral of shifter is
begin
    -- shift_right aritmético mantém o bit de sinal para números negativos
    Dout <= std_logic_vector(shift_right(signed(Din), SHIFT_AMT));
end Behavioral;