library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtractor is
    Generic ( N : integer := 9);
    Port ( 
        A : in  STD_LOGIC_VECTOR (N-1 downto 0);
        B : in  STD_LOGIC_VECTOR (N-1 downto 0);
        Y : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end subtractor;

architecture Behavioral of subtractor is
begin
    Y <= std_logic_vector(signed(A) - signed(B));
end Behavioral;