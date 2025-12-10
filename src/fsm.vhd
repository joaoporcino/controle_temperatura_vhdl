library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        control  : in  STD_LOGIC;
        
        c : in std_logic; 
        h : in std_logic; 
        s : in std_logic;

		enab_max_min : out STD_LOGIC;
        enab_ext_int : out STD_LOGIC;
        enab_pow : out STD_LOGIC;
		  enab_stat : out STD_LOGIC;
        
        states_out : out STD_LOGIC_VECTOR (5 downto 0)
    );
end controller;

architecture Behavioral of controller is

    type state_type is (
        st_RESET, 
        st_RINTEXT,
        st_CALC,
        st_COOLING,
        st_HEATING,
        st_STABLE
    );

    signal present_state, next_state : state_type;

begin

    sync_proc: process(clk, rst)
    begin
        if rst = '1' then
            present_state <= st_RESET;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    output_proc: process(present_state)
    begin
	            enab_max_min   <= '0';
                enab_ext_int   <= '0';
                enab_pow   <= '0';
					 enab_stat <= '0';
                states_out <= "000000";
		         next_state <= present_state;


        case present_state is
            when st_RESET =>
                enab_max_min   <= '1';
                enab_ext_int   <= '0';
                enab_pow   <= '0';
					 enab_stat <= '0';
                states_out <= "000001";
					 
					 if control = '1' then
                    next_state <= st_RINTEXT;
                else
                    next_state <= st_RESET;
                end if;
                
            when st_RINTEXT =>
                enab_max_min <= '0';
                enab_ext_int <= '1';
                enab_pow <= '0';
					 enab_stat <= '0';
                states_out <= "000010";
					 next_state <= st_CALC;


            when st_CALC =>
                enab_pow <= '1';
					 enab_ext_int <= '0';
					 enab_stat <= '0';
                states_out <= "000100";
					 
					 if h = '1' then
                    next_state <= st_HEATING;
                elsif c = '1' then
                    next_state <= st_COOLING;
                elsif s = '1' then
                    next_state <= st_STABLE;
                else 
                    next_state <= st_CALC; 
                end if;

            when st_HEATING => 
					 states_out <= "001000"; 
                enab_stat <= '1';
					 enab_pow <= '0';
					 
					 if control = '0' then next_state <= st_RESET; 
                else                  next_state <= st_RINTEXT;
                end if;

            when st_COOLING => 
					 states_out <= "010000";
                enab_stat <= '1';
					 enab_pow <= '0';
					 
					 if control = '0' then next_state <= st_RESET;
                else                  next_state <= st_RINTEXT;
                end if;

            when st_STABLE  => 
					 states_out <= "100000";
                enab_stat <= '1';
					 enab_pow <= '0';
					 
					 if control = '0' then next_state <= st_RESET;
                else                  next_state <= st_RINTEXT;
                end if;

            when others =>
					next_state <= st_RESET;
        end case;
    end process;

end Behavioral;