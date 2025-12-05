library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Somador simples para entradas sem sinal
entity adder is
    Generic ( N : integer := 7);
    Port ( 
        A : in  STD_LOGIC_VECTOR (N-1 downto 0);
        B : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Y : out STD_LOGIC_VECTOR (N downto 0) -- Output tem 1 bit a mais para o carry
    );
end adder;

architecture Behavioral of adder is
begin
    -- Soma unsigned estendendo a saída
    Y <= std_logic_vector(resize(unsigned(A), N+1) + resize(unsigned(B), N+1));
end Behavioral;