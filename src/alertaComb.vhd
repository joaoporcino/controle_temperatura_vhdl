library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparadorAlerta is
    Port ( 
        enab   : in STD_LOGIC;
        vale    : in STD_LOGIC_VECTOR(6 downto 0); -- CORRIGIDO: Agora é 7 bits
        alerta : out STD_LOGIC
    );
end comparadorAlerta;

architecture Dataflow of comparadorAlerta is
    -- Defina aqui o limite (Ex: se passar de 80 de potência, alerta!)
    constant LIMITE : integer := 20; 
begin
    -- Só aciona se estiver habilitado E o valor for maior que o limite
    alerta <= '1' when (enab = '1' and unsigned(vale) > LIMITE) else '0';
end Dataflow;