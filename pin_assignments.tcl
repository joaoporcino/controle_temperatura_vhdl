# ============================================================================
# Pin Assignments para Sistema de Controle de Temperatura
# FPGA: Altera Cyclone II (DE2 Board)
# Arquivo: pin_assignments.tcl
# ============================================================================

# ----------------------------------------------------------------------------
# CLOCK
# ----------------------------------------------------------------------------
set_location_assignment PIN_N2 -to clk_50MHz

# ----------------------------------------------------------------------------
# RESET e CONTROL
# ----------------------------------------------------------------------------
set_location_assignment PIN_N26 -to rst         ;# Switch SW[1]
set_location_assignment PIN_P25 -to control_sw  ;# Switch SW[2]

# ----------------------------------------------------------------------------
# TEMPERATURA INTERNA/MINIMA (7 bits) - SW[3] a SW[9]
# ----------------------------------------------------------------------------
set_location_assignment PIN_AE14 -to temp_int_min[0]  ;# SW[3]
set_location_assignment PIN_AF14 -to temp_int_min[1]  ;# SW[4]
set_location_assignment PIN_AD13 -to temp_int_min[2]  ;# SW[5]
set_location_assignment PIN_AC13 -to temp_int_min[3]  ;# SW[6]
set_location_assignment PIN_C13  -to temp_int_min[4]  ;# SW[7]
set_location_assignment PIN_B13  -to temp_int_min[5]  ;# SW[8]
set_location_assignment PIN_A13  -to temp_int_min[6]  ;# SW[9]

# ----------------------------------------------------------------------------
# TEMPERATURA EXTERNA/MAXIMA (7 bits) - SW[10] a SW[16]
# ----------------------------------------------------------------------------
set_location_assignment PIN_N1 -to temp_ext_max[0]  ;# SW[10]
set_location_assignment PIN_P1 -to temp_ext_max[1]  ;# SW[11]
set_location_assignment PIN_P2 -to temp_ext_max[2]  ;# SW[12]
set_location_assignment PIN_T7 -to temp_ext_max[3]  ;# SW[13]
set_location_assignment PIN_U3 -to temp_ext_max[4]  ;# SW[14]
set_location_assignment PIN_U4 -to temp_ext_max[5]  ;# SW[15]
set_location_assignment PIN_V1 -to temp_ext_max[6]  ;# SW[16]

# ----------------------------------------------------------------------------
# LEDs DE STATUS
# ----------------------------------------------------------------------------
set_location_assignment PIN_AE22 -to led_heat    ;# LEDG[0]
set_location_assignment PIN_AF22 -to led_cool    ;# LEDG[1]
set_location_assignment PIN_W19  -to led_stable  ;# LEDG[2]
set_location_assignment PIN_V18  -to led_alert   ;# LEDG[3]

# ----------------------------------------------------------------------------
# MOTORES (Sinais de Potência)
# ----------------------------------------------------------------------------
set_location_assignment PIN_U18 -to motor_pow_c  ;# LEDG[4] - Motor Cooling
set_location_assignment PIN_U17 -to motor_pow_h  ;# LEDG[5] - Motor Heating

# ----------------------------------------------------------------------------
# SAIDA DE POTENCIA (7 bits) - LEDs Vermelhos LEDR[0] a LEDR[6]
# ----------------------------------------------------------------------------
set_location_assignment PIN_AE23 -to power_out[0]  ;# LEDR[0]
set_location_assignment PIN_AF23 -to power_out[1]  ;# LEDR[1]
set_location_assignment PIN_AB21 -to power_out[2]  ;# LEDR[2]
set_location_assignment PIN_AC22 -to power_out[3]  ;# LEDR[3]
set_location_assignment PIN_AD22 -to power_out[4]  ;# LEDR[4]
set_location_assignment PIN_AD23 -to power_out[5]  ;# LEDR[5]
set_location_assignment PIN_AD21 -to power_out[6]  ;# LEDR[6]

# ----------------------------------------------------------------------------
# DISPLAY DE 7 SEGMENTOS - HEX0 (Unidades)
# ----------------------------------------------------------------------------
set_location_assignment PIN_AF10 -to hex0[0]  ;# Segmento A
set_location_assignment PIN_AB12 -to hex0[1]  ;# Segmento B
set_location_assignment PIN_AC12 -to hex0[2]  ;# Segmento C
set_location_assignment PIN_AD11 -to hex0[3]  ;# Segmento D
set_location_assignment PIN_AE11 -to hex0[4]  ;# Segmento E
set_location_assignment PIN_V14  -to hex0[5]  ;# Segmento F
set_location_assignment PIN_V13  -to hex0[6]  ;# Segmento G

# ----------------------------------------------------------------------------
# DISPLAY DE 7 SEGMENTOS - HEX1 (Dezenas)
# ----------------------------------------------------------------------------
set_location_assignment PIN_V20 -to hex1[0]  ;# Segmento A
set_location_assignment PIN_V21 -to hex1[1]  ;# Segmento B
set_location_assignment PIN_W21 -to hex1[2]  ;# Segmento C
set_location_assignment PIN_Y22 -to hex1[3]  ;# Segmento D
set_location_assignment PIN_AA24 -to hex1[4]  ;# Segmento E
set_location_assignment PIN_AA23 -to hex1[5]  ;# Segmento F
set_location_assignment PIN_AB24 -to hex1[6]  ;# Segmento G

# ============================================================================
# CONFIGURACOES DE I/O
# ============================================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_50MHz
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to control_sw
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to temp_int_min[*]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to temp_ext_max[*]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_heat
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_cool
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_stable
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_alert
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to motor_pow_c
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to motor_pow_h
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to power_out[*]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0[*]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1[*]
