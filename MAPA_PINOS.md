# Mapa de Pinos - Sistema de Controle de Temperatura
# Placa: Altera DE2 (Cyclone II)

## 📍 MAPEAMENTO COMPLETO

### ENTRADAS

#### Clock
- **clk_50MHz** → Clock da placa (automático, sempre ativo)

#### Switches de Controle
```
SW[1]  → rst          (Reset do sistema)
SW[2]  → control_sw   (Liga/Desliga o sistema)
```

#### Temperatura Interna/Mínima (7 bits)
```
SW[3]  → temp_int_min[0]  (LSB - bit menos significativo)
SW[4]  → temp_int_min[1]
SW[5]  → temp_int_min[2]
SW[6]  → temp_int_min[3]
SW[7]  → temp_int_min[4]
SW[8]  → temp_int_min[5]
SW[9]  → temp_int_min[6]  (MSB - bit mais significativo)
```

#### Temperatura Externa/Máxima (7 bits)
```
SW[10] → temp_ext_max[0]  (LSB)
SW[11] → temp_ext_max[1]
SW[12] → temp_ext_max[2]
SW[13] → temp_ext_max[3]
SW[14] → temp_ext_max[4]
SW[15] → temp_ext_max[5]
SW[16] → temp_ext_max[6]  (MSB)
```

---

### SAÍDAS

#### LEDs Verdes - Status do Sistema
```
LEDG[0] → led_heat     (🔴 Aquecendo)
LEDG[1] → led_cool     (🔵 Resfriando)
LEDG[2] → led_stable   (🟢 Estável)
LEDG[3] → led_alert    (🟡 Alerta)
LEDG[4] → motor_pow_c  (Motor de resfriamento ligado)
LEDG[5] → motor_pow_h  (Motor de aquecimento ligado)
```

#### LEDs Vermelhos - Potência Calculada (7 bits)
```
LEDR[0] → power_out[0]  (LSB)
LEDR[1] → power_out[1]
LEDR[2] → power_out[2]
LEDR[3] → power_out[3]
LEDR[4] → power_out[4]
LEDR[5] → power_out[5]
LEDR[6] → power_out[6]  (MSB)
```

#### Displays de 7 Segmentos
```
HEX0 → Dígito das unidades da potência
HEX1 → Dígito das dezenas da potência
```
Exemplo: Potência = 75 → HEX1 mostra "7", HEX0 mostra "5"

---

## 🎯 COMO USAR

### Exemplo 1: Temperatura baixa (precisa aquecer)

**Configuração dos Switches:**
```
SW[1]  = 0        (Sistema rodando, não resetado)
SW[2]  = 1        (Sistema ligado)
SW[3-9]  = 0011001  (Temp interna/min = 25°C)
SW[10-16] = 0010100  (Temp externa/max = 20°C)
```

**Resultado Esperado:**
```
LEDG[0] = ON  (led_heat - precisa aquecer)
LEDG[5] = ON  (motor_pow_h - motor aquecendo ligado)
HEX1-HEX0 = Mostra a potência calculada
LEDR[0-6] = Valor binário da potência
```

### Exemplo 2: Temperatura alta (precisa resfriar)

**Configuração dos Switches:**
```
SW[1]  = 0
SW[2]  = 1
SW[3-9]  = 1010000  (Temp interna/min = 80°C)
SW[10-16] = 1001011  (Temp externa/max = 75°C)
```

**Resultado Esperado:**
```
LEDG[1] = ON  (led_cool - precisa resfriar)
LEDG[4] = ON  (motor_pow_c - motor resfriando ligado)
HEX1-HEX0 = Mostra a potência calculada
```

### Exemplo 3: Temperatura estável

**Configuração dos Switches:**
```
SW[1]  = 0
SW[2]  = 1
SW[3-9]  = 0110010  (Temp int = 50°C)
SW[10-16] = 0110010  (Temp ext = 50°C)
(Com min = 45 e max = 55, configurados inicialmente)
```

**Resultado Esperado:**
```
LEDG[2] = ON  (led_stable - temperatura OK)
LEDG[4] = OFF
LEDG[5] = OFF
```

---

## 🔧 TABELA DE CONVERSÃO DECIMAL → BINÁRIO (7 bits)

| Decimal | Binário (7 bits) | Switches SW[3-9] ou SW[10-16] |
|---------|------------------|-------------------------------|
| 0       | 0000000          | Todos desligados              |
| 25      | 0011001          | 9,4,3 ligados                 |
| 50      | 0110010          | 9,6,2 ligados                 |
| 75      | 1001011          | 9,7,4,2,1 ligados             |
| 100     | 1100100          | 9,8,6,3 ligados               |
| 127     | 1111111          | Todos ligados (máximo)        |

---

## 📋 CHECKLIST DE TESTE

1. [ ] Compilar o projeto no Quartus II
2. [ ] Carregar pin_assignments.tcl no projeto
3. [ ] Programar a FPGA
4. [ ] Testar Reset (SW1)
5. [ ] Testar Control (SW2)
6. [ ] Configurar temperaturas e observar LEDs
7. [ ] Verificar displays HEX0 e HEX1
8. [ ] Testar todos os estados (HEAT, COOL, STABLE)

---

## 🚀 COMANDOS NO QUARTUS II

### Para aplicar os pin assignments:

1. **Via Interface Gráfica:**
   - Tools → Tcl Scripts...
   - Selecione `pin_assignments.tcl`
   - Clique em "Run"

2. **Via Linha de Comando:**
   ```tcl
   source pin_assignments.tcl
   ```

3. **Ou simplesmente:**
   - Abra o Assignment Editor (Assignments → Assignment Editor)
   - Os pinos já estarão configurados automaticamente

---

## 📌 NOTAS IMPORTANTES

⚠️ **Atenção:** Os displays de 7 segmentos na DE2 são **ACTIVE LOW**, ou seja:
- `0` = Segmento aceso
- `1` = Segmento apagado

Se seus displays mostrarem números invertidos, você precisa inverter os sinais no decodificador `decoder7seg.vhd`.

✅ **Verificação de Pinos:**
Após compilar, vá em:
- Assignments → Pins
- Verifique se todos os pinos foram atribuídos corretamente
