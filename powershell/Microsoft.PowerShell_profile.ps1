# Aliases
Set-Alias vim nvim
Set-Alias s spf
Set-Alias lg lazygit
Set-Alias ld lazydocker
Set-Alias ff fastfetch
Set-Alias op opencode
Set-Alias kr  kiro-cli
Set-Alias cop copilot
Set-Alias wheree where.exe
Set-Alias spotfy spotify_player
Set-Alias kf keifu
Set-Alias zj zellij
Set-Alias tm tmux

#env Editor variable = Microsoft Edit (edit) Neovim (nvim)
$env:EDITOR = "nvim"

# UTF-8 everywhere
try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    [void](chcp 65001)
} catch {
    Write-Warning "Failed to set UTF-8 encoding: $_"
}

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
    $spf_location = "C:\Users\James Michael\scoop\apps\superfile\current\spf.exe"
    $SPF_LAST_DIR_PATH = [Environment]::GetFolderPath("LocalApplicationData") + "\superfile\lastdir"
    & $spf_location @Params
    if (Test-Path $SPF_LAST_DIR_PATH) {
        $SPF_LAST_DIR = Get-Content -Path $SPF_LAST_DIR_PATH
        Invoke-Expression $SPF_LAST_DIR
        Remove-Item -Force $SPF_LAST_DIR_PATH
    }
}

#claude code wrapper
function claude {
    # Replace all spaced paths in environment variables
    Get-ChildItem Env: | ForEach-Object {
        if ($_.Value -match "James Michael") {
            Set-Item "Env:$($_.Name)" ($_.Value -replace "James Michael", "JamesMichael")
        }
    }
    & "C:\Users\JamesMichael\.local\bin\claude.exe" @args
    # Restore after exit
    Get-ChildItem Env: | ForEach-Object {
        if ($_.Value -match "JamesMichael") {
            Set-Item "Env:$($_.Name)" ($_.Value -replace "JamesMichael", "James Michael")
        }
    }
}

# Go directly to the Programming Directory located at C drive (I have a symlink also that points to user directory)
function dev { cd C:\kaelDev\Programming }

# Go at home ~ directory instantly
function home { cd ~ }

# Television shell integration (Ctrl+T for files, Ctrl+R for history)
Invoke-Expression (tv init power-shell | Out-String)

# Open fuzzy file picker and launch in Neovim
function tvim { nvim $(tv) }

# Fuzzy search file contents and open in Neovim
function ttext { nvim $(tv text) }

# Fuzzy search and cd into a directory
function tcd { cd $(tv dirs) }

# Switch git branch with fuzzy search
function tbranch { git checkout $(git branch --all | tv) }

# Find a git repo and cd into it
function trepo { cd $(tv git-repos) }

# Fuzzy search env variables
function tenv { tv env }

# Tmux create session from the root directory
function tnew { 
    param([string]$name = (Split-Path $PWD -Leaf))
    tmux new -s $name -c $PWD
}

# Run Chris-Titus-Tool
function Run-CTT {
    Start-Process wt -Verb RunAs -ArgumentList `
      '--title "CTT WinUtil" pwsh.exe -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://christitus.com/win | iex"'
}

# Fast-start flag - skip heavy stuff
if ($env:FAST_START -ne '1') {
    . "$HOME\.config\powershell\heavy.ps1"
}

