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
            --                  gfedcba
            when "0000" => seg <= "0111111"; -- 0
            when "0001" => seg <= "0000110"; -- 1
            when "0010" => seg <= "1011011"; -- 2
            when "0011" => seg <= "1001111"; -- 3
            when "0100" => seg <= "1100110"; -- 4
            when "0101" => seg <= "1101101"; -- 5
            when "0110" => seg <= "1111101"; -- 6
            when "0111" => seg <= "0000111"; -- 7
            when "1000" => seg <= "1111111"; -- 8
            when "1001" => seg <= "1101111"; -- 9
            when "1010" => seg <= "1110111"; -- A
            when "1011" => seg <= "1111100"; -- b
            when "1100" => seg <= "0111001"; -- C
            when "1101" => seg <= "1011110"; -- d
            when "1110" => seg <= "1111001"; -- E
            when "1111" => seg <= "1110001"; -- F
            when others => seg <= "0000000"; -- Apagado
        end case;
    end process;
end Dataflow;