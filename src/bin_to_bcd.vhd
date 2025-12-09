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
    SIGNAL bin_unsigned : unsigned(6 DOWNTO 0);
    SIGNAL dezena_temp : unsigned(6 DOWNTO 0);
    SIGNAL unidade_temp : unsigned(6 DOWNTO 0);
BEGIN
    IF enable = 1 THEN
        bin_unsigned <= unsigned(bin_in);

        dezena_temp <= bin_unsigned / 10;

        unidade_temp <= bin_unsigned MOD 10;

        dezena <= STD_LOGIC_VECTOR(dezena_temp(3 DOWNTO 0));
        unidade <= STD_LOGIC_VECTOR(unidade_temp(3 DOWNTO 0));
    END IF;

END Behavioral;