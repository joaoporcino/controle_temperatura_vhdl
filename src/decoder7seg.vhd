library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador_7seg is
    Port ( 
        nibble : in  STD_LOGIC_VECTOR (3 downto 0); -- 4 bits de entrada
        seg    : out STD_LOGIC_VECTOR (6 downto 0)  -- g f e d c b a
    );
end decodificador_7seg;

architecture Dataflow of decodificador_7seg is
begin
    process(nibble)
    begin
        case nibble is
            --                  gfedcba (ACTIVE LOW: 0=aceso, 1=apagado)
            when "0000" => seg <= NOT "1111111"; -- 0
            when "0001" => seg <= NOT "0000110"; -- 1
            when "0010" => seg <= NOT "1011011"; -- 2
            when "0011" => seg <= NOT "1001111"; -- 3
            when "0100" => seg <= NOT "1100110"; -- 4
            when "0101" => seg <= NOT "1101101"; -- 5
            when "0110" => seg <= NOT "1111101"; -- 6
            when "0111" => seg <= NOT "0000111"; -- 7
            when "1000" => seg <= NOT "1111111"; -- 8
            when "1001" => seg <= NOT "1101111"; -- 9
            -- Valores acima de 9: Display apagado (todos 1s)
            when others => seg <= "1111111"; -- Apagado (ACTIVE LOW)
        end case;
    end process;
end Dataflow;