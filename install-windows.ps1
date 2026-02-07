# install-windows.ps1
# Run as Administrator: Set-ExecutionPolicy Bypass -Scope Process; .\install-windows.ps1
#
# Creates symlinks from dotfiles repo to actual config locations.
# Existing files are backed up with .bak extension.

$ErrorActionPreference = "Stop"
$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Dotfiles Install (Windows) ===" -ForegroundColor Cyan
Write-Host "Dotfiles directory: $DotfilesDir" -ForegroundColor Gray

function New-Symlink {
    param (
        [string]$Source,
        [string]$Target
    )

    $ParentDir = Split-Path -Parent $Target
    if (!(Test-Path $ParentDir)) {
        New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
        Write-Host "  Created directory: $ParentDir" -ForegroundColor Gray
    }

    if (Test-Path $Target) {
        if ((Get-Item $Target).Attributes -match "ReparsePoint") {
            Remove-Item $Target -Force
            Write-Host "  Removed old symlink: $Target" -ForegroundColor Yellow
        } else {
            $BackupPath = "$Target.bak"
            Move-Item $Target $BackupPath -Force
            Write-Host "  Backed up: $Target -> $BackupPath" -ForegroundColor Yellow
        }
    }

    if (Test-Path $Source -PathType Container) {
        New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
    } else {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    }
    Write-Host "  Linked: $Target -> $Source" -ForegroundColor Green
}

# --- WezTerm ---
Write-Host "`n[WezTerm]" -ForegroundColor Magenta
New-Symlink "$DotfilesDir\windows\wezterm\.wezterm.lua" "$env:USERPROFILE\.wezterm.lua"

# --- GlazeWM ---
Write-Host "`n[GlazeWM]" -ForegroundColor Magenta
New-Symlink "$DotfilesDir\windows\glazewm\config.yaml" "$env:USERPROFILE\.glzr\glazewm\config.yaml"

# --- Zebar ---
Write-Host "`n[Zebar]" -ForegroundColor Magenta
New-Symlink "$DotfilesDir\windows\zebar\settings.json" "$env:USERPROFILE\.glzr\zebar\settings.json"
New-Symlink "$DotfilesDir\windows\zebar\styles.css" "$env:USERPROFILE\.glzr\zebar\styles.css"
New-Symlink "$DotfilesDir\windows\zebar\vanilla-clear.html" "$env:USERPROFILE\.glzr\zebar\vanilla-clear.html"
New-Symlink "$DotfilesDir\windows\zebar\vanilla-clear.zebar.json" "$env:USERPROFILE\.glzr\zebar\vanilla-clear.zebar.json"

# --- VSCode ---
Write-Host "`n[VSCode]" -ForegroundColor Magenta
New-Symlink "$DotfilesDir\windows\vscode\settings.json" "$env:APPDATA\Code\User\settings.json"

Write-Host "`n=== Windows symlinks complete! ===" -ForegroundColor Cyan
Write-Host "`nNext: Run install-wsl.sh inside WSL to set up shell configs." -ForegroundColor Gray
