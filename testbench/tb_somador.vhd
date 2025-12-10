library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_somador is
end tb_somador;

architecture Behavioral of tb_somador is
    component adder
        Generic ( N : integer := 7);
        Port ( 
            A : in  STD_LOGIC_VECTOR (N-1 downto 0);
            B : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Y : out STD_LOGIC_VECTOR (N downto 0)
        );
    end component;

    constant N_BITS : integer := 7;
    signal A_tb : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := (others => '0');
    signal B_tb : STD_LOGIC_VECTOR(N_BITS-1 downto 0) := (others => '0');
    signal Y_tb : STD_LOGIC_VECTOR(N_BITS downto 0);

    constant PERIOD : time := 20 ns;

begin
    uut: adder 
    generic map (N => N_BITS)
    port map (
        A => A_tb,
        B => B_tb,
        Y => Y_tb
    );

    stimulus: process
    begin
        A_tb <= "0000000"; B_tb <= "0000000";
        wait for PERIOD;
        assert to_integer(unsigned(Y_tb)) = 0 report "Erro soma zeros" severity error;

        A_tb <= std_logic_vector(to_unsigned(10, N_BITS)); 
        B_tb <= std_logic_vector(to_unsigned(20, N_BITS));
        wait for PERIOD;
        assert to_integer(unsigned(Y_tb)) = 30 report "Erro soma 10+20" severity error;

        A_tb <= (others => '1'); 
        B_tb <= (others => '1');
        wait for PERIOD;
        assert to_integer(unsigned(Y_tb)) = 254 report "Erro soma maxima" severity error;

        A_tb <= "1000000"; 
        B_tb <= "1000000";
        wait for PERIOD;
        assert to_integer(unsigned(Y_tb)) = 128 report "Erro soma bit extra" severity error;

        wait;
    end process;
end Behavioral;