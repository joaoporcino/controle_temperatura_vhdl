library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity status_decoder is
    Port (
        -- Entradas
        enable         : in  STD_LOGIC;
        power_final    : in  STD_LOGIC_VECTOR(6 downto 0);
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
    signal power_is_zero : STD_LOGIC;
begin
    -- Verifica se a potência final é zero
    power_is_zero <= '1' when unsigned(power_final) = 0 else '0';
    
    -- Flag de estado estável: quando não há necessidade de aquecer nem resfriar
    s_out <= '1' when (h_in = '0' and c_in = '0') else '0';
    
    -- Controle do motor de resfriamento
    -- Só liga se enable='1', potência não é zero, e sign_bit='1' (resfriamento)
    pow_c <= power_sign_bit when (enable = '1' and power_is_zero = '0') else '0';
    
    -- Controle do motor de aquecimento  
    -- Só liga se enable='1', potência não é zero, e sign_bit='0' (aquecimento)
    pow_h <= (not power_sign_bit) when (enable = '1' and power_is_zero = '0') else '0';
    
end Dataflow;
