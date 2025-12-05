library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_subtrator is
end tb_subtrator;

architecture Behavioral of tb_subtrator is
    component subtractor
        Generic ( N : integer := 9);
        Port ( 
            A : in  STD_LOGIC_VECTOR (N-1 downto 0);
            B : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Y : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    constant N_BITS : integer := 9;
    signal A_tb : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := (others => '0');
    signal B_tb : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := (others => '0');
    signal Y_tb : STD_LOGIC_VECTOR(N_BITS-1 downto 0);

    constant PERIOD : time := 20 ns;

begin
    uut: subtractor 
    generic map (N => N_BITS)
    port map (A => A_tb, B => B_tb, Y => Y_tb);

    stimulus: process
    begin
        -- Teste 1: Subtração Positiva (50 - 20 = 30)
        A_tb <= std_logic_vector(to_signed(50, N_BITS));
        B_tb <= std_logic_vector(to_signed(20, N_BITS));
        wait for PERIOD;
        assert to_integer(signed(Y_tb)) = 30 report "Erro 50-20" severity error;

        -- Teste 2: Subtração Negativa (20 - 50 = -30)
        A_tb <= std_logic_vector(to_signed(20, N_BITS));
        B_tb <= std_logic_vector(to_signed(50, N_BITS));
        wait for PERIOD;
        assert to_integer(signed(Y_tb)) = -30 report "Erro 20-50" severity error;

        -- Teste 3: Subtração com Zero (100 - 0 = 100)
        A_tb <= std_logic_vector(to_signed(100, N_BITS));
        B_tb <= (others => '0');
        wait for PERIOD;
        assert to_integer(signed(Y_tb)) = 100 report "Erro 100-0" severity error;

        -- Teste 4: Subtração Resultando em Zero (42 - 42 = 0)
        A_tb <= std_logic_vector(to_signed(42, N_BITS));
        B_tb <= std_logic_vector(to_signed(42, N_BITS));
        wait for PERIOD;
        assert to_integer(signed(Y_tb)) = 0 report "Erro 42-42" severity error;

        wait;
    end process;
end Behavioral;