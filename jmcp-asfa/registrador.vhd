library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrador is
    Port (
        clk   : in  STD_LOGIC;
        rst   : in  STD_LOGIC;
        en    : in  STD_LOGIC;
        d_in  : in  STD_LOGIC_VECTOR(6 downto 0);
        q_out : out STD_LOGIC_VECTOR(6 downto 0)
    );
end registrador;

architecture Behavioral of registrador is

    signal reg : STD_LOGIC_VECTOR(6 downto 0);

begin

    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                reg <= d_in;
            end if;
        end if;
    end process;

    q_out <= reg;

end Behavioral;
