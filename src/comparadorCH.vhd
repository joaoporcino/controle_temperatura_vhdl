library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparador_7bits is
    Port ( 
        enab : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(6 downto 0);
        B : in STD_LOGIC_VECTOR(6 downto 0);
        
        out : out STD_LOGIC
    );
end comparador_7bits;

architecture Dataflow of comparador_7bits is
begin
    -- Corrigido o erro de sintaxe e adicionado o enable
    out <= '1' when (enab = '1' and unsigned(A) > unsigned(B)) else '0';
end Dataflow;