# Heavy initialization - only loaded when FAST_START != '1'

# ---------- 1. Starship Prompt ----------
if (-not $script:StarshipInitialized) {
    Invoke-Expression (&starship init powershell)
    $script:StarshipInitialized = $true
}

# ---------- 1-ALT. Oh-My-Posh (with caching) - COMMENTED OUT ----------
# Uncomment this section if you want to switch back to Oh My Posh
<#
$themeConfig = "$env:POSH_THEMES_PATH/spaceship.omp.json"
$themeCache  = "$env:LOCALAPPDATA\ohmyposh\cached_spaceship.ps1"

# Ensure cache directory exists
$cacheDir = Split-Path $themeCache -Parent
if (-not (Test-Path $cacheDir)) {
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
}

# Regenerate cache only if theme changed
if (-not (Test-Path $themeCache) -or
    (Get-Item $themeCache).LastWriteTime -lt (Get-Item $themeConfig).LastWriteTime) {
    oh-my-posh init pwsh --config $themeConfig > $themeCache
}
. $themeCache
#>

# ---------- 2. fastfetch (startup only, not on every shell) ----------
# Only show on first shell in session
if (-not $env:FASTFETCH_SHOWN) {
    #fastfetch
    $env:FASTFETCH_SHOWN = '1'
}

# ---------- 3. Terminal Icons ----------
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# ---------- 4. zoxide ----------
if (-not $script:ZoxideInitialized) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
    $script:ZoxideInitialized = $true
}

# ---------- 5. PSReadLine ----------
Import-Module PSReadLine -ErrorAction SilentlyContinue
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -PredictionViewStyle ListView

# ---------- 6. PowerToys CommandNotFound ----------
Import-Module -Name Microsoft.WinGet.CommandNotFound -ErrorAction SilentlyContinue

# ---------- 7. FancyClearHost (optional) ----------
# Mode (Flipping, Falling, Bricks)
function FancyClear {
    Clear-HostFancily -Mode Flipping -Speed 3
}
Set-Alias -Name clss FancyClear -Option AllScope

# ----------- 8. Python HTTP Server -------------
function Serve-Folder {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [int]$Port = 8000,

        [string]$PythonExe = "python"
    )

    # Validate folder
    if (-not (Test-Path $Path)) {
        Write-Error "Folder '$Path' does not exist."
        return
    }

    # Get local IPv4 address
    $ip = (Get-NetIPAddress -AddressFamily IPv4 `
            | Where-Object { $_.InterfaceAlias -match "Wi-Fi" -and $_.IPAddress -notlike "169.*" } `
            | Select-Object -First 1 -ExpandProperty IPAddress)

    if (-not $ip) {
        $ip = (Get-NetIPAddress -AddressFamily IPv4 `
                | Where-Object { $_.IPAddress -notlike "169.*" } `
                | Select-Object -First 1 -ExpandProperty IPAddress)
    }

    Write-Host "📂 Serving folder: $Path"
    Write-Host "🌐 Access locally: http://localhost:$Port"
    if ($ip) {
        Write-Host "📱 Access on LAN: http://${ip}:{$Port}"
    } else {
        Write-Warning "Could not detect LAN IP address."
    }

    # Start Python HTTP server
    Push-Location $Path
    try {
        & $PythonExe -m http.server $Port
    } finally {
        Pop-Location
        Write-Host "🛑 Server stopped."
    }
}

# ----------- 9. Anifetch (Fastfetch Animated) -------------
function af {
    anifetch "$HOME\pictures\gotchard-gatchanko.gif" -ca "--symbols block"
  }
