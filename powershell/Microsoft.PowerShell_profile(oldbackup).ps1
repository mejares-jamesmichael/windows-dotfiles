# Aliases
Set-Alias vim nvim
Set-Alias s spf
Set-Alias lg lazygit
Set-Alias ld lazydocker
Set-Alias ff fastfetch
Set-Alias op opencode
Set-Alias gem gemini
Set-Alias qwn qwen
Set-Alias cop copilot

# UTF-8 everywhere
try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    [void](chcp 65001)
} catch {
    Write-Warning "Failed to set UTF-8 encoding: $_"
}

# Environment variables
$Env:YAZI_FILE_ONE = 'C:\Program Files\Git\usr\bin\file.exe'

# Functions (lightweight, no external calls)
# yazi
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}

# superfile
function spf() {
    param ([string[]]$Params)
    $spf_location = "C:\Users\James Michael\AppData\Local\Microsoft\WinGet\Packages\yorukot.superfile_Microsoft.Winget.Source_8wekyb3d8bbwe\dist\superfile-windows-v1.4.0-amd64\spf.exe"
    $SPF_LAST_DIR_PATH = [Environment]::GetFolderPath("LocalApplicationData") + "\superfile\lastdir"
    & $spf_location @Params
    if (Test-Path $SPF_LAST_DIR_PATH) {
        $SPF_LAST_DIR = Get-Content -Path $SPF_LAST_DIR_PATH
        Invoke-Expression $SPF_LAST_DIR
        Remove-Item -Force $SPF_LAST_DIR_PATH
    }
}

# Go directly to the Programming Directory located at C drive (I have a symlink also that points to user directory)
function dev { cd C:\kaelDev\Programming }

# Go at home ~ directory instantly
function home { cd ~ }

# Run Chris-Titus-Tool
function Run-CTT {
    Start-Process wt -Verb RunAs -ArgumentList `
      '--title "CTT WinUtil" pwsh.exe -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://christitus.com/win | iex"'
}

# Fast-start flag - skip heavy stuff
if ($env:FAST_START -ne '1') {
    . "$HOME\.config\powershell\heavy.ps1"
}
