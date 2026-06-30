function Set-ShellReplacement {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ExePath
    )

    try {
        Write-Log "Starting Shell Replacement configuration..." "INFO"

        # ================================
        # Step 1: Ensure C:\app exists
        # ================================
        $appDir = "C:\app"

        if (!(Test-Path $appDir)) {
            New-Item -Path $appDir -ItemType Directory -Force | Out-Null
            Write-Log "Created directory: $appDir" "SUCCESS"
        }
        else {
            Write-Log "Directory already exists: $appDir" "INFO"
        }

        # ================================
        # Step 2: Download INNUTRIRE EXE
        # ================================
        Write-Log "Downloading INNUTRIRE executable..." "INFO"

        $destinationExe = Join-Path $appDir "run.exe"

        # NOTE: Replace this URL in config.psd1 later
        $downloadUrl = $ExePath

        Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationExe

        Write-Log "Downloaded INNUTRIRE to $destinationExe" "SUCCESS"

        # ================================
        # Step 3: Configure Registry Shell Replacement
        # ================================
        Write-Log "Configuring registry shell replacement..." "INFO"

        $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

        if (!(Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }

        # Set custom shell (replaces Explorer)
        Set-ItemProperty -Path $regPath -Name "Shell" -Value $destinationExe

        Write-Log "Shell set to: $destinationExe" "SUCCESS"

        # ================================
        # Step 4: Ensure persistence safety (optional backup)
        # ================================
        $backupPath = "HKCU:\SOFTWARE\INNUTRIRE"

        if (!(Test-Path $backupPath)) {
            New-Item -Path $backupPath -Force | Out-Null
        }

        Set-ItemProperty -Path $backupPath -Name "ShellPath" -Value $destinationExe

        Write-Log "Backup registry entry created." "INFO"

        Write-Log "Shell replacement completed. Restart required." "SUCCESS"
    }
    catch {
        Write-Log "Shell replacement failed - $($_.Exception.Message)" "ERROR"
        throw
    }
}