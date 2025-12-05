library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparadorC_7bits is
    Port ( 
        enab : in STD_LOGIC;
        int : in STD_LOGIC_VECTOR(6 downto 0);
        max : in STD_LOGIC_VECTOR(6 downto 0);
        
        c : out STD_LOGIC
    );
end comparadorC_7bits;

architecture Dataflow of comparadorC_7bits is
begin
    -- Corrigido o erro de sintaxe e adicionado o enable
    c <= '1' when (enab = '1' and unsigned(int) > unsigned(max)) else '0';
end Dataflow;