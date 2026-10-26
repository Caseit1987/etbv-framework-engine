<#
.SYNOPSIS
    Startup wrapper script for the Eternal Trust Boundary Validation (ETBV) Engine.
.DESCRIPTION
    Initializes the Layer 0 environment, validates local system dependencies,
    and deploys the deterministic engine loop under isolated constraints.
#>

$ConfigFile = "etbv.json"
$EngineScript = "etbv_engine.py"
$HostAddress = "localhost"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "🛡️ INITIALIZING ETERNAL TRUST BOUNDARY VALIDATION 🛡️" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "[*] System User: $env:USERNAME" -ForegroundColor Gray
Write-Host "[*] Active Workspace Directory: $PWD" -ForegroundColor Gray

# Step 1: Verify presence of Layer 0 Configuration
if (-not (Test-Path $ConfigFile)) {
    Write-Error "[-] Critical: Configuration profile ($ConfigFile) is missing from the directory root."
    Write-Host "[-] Structural initialization aborted." -ForegroundColor Red
    Exit 1
}

Write-Host "[+] Found Layer 0 profile validation matrix: $ConfigFile" -ForegroundColor Green

# Step 2: Validate engine script readiness
if (-not (Test-Path $EngineScript)) {
    Write-Error "[-] Critical: Engine execution binary ($EngineScript) not found in the path."
    Exit 1
}

# Step 3: Bind environment to localhost interface restrictions
Write-Host "[*] Restricting framework deployment interface to: $HostAddress" -ForegroundColor Yellow
$env:PYTHONIOENCODING = "utf-8"

# Step 4: Execute the Deterministic Engine Pipeline
Write-Host "[*] Booting Layer 0 deterministic engine core..." -ForegroundColor Cyan
Write-Host "----------------------------------------------------" -ForegroundColor Gray

try {
    python $EngineScript
} catch {
    Write-Error "[-] An execution breakdown occurred within the Python runtime pipeline: $_"
    Exit 1
}

Write-Host "----------------------------------------------------" -ForegroundColor Gray
Write-Host "[+] ETBV Layer 0 loop execution check complete." -ForegroundColor Green
