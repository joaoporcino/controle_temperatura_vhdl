$GHDL = "$env:USERPROFILE\AppData\Local\Microsoft\WinGet\Packages\ghdl.ghdl.ucrt64.mcode_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\ghdl.exe"
$FLAGS = "--std=08"

Write-Host "=== COMPILING SOURCES ===" -ForegroundColor Cyan
$sources = @(
    "src/control.vhd", "src/somador.vhd", "src/subtrator.vhd", 
    "src/shifter2.vhd", "src/shifter4.vhd", "src/registrador.vhd", 
    "src/comparadorCH.vhd", "src/alertaComb.vhd", "src/decoder7seg.vhd", 
    "src/auxi.vhd", "src/bin_to_bcd.vhd", "src/datapath.vhd", 
    "src/fsm.vhd", "src/controle_temperatura.vhd"
)

foreach ($src in $sources) {
    Write-Host "Compiling $src..." -NoNewline
    & $GHDL -a $FLAGS $src 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host " OK" -ForegroundColor Green }
    else { Write-Host " FAIL" -ForegroundColor Red; exit 1 }
}

Write-Host "`n=== COMPILING TESTBENCHES ===" -ForegroundColor Cyan
$tbs = @(
    "tb_somador", "tb_subtrator", "tb_shifter2", "tb_shifter4", 
    "tb_registrador", "tb_decoder7seg", "tb_H", "tb_C", 
    "tb_datapath", "tb_fsm", "tb_controle_temperatura", "tb_design",
    "tb_cooling", "tb_heating", "tb_stable", "tb_clock", "tb_comparador_diferente"
)

foreach ($tb in $tbs) {
    Write-Host "Compiling $tb.vhd..." -NoNewline
    & $GHDL -a $FLAGS "testbench/$tb.vhd" 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host " OK" -ForegroundColor Green }
    else { Write-Host " FAIL" -ForegroundColor Red }
}

Write-Host "`n=== RUNNING SIMULATIONS ===" -ForegroundColor Cyan
foreach ($tb in $tbs) {
    Write-Host "Running $tb..." -NoNewline
    $stop_time = "10us"
    if ($tb -eq "tb_clock") { $stop_time = "2us" } # Shorten clock test
    if ($tb -match "controle_temperatura|design") { $stop_time = "100us" }

    $output = & $GHDL -r $FLAGS $tb --stop-time=$stop_time 2>&1
    if ($LASTEXITCODE -eq 0) { 
        Write-Host " PASS" -ForegroundColor Green 
    } else { 
        Write-Host " FAIL" -ForegroundColor Red 
        Write-Host $output -ForegroundColor Gray
    }
}
