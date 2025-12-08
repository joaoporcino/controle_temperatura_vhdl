# ============================================================================
# Script de Simulacao VHDL - Versao com Debug
# ============================================================================

$GHDL_PATH = "C:\ghdl\bin\ghdl.exe"
$WINGET_PATH = "C:\Users\João\AppData\Local\Microsoft\WinGet\Packages\ghdl.ghdl.ucrt64.mcode_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\ghdl.exe"

if (Get-Command ghdl -ErrorAction SilentlyContinue) {
    $GHDL_PATH = (Get-Command ghdl).Source
}
elseif (Test-Path $WINGET_PATH) {
    $GHDL_PATH = $WINGET_PATH
}
elseif (!(Test-Path $GHDL_PATH)) {
    Write-Host "GHDL nao encontrado em: $GHDL_PATH" -ForegroundColor Red
    Write-Host "Digite o caminho da pasta onde esta o GHDL (ex: C:\ghdl): " -NoNewline
    $user_path = Read-Host
    
    # Remove \bin se o usuario incluiu
    if ($user_path.EndsWith("\bin")) {
        $user_path = $user_path.Substring(0, $user_path.Length - 4)
    }
    
    $GHDL_PATH = "$user_path\bin\ghdl.exe"
    
    if (!(Test-Path $GHDL_PATH)) {
        Write-Host "ERRO: GHDL ainda nao encontrado em $GHDL_PATH" -ForegroundColor Red
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
    "shifter4.vhd", "registrador.vhd", "comparadorCH.vhd", "bin_to_bcd.vhd",
    "alertaComb.vhd", "decoder7seg.vhd", "auxi.vhd", "clock.vhd",
    "datapath.vhd", "fsm.vhd", "controle_temperatura.vhd"
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
    @{Name = "tb_datapath"; Desc = "Datapath" },
    @{Name = "tb_controle_temperatura"; Desc = "Top Level System" }
)

Write-Host "  [0] Run All Testbenches"
for ($i = 0; $i -lt $testbenches.Count; $i++) {
    $num = $i + 1
    Write-Host "  [$num] $($testbenches[$i].Name) - $($testbenches[$i].Desc)"
}

Write-Host "`nEscolha (0-$($testbenches.Count)): " -NoNewline
$choice = Read-Host

$index = [int]$choice - 1
$run_all = $false

if ($choice -eq "0") {
    $run_all = $true
    Write-Host "`nSelecionado: TODOS OS TESTES" -ForegroundColor Green
}
elseif ($index -lt 0 -or $index -ge $testbenches.Count) {
    Write-Host "Opcao invalida!" -ForegroundColor Red
    exit 1
}
else {
    $selected_tb = $testbenches[$index].Name
    Write-Host "`nSelecionado: $selected_tb" -ForegroundColor Green
}

# Function to run a single testbench
function Run-Testbench ($tb_name) {
    Write-Host "`n--------------------------------------------------"
    Write-Host "Executando: $tb_name" -ForegroundColor Cyan
    Write-Host "--------------------------------------------------"
    
    $tb_file = Join-Path $TB_DIR "$tb_name.vhd"
    
    # Compile
    $result = & $GHDL_PATH -a --std=08 $tb_file 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao compilar $tb_name!" -ForegroundColor Red
        Write-Host $result
        return $false
    }
    
    # Elaborate
    $result = & $GHDL_PATH -e --std=08 $tb_name 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao elaborar $tb_name!" -ForegroundColor Red
        Write-Host $result
        return $false
    }
    
    # Run
    $vcd_file = "$tb_name.vcd"
    $stop_time = "10ms"
    if ($tb_name -eq "tb_clock") { $stop_time = "1us" }
    elseif ($tb_name -match "datapath|design") { $stop_time = "100us" }
    
    & $GHDL_PATH -r --std=08 $tb_name --vcd=$vcd_file --stop-time=$stop_time
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCESSO: $tb_name" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "FALHA: $tb_name" -ForegroundColor Red
        return $false
    }
}

if ($run_all) {
    $failed_tests = 0
    foreach ($tb in $testbenches) {
        if (!(Run-Testbench $tb.Name)) {
            $failed_tests++
        }
    }
    
    Write-Host "`n=========================================="
    if ($failed_tests -eq 0) {
        Write-Host "TODOS OS TESTES PASSARAM!" -ForegroundColor Green
    }
    else {
        Write-Host "$failed_tests TESTES FALHARAM!" -ForegroundColor Red
    }
    Write-Host "=========================================="
}
else {
    Run-Testbench $selected_tb
}
