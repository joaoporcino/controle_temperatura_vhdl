# Guia Rápido de Simulação VHDL

## 🎯 Opção 1: Script Automático (RECOMENDADO)

### Passo a Passo:

1. **Abra o PowerShell** no diretório do projeto:
   ```powershell
   cd "c:\Users\070212\OneDrive - Construtora Barbosa Mello SA\Área de Trabalho\Coisas\Faculdade\ENGENHARIA DE SISTEMAS\2025-02\LAB SISTEMAS DIGITAIS\trabalho_final"
   ```

2. **Execute o script:**
   ```powershell
   .\run_simulation.ps1
   ```

3. **Escolha o testbench** que deseja executar (1-12)

4. **Aguarde** a compilação e execução

5. **Visualize** as formas de onda no GTKWave (se instalado)

---

## 🛠️ Opção 2: Comandos Manuais

### Executar um testbench específico:

```powershell
# Navegar para o diretório
cd "c:\Users\070212\OneDrive - Construtora Barbosa Mello SA\Área de Trabalho\Coisas\Faculdade\ENGENHARIA DE SISTEMAS\2025-02\LAB SISTEMAS DIGITAIS\trabalho_final"

# Criar pasta de trabalho
mkdir work
cd work

# 1. Compilar arquivos fonte (na ordem de dependências)
ghdl -a ..\src\control.vhd
ghdl -a ..\src\somador.vhd
ghdl -a ..\src\subtrator.vhd
ghdl -a ..\src\shifter2.vhd
ghdl -a ..\src\shifter4.vhd
ghdl -a ..\src\registrador.vhd
ghdl -a ..\src\comparadorH.vhd
ghdl -a ..\src\comparadorC.vhd
ghdl -a ..\src\alertaComb.vhd
ghdl -a ..\src\decoder7seg.vhd
ghdl -a ..\src\auxi.vhd
ghdl -a ..\src\clock.vhd
ghdl -a ..\src\datapath.vhd
ghdl -a ..\src\fsm.vhd
ghdl -a ..\src\design.vhd

# 2. Compilar testbench desejado (exemplo: tb_fsm)
ghdl -a ..\testbench\tb_fsm.vhd

# 3. Elaborar (linkar)
ghdl -e tb_fsm

# 4. Executar simulação e gerar VCD
ghdl -r tb_fsm --vcd=tb_fsm.vcd --stop-time=10ms

# 5. Visualizar formas de onda
gtkwave tb_fsm.vcd
```

---

## 📋 Lista de Testbenches

| Testbench | Comando | Descrição |
|-----------|---------|-----------|
| tb_H | `ghdl -a ..\testbench\tb_H.vhd && ghdl -e tb_H && ghdl -r tb_H` | Comparador H |
| tb_C | Similar ao acima | Comparador C |
| tb_somador | Similar ao acima | Somador |
| tb_subtrator | Similar ao acima | Subtrator |
| tb_registrador | Similar ao acima | Registrador |
| tb_shifter2 | Similar ao acima | Shifter 2 bits |
| tb_shifter4 | Similar ao acima | Shifter 4 bits |
| tb_decoder7seg | Similar ao acima | Decoder 7seg |
| tb_clock | Similar ao acima | Clock divider |
| tb_fsm | Similar ao acima | FSM |
| tb_datapath | Similar ao acima | Datapath |
| tb_design | Similar ao acima | Sistema completo |

---

## ⚠️ Solução de Problemas

### Erro: "ghdl não é reconhecido"
**Solução:** Adicione GHDL ao PATH ou use o caminho completo:
```powershell
C:\GHDL\bin\ghdl -a arquivo.vhd
```

### Erro de compilação: "entity not found"
**Solução:** Compile os arquivos na ordem correta (dependências primeiro)

### Erro: "STOP_TIME exceeded"
**Solução:** Aumente o tempo de simulação:
```powershell
ghdl -r tb_nome --stop-time=100ms
```

### GTKWave não abre
**Solução:** Verifique se está instalado ou abra manualmente:
```powershell
"C:\Program Files (x86)\gtkwave\bin\gtkwave.exe" arquivo.vcd
```

---

## 🎨 Dicas GTKWave

1. **Adicionar sinais:**
   - Na árvore à esquerda, selecione os sinais
   - Arraste para a janela de ondas

2. **Zoom:**
   - `Ctrl + Scroll` ou botões de zoom

3. **Buscar transições:**
   - Setas para próxima/anterior transição

4. **Salvar configuração:**
   - File → Write Save File → Salvar como `.gtkw`
   - Na próxima vez: `gtkwave arquivo.vcd arquivo.gtkw`

---

## 📊 Exemplo Completo: Testando FSM

```powershell
# Passo a passo completo
cd trabalho_final
mkdir work
cd work

# Compilar tudo
ghdl -a ..\src\*.vhd
ghdl -a ..\testbench\tb_fsm.vhd

# Elaborar
ghdl -e tb_fsm

# Executar
ghdl -r tb_fsm --vcd=fsm_wave.vcd --stop-time=500ns

# Visualizar
gtkwave fsm_wave.vcd

# No GTKWave:
# 1. Adicione os sinais: clk, rst, control, present_state
# 2. Adicione as flags: h, c, s
# 3. Adicione os enables: enab_max, enab_min, etc.
# 4. Observe as transições de estado!
```

---

## 🚀 Atalho Rápido

Crie um arquivo `quick_test.bat` com:

```batch
@echo off
cd work
ghdl -a ..\src\*.vhd
ghdl -a ..\testbench\tb_%1.vhd
ghdl -e tb_%1
ghdl -r tb_%1 --vcd=tb_%1.vcd
gtkwave tb_%1.vcd
```

**Uso:**
```cmd
quick_test fsm
quick_test datapath
quick_test somador
```

---

## 📝 Notas Importantes

- **VHDL-2008**: Se houver erros, tente adicionar `--std=08` nos comandos
- **Tempo de simulação**: Ajuste `--stop-time` conforme necessário
- **Arquivos VCD**: Podem ficar grandes, delete após visualizar
- **MAX_COUNT no clock**: Use `5` para simulação rápida, `25000000` para hardware

---

## ✅ Checklist de Simulação

- [ ] GHDL instalado e no PATH
- [ ] GTKWave instalado
- [ ] Todos os arquivos fonte compilam sem erro
- [ ] Testbench compila sem erro
- [ ] Simulação executa e gera VCD
- [ ] Formas de onda visualizadas no GTKWave
