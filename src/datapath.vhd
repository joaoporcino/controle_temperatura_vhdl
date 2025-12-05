library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        temp_int_min : in STD_LOGIC_VECTOR(6 downto 0);
        temp_ext_max : in STD_LOGIC_VECTOR(6 downto 0);
        enab_max-min: in STD_LOGIC;
        enab_ext-int : in STD_LOGIC;
        enab_pow : in STD_LOGIC; 
        c : out STD_LOGIC;
        h : out STD_LOGIC;
        s : out STD_LOGIC;
        pow_c : out STD_LOGIC; 
        pow_h : out STD_LOGIC; 
		ctrl  : out STD_LOGIC;
        alert     : out STD_LOGIC;
        hex0      : out STD_LOGIC_VECTOR(6 downto 0);
        hex1      : out STD_LOGIC_VECTOR(6 downto 0)
    );
end datapath;

architecture Structural of datapath is

    component adder is
        Generic ( N : integer := 7 );
        Port ( A, B : in STD_LOGIC_VECTOR (N-1 downto 0); Y : out STD_LOGIC_VECTOR (N downto 0));
    end component;

    component subtractor is
        Generic ( N : integer := 9 );
        Port ( A, B : in STD_LOGIC_VECTOR (N-1 downto 0); Y : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component;

    component shifter4 is
        Generic ( N : integer := 9; SHIFT_AMT : integer := 1 );
        Port ( power_calc_raw  : STD_LOGIC_VECTOR(8 downto 0);
				  power_neg : in STD_LOGIC_VECTOR (8 downto 0);
				  Dout : out STD_LOGIC_VECTOR (8 downto 0));
    end component;

    component comparador_7bits is 
        Port ( enab : in STD_LOGIC; int, max : in STD_LOGIC_VECTOR(6 downto 0); c : out STD_LOGIC );
    end component;
    
    component comparadorAlerta is
        Port ( enab : in STD_LOGIC; val : in STD_LOGIC_VECTOR(6 downto 0); alerta : out STD_LOGIC );
    end component;
    
    component status_decoder is
        Port (
            enable, h_in, c_in : in  STD_LOGIC;
            power_sign_bit     : in  STD_LOGIC;
            s_out              : out STD_LOGIC;
            pow_c, pow_h       : out STD_LOGIC
        );
    end component;
	 
	 component control_decoder is
        Port ( reset : in STD_LOGIC; not_reset : out STD_LOGIC );
    end component;

    component registrador is
        Port ( clk, rst, en : in STD_LOGIC; d_in : in STD_LOGIC_VECTOR(6 downto 0); q_out : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    component decodificador_7seg is
        Port ( nibble : in STD_LOGIC_VECTOR (3 downto 0); seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    -- Sinais Internos
    signal reg_temp_int, reg_temp_ext : STD_LOGIC_VECTOR(6 downto 0);
    signal reg_temp_max, reg_temp_min : STD_LOGIC_VECTOR(6 downto 0);
    
    signal sum_max_min    : STD_LOGIC_VECTOR(7 downto 0);
    signal avg_res        : STD_LOGIC_VECTOR(8 downto 0);
    signal int_signed     : STD_LOGIC_VECTOR(8 downto 0);
    signal ext_signed     : STD_LOGIC_VECTOR(8 downto 0);
    
    -- Sinais intermediários da matemática
    signal sub_res_1      : STD_LOGIC_VECTOR(8 downto 0);
    signal sub_res_2      : STD_LOGIC_VECTOR(8 downto 0);
    
    signal power_calc_raw : STD_LOGIC_VECTOR(8 downto 0); 
    signal power_neg      : STD_LOGIC_VECTOR(8 downto 0);
    signal power_shifted  : STD_LOGIC_VECTOR(8 downto 0);
    signal power_mag_7bit : STD_LOGIC_VECTOR(6 downto 0); 
    
    signal power_final    : STD_LOGIC_VECTOR(6 downto 0); 
    signal h_internal, c_internal : STD_LOGIC;
    signal upper_nibble : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- 1. Registradores
    R_INT: registrador port map (clk=>clk, rst=>rst, en=>enab_ext-int, d_in=>temp_int_min, q_out=>reg_temp_int);
    R_MIN: registrador port map (clk=>clk, rst=>rst, en=>enab_max-min, d_in=>temp_int_min, q_out=>reg_temp_min);
    R_EXT: registrador port map (clk=>clk, rst=>rst, en=>enab_ext-int, d_in=>temp_ext_max, q_out=>reg_temp_ext);
    R_MAX: registrador port map (clk=>clk, rst=>rst, en=>enab_max-min, d_in=>temp_ext_max, q_out=>reg_temp_max);

    -- 2. Comparadores
    COMP_H: comparador_7bits port map (enab => enab_pow, A => reg_temp_min, B => reg_temp_int, out => h_internal);
    COMP_C: comparador_7bits port map (enab => enab_pow, A => reg_temp_int, B => reg_temp_max, out => c_internal);
	 
	 
    U_CONTROL_DEC: control_decoder port map ( reset => rst, not_reset => ctrl);
    
    h <= h_internal;
    c <= c_internal;

    -- 3. Matemática
    U_ADD: adder generic map (N => 7) port map (A => reg_temp_max, B => reg_temp_min, Y => sum_max_min);
    avg_res <= "00" & sum_max_min(7 downto 1);

    int_signed <= "00" & reg_temp_int;
    ext_signed <= "00" & reg_temp_ext;

   
    U_SUB1: subtractor generic map (N => 9) port map (A => avg_res, B => int_signed, Y => sub_res_1);
    
    -- Subtração 2
    U_SUB2: subtractor generic map (N => 9) port map (A => ext_signed, B => int_signed, Y => sub_res_2);

    -- Subtração Final (Pega direto os resultados das subtrações anteriores)
    U_SUB_FIN: subtractor generic map (N => 9) port map (A => sub_res_1, B => sub_res_2, Y => power_calc_raw);

    -- 4. Status Decoder
    U_STATUS_DEC: status_decoder
        port map (
            enable         => enab_pow,
            h_in           => h_internal,
            c_in           => c_internal,
            power_sign_bit => power_calc_raw(8),
            s_out          => s,
            pow_c          => pow_c,
            pow_h          => pow_h
        );

    -- 5. Magnitude e Final Shift
    U_SUB_NEG: subtractor generic map (N => 9) port map (A => (others=>'0'), B => power_calc_raw, Y => power_neg);

    U_FINAL_SHIFT: shifter4 generic map (N => 9, SHIFT_AMT => 2) 
        port map (power_calc_raw => power_calc_raw, power_neg => power_neg, Dout => power_shifted);

    power_mag_7bit <= power_shifted(6 downto 0);

    U_REG_POWER: registrador 
        port map (
            clk => clk, rst => rst, en => enab_pow, d_in => power_mag_7bit, q_out => power_final
        );

    -- 6. Saídas
    U_ALERT: comparadorAlerta 
        port map (enab => enab_pow, val => power_final, alerta => alert);

    U_HEX0: decodificador_7seg port map (nibble => power_final(3 downto 0), seg => hex0);
    upper_nibble <= '0' & power_final(6 downto 4);
    U_HEX1: decodificador_7seg port map (nibble => upper_nibble, seg => hex1);

end Structural;