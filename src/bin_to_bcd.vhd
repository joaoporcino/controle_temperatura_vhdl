library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_to_bcd is
    Port (
        bin_in  : in  STD_LOGIC_VECTOR(6 downto 0); -- Entrada binária 0-127
        dezena  : out STD_LOGIC_VECTOR(3 downto 0); -- Dígito das dezenas (0-12)
        unidade : out STD_LOGIC_VECTOR(3 downto 0)  -- Dígito das unidades (0-9)
    );
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
    signal bin_unsigned : unsigned(6 downto 0);
    signal dezena_temp  : unsigned(6 downto 0);
    signal unidade_temp : unsigned(6 downto 0);
begin
    bin_unsigned <= unsigned(bin_in);
    
    -- Divide por 10 para obter dezena
    dezena_temp <= bin_unsigned / 10;
    
    -- Resto da divisão por 10 para obter unidade
    unidade_temp <= bin_unsigned mod 10;
    
    -- Converte para 4 bits
    dezena  <= std_logic_vector(dezena_temp(3 downto 0));
    unidade <= std_logic_vector(unidade_temp(3 downto 0));
    
end Behavioral;
