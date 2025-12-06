library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        control  : in  STD_LOGIC; -- Funciona como um "Start/Enable System"
        
        -- Flags vindas do Datapath
        c : in std_logic; -- Flag Cool (Resfriar)
        h : in std_logic; -- Flag Heat (Aquecer)
        s : in std_logic; -- Flag Stable (Estável)

        -- Saídas de Controle para o Datapath (Enables)
        enab_max_min : out STD_LOGIC;
        enab_ext_int : out STD_LOGIC;
        enab_pow : out STD_LOGIC;
        
        states_out : out STD_LOGIC_VECTOR (6 downto 0)
    );
end controller;

architecture Behavioral of controller is

    -- Definição dos Estados (Total: 7 estados listados na sua type)
    type state_type is (
        st_RESET, 
        st_LOAD,
        st_RINTEXT,   -- Lê sensores Interno/Externo
        st_CALC,      -- Habilita cálculo de potência e verifica flags
        st_COOLING,   -- Estado de resfriamento
        st_HEATING,   -- Estado de aquecimento
        st_STABLE     -- Estado estável
    );

    signal present_state, next_state : state_type;

begin

    -- PROCESSO 1: Memória de Estado (Sequencial)
    sync_proc: process(clk, rst)
    begin
        if rst = '1' then
            present_state <= st_RESET;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    -- PROCESSO 2: Lógica de Próximo Estado (Combinacional)
    next_state_proc: process(present_state, control, h, c, s)
    begin
        -- Valor padrão para manter o estado caso nenhuma condição seja satisfeita
        next_state <= present_state;

        case present_state is
            when st_RESET =>
                if control = '1' then
                    next_state <= st_LOAD;
                else
                    next_state <= st_RESET;
                end if;
                
            when st_LOAD => 
            	next_state <= st_RINTEXT;

            when st_RINTEXT =>
                -- Após ler sensores, vai para cálculo/verificação
                next_state <= st_CALC;

            when st_CALC =>
                if h = '1' then
                    next_state <= st_HEATING;
                elsif c = '1' then
                    next_state <= st_COOLING;
                elsif s = '1' then
                    next_state <= st_STABLE;
                else 
                    next_state <= st_CALC; 
                end if;

            -- Lógica de Retorno (Loop de Monitoramento)
           when st_HEATING =>
                if control = '0' then next_state <= st_RESET; 
                else                  next_state <= st_RINTEXT; -- Senão, continua aquecendo
                end if;

            when st_COOLING =>
                if control = '0' then next_state <= st_RESET;
                else                  next_state <= st_RINTEXT;
                end if;

            when st_STABLE =>
                if control = '0' then next_state <= st_RESET;
                else                  next_state <= st_RINTEXT;
                end if;
                
            when others =>
                next_state <= st_RESET;
        end case;
    end process;

    -- PROCESSO 3: Lógica de Saída (Combinacional)
    output_proc: process(present_state)
    begin
	            enab_max_min   <= '0';
                enab_ext_int   <= '0';
                enab_pow   <= '0';
                states_out <= "0000000";

        case present_state is
            when st_RESET =>
                enab_max_min   <= '1';
                enab_ext_int   <= '0';
                enab_pow   <= '0';
                states_out <= "0000001";
                
			when st_LOAD =>
                enab_max_min <= '0';
                states_out <= "0000010";
                
            when st_RINTEXT =>
                enab_max_min <= '0';
                enab_ext_int <= '1';
                enab_pow <= '0';
                states_out <= "0000100";

            when st_CALC =>
                enab_pow <= '1';
                states_out <= "0001000";

            when st_HEATING => states_out <= "0010000"; 

            when st_COOLING => states_out <= "0100000";

            when st_STABLE  => states_out <= "1000000";

            when others =>
                null;
        end case;
    end process;

end Behavioral;