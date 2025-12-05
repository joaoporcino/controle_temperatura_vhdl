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
        enab_max : out STD_LOGIC;
        enab_min : out STD_LOGIC;
        enab_ext : out STD_LOGIC;
        enab_int : out STD_LOGIC;
        enab_pow : out STD_LOGIC;
        enab_flags : out STD_LOGIC;
        
        -- Saídas para o Mundo Externo (LEDs/Motores)
        -- Adicionei estas pois os estados HEATING/COOLING precisam acionar algo
        heat_out   : out STD_LOGIC;
        cool_out   : out STD_LOGIC;
        stable_out : out STD_LOGIC
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
                    next_state <= st_RINTEXT;
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
                elsif h = '0' then    next_state <= st_RINTEXT; -- Só sai se parar de precisar de Heat
                else                  next_state <= st_HEATING; -- Senão, continua aquecendo
                end if;

            when st_COOLING =>
                if control = '0' then next_state <= st_RESET;
                elsif c = '0' then    next_state <= st_RINTEXT;
                else                  next_state <= st_COOLING;
                end if;

            when st_STABLE =>
                if control = '0' then next_state <= st_RESET;
                elsif s = '0' then    next_state <= st_RINTEXT;
                else                  next_state <= st_STABLE;
                end if;
                
            when others =>
                next_state <= st_RESET;
        end case;
    end process;

    -- PROCESSO 3: Lógica de Saída (Combinacional)
    output_proc: process(present_state)
    begin
        -- Defaults (tudo zero para evitar latches e acionamentos indevidos)

        case present_state is
            when st_RESET =>
                enab_max   <= '1';
                enab_min   <= '1';
                enab_ext   <= '0';
                enab_int   <= '0';
                enab_pow   <= '0';
                heat_out   <= '0';
                cool_out   <= '0';
                stable_out <= '0';
                enab_flags <= '0';
                
			when st_LOAD =>
                enab_max <= '0';
                enab_min <= '0';
                
            when st_RINTEXT =>
                enab_max <= '0';
                enab_min <= '0';
                enab_ext <= '1';
                enab_int <= '1';
                enab_pow <= '0';
                enab_flags <= '0';-- Indica estabilidade


            when st_CALC =>
                enab_pow <= '1';
                enab_flags <= '1';-- Habilita o cálculo da potência/diferença

            when st_HEATING =>
                heat_out <= '1';
                cool_out <= '0';
                stable_out <= '0'; -- Indica estabilidade
-- Liga o resfriador
-- Liga o aquecedor

            when st_COOLING =>
                cool_out <= '1';
                heat_out <= '0';
                stable_out <= '0'; -- Indica estabilidade
-- Liga o aquecedor
-- Liga o resfriador

            when st_STABLE =>
                stable_out <= '1';
                heat_out <= '0';
                cool_out <= '0'; -- Liga o resfriador
-- Liga o aquecedor
-- Indica estabilidade

            when others =>
                null;
        end case;
    end process;

end Behavioral;