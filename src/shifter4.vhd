library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shifter4 is
    Generic ( 
        N : integer := 9;
        SHIFT_AMT : integer := 2
    );
    Port ( 
        power_calc_raw  : STD_LOGIC_VECTOR(8 downto 0);
		  power_neg : in STD_LOGIC_VECTOR (8 downto 0);
        Dout : out STD_LOGIC_VECTOR (8 downto 0)
    );
	 signal power_abs_9bit : STD_LOGIC_VECTOR(8 downto 0);
end shifter4;

architecture Behavioral of shifter4 is
begin
	 power_abs_9bit <= power_neg when power_calc_raw(8) = '1' else power_calc_raw;
    Dout <= std_logic_vector(shift_right(signed(power_abs_9bit), SHIFT_AMT));
end Behavioral;