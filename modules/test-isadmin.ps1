# ================================
# Self-Elevate to Administrator
# ================================

function Ensure-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        Write-Host "Not running as admin. Relaunching with elevated privileges..." -ForegroundColor Yellow

        Start-Process powershell -Verb RunAs -ArgumentList (
            "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        )

        exit
    }
}

Ensure-Admin