library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controle_temperatura is
    Port (
        clk_sys : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        
        -- Entradas
        temp_int_min : in STD_LOGIC_VECTOR(6 downto 0);
        temp_ext_max : in STD_LOGIC_VECTOR(6 downto 0);

        -- Saídas Visuais (LEDs de Estado)
        states_out : out STD_LOGIC_VECTOR (6 downto 0);
        
        motor_pow_c : out STD_LOGIC; -- Sinal de força para Resfriar
        motor_pow_h : out STD_LOGIC; -- Sinal de força para Aquecer
		  led_alert   : out STD_LOGIC;
        
        -- Displays
        hex0       : out STD_LOGIC_VECTOR(6 downto 0);
        hex1       : out STD_LOGIC_VECTOR(6 downto 0)
    );
end controle_temperatura;

architecture Structural of controle_temperatura is

	 component controller is
		Port(
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        control  : in  STD_LOGIC; 
        c : in std_logic; 
        h : in std_logic; 
        s : in std_logic; 
        enab_max_min : out STD_LOGIC;
        enab_ext_int : out STD_LOGIC;
        enab_pow : out STD_LOGIC;
		  led_alert : out STD_LOGIC;
        states_out : out STD_LOGIC_VECTOR (6 downto 0)
		); 
	 end component;
		
	component datapath is
	    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        temp_int_min : in STD_LOGIC_VECTOR(6 downto 0);
        temp_ext_max : in STD_LOGIC_VECTOR(6 downto 0);
        enab_max_min: in STD_LOGIC;
        enab_ext_int : in STD_LOGIC;
        enab_pow : in STD_LOGIC;
        c : out STD_LOGIC;
        h : out STD_LOGIC;
        s : out STD_LOGIC;
        pow_c : out STD_LOGIC; 
        pow_h : out STD_LOGIC; 
		  ctrl :  out STD_LOGIC;
        alert     : out STD_LOGIC;
        hex0      : out STD_LOGIC_VECTOR(6 downto 0);
        hex1      : out STD_LOGIC_VECTOR(6 downto 0)
        );
	end component;
	 
    -- Fios de Controle
    signal w_enab_max_min : STD_LOGIC;
    signal w_enab_ext_int : STD_LOGIC;
    signal w_enab_pow: STD_LOGIC;
	signal CTRL_CONC : STD_LOGIC;

    -- Fios de Flags
    signal w_flag_c, w_flag_h, w_flag_s : STD_LOGIC;

begin

    U_CONTROLLER: entity work.controller
        port map (
            clk        => clk_sys,
            rst        => rst,
            control    => CTRL_CONC,
            c          => w_flag_c,
            h          => w_flag_h,
            s          => w_flag_s,
            enab_max_min  => w_enab_max_min,
            enab_ext_int  => w_enab_ext_int,
            enab_pow   => w_enab_pow,
            states_out => states_out
        );

    U_DATAPATH: entity work.datapath
        port map (
            clk           => clk_sys,
            rst           => rst,
            temp_int_min  => temp_int_min,
            temp_ext_max  => temp_ext_max,
            enab_max_min  => w_enab_max_min,
            enab_ext_int  => w_enab_ext_int,
            enab_pow      => w_enab_pow,
            c            => w_flag_c,
            h            => w_flag_h,
            s            => w_flag_s,

            pow_c        => motor_pow_c, 
            pow_h        => motor_pow_h,
			   ctrl         => CTRL_CONC,

            
            alert    => led_alert,
            hex0         => hex0,
            hex1         => hex1
        );

end Structural;