LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY bin_to_bcd IS
    PORT (
        enable : IN STD_LOGIC;
        bin_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        dezena : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        unidade : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END bin_to_bcd;

ARCHITECTURE Behavioral OF bin_to_bcd IS
BEGIN
    PROCESS(enable, bin_in)
        VARIABLE bin_unsigned : unsigned(6 DOWNTO 0);
        VARIABLE dezena_value : unsigned(3 DOWNTO 0);
        VARIABLE unidade_value : unsigned(3 DOWNTO 0);
    BEGIN
        IF enable = '1' THEN
            bin_unsigned := unsigned(bin_in);
            dezena_value := bin_unsigned / 10;
            unidade_value := bin_unsigned MOD 10;
            
            dezena <= STD_LOGIC_VECTOR(dezena_value);
            unidade <= STD_LOGIC_VECTOR(unidade_value);
        ELSE
            dezena <= (others => '0');
            unidade <= (others => '0');
        END IF;
    END PROCESS;

END Behavioral;