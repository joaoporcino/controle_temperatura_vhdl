library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Subtrator para números COM sinal (Signed)
-- Pode ser usado para (A - B) ou para (0 - B) para obter valor absoluto
entity subtractor is
    Generic ( N : integer := 9); -- 9 bits é seguro para nossas operações internas
    Port ( 
        A : in  STD_LOGIC_VECTOR (N-1 downto 0);
        B : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Y : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end subtractor;

architecture Behavioral of subtractor is
begin
    Y <= std_logic_vector(signed(A) - signed(B));
end Behavioral;