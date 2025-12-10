library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_shifter4 is
end tb_shifter4;

architecture Behavioral of tb_shifter4 is

    constant N_TB : integer := 9; 

    signal s_Din  : STD_LOGIC_VECTOR (N_TB-1 downto 0) := (others => '0');
    signal s_Dout : STD_LOGIC_VECTOR (N_TB-1 downto 0);
    
    constant WAIT_TIME : time := 20 ns;

begin

    uut: entity work.shifter4
    port map (
        power_calc_raw  => s_Din,
        power_neg => (others => '0'), 
        Dout => s_Dout
    );

    stim_proc: process
    begin
        s_Din <= std_logic_vector(to_signed(100, N_TB));
        wait for WAIT_TIME;
        
        s_Din <= std_logic_vector(to_signed(16, N_TB));
        wait for WAIT_TIME;

        s_Din <= std_logic_vector(to_signed(-100, N_TB));
        wait for WAIT_TIME;
        
        s_Din <= std_logic_vector(to_signed(-16, N_TB));
        wait for WAIT_TIME;
        
        wait;
    end process;

end Behavioral;