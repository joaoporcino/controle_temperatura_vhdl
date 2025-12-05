library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity status_decoder is
    Port (
        -- Entradas
        enable         : in  STD_LOGIC;
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
    s_out <= '1' when (h_in = '0' and c_in = '0') else '0';

    pow_c <= power_sign_bit when enable = '1' else '0';
    pow_h <= not power_sign_bit when enable = '1' else '0';
end Dataflow;