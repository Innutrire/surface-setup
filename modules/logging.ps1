# ================================
# Global Log Path
# ================================
$Global:LogPath = "C:\app\deployment.log"

# Ensure log directory exists
$logDir = Split-Path $Global:LogPath
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# ================================
# Logging Function
# ================================
function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "[$timestamp] [$Level] $Message"

    # Write to console with color
    switch ($Level) {
        "INFO"    { Write-Host $logEntry -ForegroundColor Gray }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "WARN"    { Write-Host $logEntry -ForegroundColor Yellow }
        "ERROR"   { Write-Host $logEntry -ForegroundColor Red }
    }

    # Append to file
    Add-Content -Path $Global:LogPath -Value $logEntry
}

# ================================
# Initialize Log File (Header)
# ================================
Write-Log "========================================" "INFO"
Write-Log "INNUTRIRE Deployment Started" "INFO"
Write-Log "Log File: $Global:LogPath" "INFO"
Write-Log "========================================" "INFO"