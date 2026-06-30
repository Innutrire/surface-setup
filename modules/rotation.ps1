function Set-RotationLock {
    try {
        Write-Log "Configuring rotation lock settings..." "INFO"

        # ================================
        # Primary policy key (recommended)
        # ================================
        $policyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation"

        if (!(Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        # Disable auto-rotation
        Set-ItemProperty -Path $policyPath -Name "Enable" -Value 0 -Type DWord

        Write-Log "Auto-rotation disabled via policy." "SUCCESS"

        # ================================
        # Sensor-based rotation control
        # ================================
        $sensorPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation\SensorPresent"

        if (!(Test-Path $sensorPath)) {
            New-Item -Path $sensorPath -Force | Out-Null
        }

        Set-ItemProperty -Path $sensorPath -Name "SensorPresent" -Value 0 -Type DWord

        Write-Log "Sensor-based rotation disabled." "INFO"

        # ================================
        # Optional: User-level lock
        # ================================
        $userPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation"

        if (!(Test-Path $userPath)) {
            New-Item -Path $userPath -Force | Out-Null
        }

        Set-ItemProperty -Path $userPath -Name "Enable" -Value 0 -Type DWord

        Write-Log "User-level rotation lock enforced." "INFO"

    }
    catch {
        Write-Log "Failed to configure rotation lock - $($_.Exception.Message)" "ERROR"
        throw
    }
}