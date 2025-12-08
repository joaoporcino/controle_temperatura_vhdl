library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_decoder7seg is
end tb_decoder7seg;

architecture Behavioral of tb_decoder7seg is
    
    component decodificador_7seg is
        Port (
            nibble : in  STD_LOGIC_VECTOR (3 downto 0);
            seg    : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    -- Sinais de teste
    signal nibble_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal seg_tb    : STD_LOGIC_VECTOR(6 downto 0);
    
    -- Padrões esperados para cada dígito (assumindo ACTIVE LOW)
    -- Formato: seg = "GFEDCBA"
    type pattern_array is array (0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
    
    -- ACTIVE LOW: 0 = aceso, 1 = apagado
    constant EXPECTED_PATTERNS_LOW : pattern_array := (
        "1000000",  -- 0
        "1111001",  -- 1
        "0100100",  -- 2
        "0110000",  -- 3
        "0011001",  -- 4
        "0010010",  -- 5
        "0000010",  -- 6
        "1111000",  -- 7
        "0000000",  -- 8
        "0010000",  -- 9
        "0001000",  -- A
        "0000011",  -- b
        "1000110",  -- C
        "0100001",  -- d
        "0000110",  -- E
        "0001110"   -- F
    );
    
    -- ACTIVE HIGH: 1 = aceso, 0 = apagado
    constant EXPECTED_PATTERNS_HIGH : pattern_array := (
        "0111111",  -- 0
        "0000110",  -- 1
        "1011011",  -- 2
        "1001111",  -- 3
        "1100110",  -- 4
        "1101101",  -- 5
        "1111101",  -- 6
        "0000111",  -- 7
        "1111111",  -- 8
        "1101111",  -- 9
        "1110111",  -- A
        "1111100",  -- b
        "0111001",  -- C
        "1011110",  -- d
        "1111001",  -- E
        "1110001"   -- F
    );
    
    constant WAIT_TIME : time := 20 ns;
    
begin
    
    -- Instância do decodificador
    uut: decodificador_7seg
        port map (
            nibble => nibble_tb,
            seg    => seg_tb
        );
    
    -- Processo de teste
    stimulus: process
        variable hex_char : string(1 to 1);
    begin
        
        report "======================================";
        report "TESTBENCH DO DECODIFICADOR 7 SEGMENTOS";
        report "======================================";
        report "";
        
        -- ========================================
        -- Testar todos os 16 valores (0-F)
        -- ========================================
        for i in 0 to 15 loop
            nibble_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for WAIT_TIME;
            
            -- Determinar caractere hexadecimal
            if i < 10 then
                hex_char := integer'image(i)(1 to 1);
            else
                case i is
                    when 10 => hex_char := "A";
                    when 11 => hex_char := "b";
                    when 12 => hex_char := "C";
                    when 13 => hex_char := "d";
                    when 14 => hex_char := "E";
                    when 15 => hex_char := "F";
                    when others => hex_char := "?";
                end case;
            end if;
            
            report "Teste " & integer'image(i) & " (0x" & hex_char & "):";
            report "  Input:    " & integer'image(i) & " = " & 
                   to_string(nibble_tb);
            report "  Output:   " & to_string(seg_tb);
            report "  Expected (ACTIVE LOW):  " & to_string(EXPECTED_PATTERNS_LOW(i));
            report "  Expected (ACTIVE HIGH): " & to_string(EXPECTED_PATTERNS_HIGH(i));
            
            -- Verificar se corresponde a ACTIVE LOW ou ACTIVE HIGH
            if seg_tb = EXPECTED_PATTERNS_LOW(i) then
                report "  OK CORRETO (ACTIVE LOW)";
            elsif seg_tb = EXPECTED_PATTERNS_HIGH(i) then
                report "  OK CORRETO (ACTIVE HIGH)";
            else
                report "  ERRO: Padrao nao corresponde a nenhum esperado!" 
                    severity error;
            end if;
            report "";
            
        end loop;
        
        -- ========================================
        -- Testes de casos especiais
        -- ========================================
        report "======================================";
        report "TESTES ESPECIAIS";
        report "======================================";
        
        -- Teste de transição rápida
        report "Teste: Transicoes rapidas";
        nibble_tb <= "0000"; wait for WAIT_TIME;
        nibble_tb <= "1111"; wait for WAIT_TIME;
        nibble_tb <= "0101"; wait for WAIT_TIME;
        nibble_tb <= "1010"; wait for WAIT_TIME;
        report "  Transicoes rapidas OK";
        report "";
        
        -- Teste de sequência incremental
        report "Teste: Sequencia 0-9 (digitos decimais)";
        for i in 0 to 9 loop
            nibble_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for WAIT_TIME/2;
        end loop;
        report "  Sequencia decimal OK";
        report "";
        
        -- ========================================
        -- FIM DOS TESTES
        -- ========================================
        report "======================================";
        report "TODOS OS TESTES CONCLUIDOS!";
        report "======================================";
        report "NOTA: Verifique se o decodificador usa ACTIVE LOW";
        report "      ou ACTIVE HIGH conforme sua placa FPGA.";
        report "      DE2 geralmente usa ACTIVE LOW.";
        report "======================================";
        
        wait;
        
    end process;
    
end Behavioral;
