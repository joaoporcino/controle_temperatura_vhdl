library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_decoder is
    Port (
        -- Entradas
        h_in           : in  STD_LOGIC; -- Flag Heat do comparador
        c_in           : in  STD_LOGIC; -- Flag Cool do comparador
        power_sign_bit : in  STD_LOGIC; -- Bit de sinal da potência (Bit 8)

        -- Saídas
        s_out : out STD_LOGIC; -- Flag Stable
        pow_c : out STD_LOGIC; -- Direção Resfriar
        pow_h : out STD_LOGIC  -- Direção Aquecer
    );
end status_decoder;

architecture Dataflow of status_decoder is
begin
    -- Lógica de Estável: Se não está aquecendo nem resfriando
    s_out <= '1' when (h_in = '0' and c_in = '0') else '0';

    -- Lógica de Direção do Motor baseada no sinal
    -- Se bit 8 é '1' (negativo) -> Resfriar
    pow_c <= power_sign_bit;
    
    -- Se bit 8 é '0' (positivo) -> Aquecer
    pow_h <= not power_sign_bit;

end Dataflow;