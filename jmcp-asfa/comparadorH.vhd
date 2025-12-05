library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparadorH_7bits is
    Port ( 
        enab : in STD_LOGIC;
        int : in STD_LOGIC_VECTOR(6 downto 0);
        min : in STD_LOGIC_VECTOR(6 downto 0);
        
        h : out STD_LOGIC
    );
end comparadorH_7bits;

architecture Dataflow of comparadorH_7bits is
begin
    -- Só liga 'h' se estiver habilitado E a temperatura for menor que o mínimo
    h <= '1' when (enab = '1' and unsigned(int) < unsigned(min)) else '0';
end Dataflow;