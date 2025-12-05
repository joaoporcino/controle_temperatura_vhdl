# ============================================================================
# Script de Simulacao VHDL - Versao com Debug
# ============================================================================

$GHDL_PATH = "C:\ghdl\bin\ghdl.exe"

if (!(Test-Path $GHDL_PATH)) {
    Write-Host "GHDL nao encontrado em: $GHDL_PATH" -ForegroundColor Red
    Write-Host "Digite o caminho da pasta onde esta o GHDL: " -NoNewline
    $user_path = Read-Host
    $GHDL_PATH = "$user_path\bin\ghdl.exe"
    
    if (!(Test-Path $GHDL_PATH)) {
        Write-Host "ERRO: GHDL ainda nao encontrado!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "GHDL encontrado!" -ForegroundColor Green

$PROJECT_ROOT = $PSScriptRoot
$SRC_DIR = "$PROJECT_ROOT\src"
$TB_DIR = "$PROJECT_ROOT\testbench"
$WORK_DIR = "$PROJECT_ROOT\work"

if (!(Test-Path $WORK_DIR)) {
    New-Item -ItemType Directory -Path $WORK_DIR | Out-Null
}
Set-Location $WORK_DIR

Write-Host "`n[1/4] Compilando fonte..." -ForegroundColor Cyan

$source_files = @(
    "control.vhd", "somador.vhd", "subtrator.vhd", "shifter2.vhd",
    "shifter4.vhd", "registrador.vhd", "comparadorH.vhd", "comparadorC.vhd",
    "alertaComb.vhd", "decoder7seg.vhd", "auxi.vhd", "clock.vhd",
    "datapath.vhd", "fsm.vhd", "design.vhd"
)

$compile_errors = 0
foreach ($file in $source_files) {
    $filepath = Join-Path $SRC_DIR $file
    if (Test-Path $filepath) {
        Write-Host "  $file..." -NoNewline
        
        # Capturar stderr para mostrar erros
        $result = & $GHDL_PATH -a --std=08 $filepath 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host " OK" -ForegroundColor Green
        }
        else {
            Write-Host " ERRO" -ForegroundColor Red
            Write-Host "`n=== ERRO EM $file ===" -ForegroundColor Yellow
            Write-Host $result
            Write-Host "=====================`n" -ForegroundColor Yellow
            $compile_errors++
        }
    }
}

if ($compile_errors -gt 0) {
    Write-Host "`nTotal de erros: $compile_errors" -ForegroundColor Red
    Write-Host "Corrija os erros acima antes de continuar.`n" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nTodos os arquivos compilados com sucesso!" -ForegroundColor Green

Write-Host "`n[2/4] Testbenches disponiveis:" -ForegroundColor Cyan

$testbenches = @(
    @{Name = "tb_somador"; Desc = "Somador" },
    @{Name = "tb_subtrator"; Desc = "Subtrator" },
    @{Name = "tb_H"; Desc = "Comparador H" },
    @{Name = "tb_C"; Desc = "Comparador C" },
    @{Name = "tb_registrador"; Desc = "Registrador" },
    @{Name = "tb_shifter2"; Desc = "Shifter 2 bits" },
    @{Name = "tb_clock"; Desc = "Clock Divider" },
    @{Name = "tb_decoder7seg"; Desc = "Decoder 7seg" },
    @{Name = "tb_fsm"; Desc = "FSM" },
    @{Name = "tb_datapath"; Desc = "Datapath" }
)

for ($i = 0; $i -lt $testbenches.Count; $i++) {
    $num = $i + 1
    Write-Host "  [$num] $($testbenches[$i].Name) - $($testbenches[$i].Desc)"
}

Write-Host "`nEscolha (1-10): " -NoNewline
$choice = Read-Host

$index = [int]$choice - 1
if ($index -lt 0 -or $index -ge $testbenches.Count) {
    Write-Host "Opcao invalida!" -ForegroundColor Red
    exit 1
}

$selected_tb = $testbenches[$index].Name
Write-Host "`nSelecionado: $selected_tb" -ForegroundColor Green

Write-Host "`n[3/4] Compilando testbench..." -ForegroundColor Cyan

$tb_file = Join-Path $TB_DIR "$selected_tb.vhd"

$result = & $GHDL_PATH -a --std=08 $tb_file 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao compilar testbench!" -ForegroundColor Red
    Write-Host $result
    exit 1
}

$result = & $GHDL_PATH -e --std=08 $selected_tb 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao elaborar!" -ForegroundColor Red
    Write-Host $result
    exit 1
}

Write-Host "Testbench pronto!" -ForegroundColor Green

Write-Host "`n[4/4] EXECUTANDO SIMULACAO" -ForegroundColor Cyan
Write-Host "==========================================`n"

$vcd_file = "$selected_tb.vcd"
$stop_time = "10ms"

if ($selected_tb -eq "tb_clock") { $stop_time = "1us" }
elseif ($selected_tb -match "datapath|design") { $stop_time = "100us" }

& $GHDL_PATH -r --std=08 $selected_tb --vcd=$vcd_file --stop-time=$stop_time

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSIMULACAO CONCLUIDA!" -ForegroundColor Green
    Write-Host "Arquivo gerado: $WORK_DIR\$vcd_file"
    Write-Host "`nPara visualizar formas de onda, instale GTKWave:" -ForegroundColor Yellow
    Write-Host "  gtkwave $vcd_file" -ForegroundColor Gray
}
else {
    Write-Host "`nSimulacao falhou!" -ForegroundColor Red
}
