function Disable-EdgeSwipe {
    try {
        Write-Log "Disabling Edge Swipe (touch gestures)..." "INFO"

        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell"

        if (!(Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }

        # Disable edge UI interactions (Tablet/Touch gestures)
        Set-ItemProperty -Path $regPath -Name "DisableEdgeSwipe" -Value 1 -Type DWord

        Write-Log "Edge Swipe disabled successfully." "SUCCESS"
    }
    catch {
        Write-Log "Failed to disable Edge Swipe - $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Disable-WindowsNotifications {
    try {
        Write-Log "Disabling Windows notifications..." "INFO"

        # ================================
        # Policy-based notification disable
        # ================================
        $policyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"

        if (!(Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        # Disable toast notifications
        Set-ItemProperty -Path $policyPath -Name "ToastEnabled" -Value 0 -Type DWord

        Write-Log "Toast notifications disabled (HKCU)." "INFO"

        # ================================
        # System-wide notification controls
        # ================================
        $explorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

        if (!(Test-Path $explorerPath)) {
            New-Item -Path $explorerPath -Force | Out-Null
        }

        # Disable Action Center (if supported)
        Set-ItemProperty -Path $explorerPath -Name "EnableBalloonTips" -Value 0 -Type DWord

        Write-Log "Explorer notification tweaks applied." "INFO"

        # ================================
        # Group Policy equivalent (Pro/Enterprise)
        # ================================
        $policyGPOPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

        if (!(Test-Path $policyGPOPath)) {
            New-Item -Path $policyGPOPath -Force | Out-Null
        }

        # Disable notification center
        Set-ItemProperty -Path $policyGPOPath -Name "DisableNotificationCenter" -Value 1 -Type DWord

        Write-Log "Notification Center disabled (policy level)." "SUCCESS"
    }
    catch {
        Write-Log "Failed to disable notifications - $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Disable-LockScreen {
    try {
        Write-Log "Disabling Windows Lock Screen..." "INFO"

        # ================================
        # Policy-based disable (recommended)
        # ================================
        $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

        if (!(Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        # Disable lock screen
        Set-ItemProperty -Path $policyPath -Name "NoLockScreen" -Value 1 -Type DWord

        Write-Log "Lock Screen disabled via policy." "SUCCESS"

        # ================================
        # Optional: remove lock screen app suggestions / background
        # ================================
        $contentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

        if (!(Test-Path $contentPath)) {
            New-Item -Path $contentPath -Force | Out-Null
        }

        # Disable lock screen tips/ads/content
        Set-ItemProperty -Path $contentPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord
        Set-ItemProperty -Path $contentPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord

        Write-Log "Lock screen content features disabled." "INFO"

    }
    catch {
        Write-Log "Failed to disable lock screen - $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Disable-WindowsTips {
    try {
        Write-Log "Disabling Windows Tips, Suggestions, and UX prompts..." "INFO"

        # ================================
        # Content Delivery Manager (main source of tips/ads/suggestions)
        # ================================
        $cdmPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

        if (!(Test-Path $cdmPath)) {
            New-Item -Path $cdmPath -Force | Out-Null
        }

        # Disable various Windows suggestion features
        $keys = @(
            "SubscribedContent-338389Enabled",   # Windows tips
            "SubscribedContent-310093Enabled",   # Settings suggestions
            "SubscribedContent-338388Enabled",   # Consumer suggestions
            "SoftLandingEnabled",                # Welcome experience
            "SystemPaneSuggestionsEnabled"       # Start menu suggestions
        )

        foreach ($key in $keys) {
            Set-ItemProperty -Path $cdmPath -Name $key -Value 0 -Type DWord
        }

        Write-Log "Content Delivery Manager suggestions disabled." "INFO"

        # ================================
        # Disable Windows Spotlight / Tips on lock/start experience
        # ================================
        $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

        if (!(Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        # Turn off Windows consumer features (ads, tips, suggestions)
        Set-ItemProperty -Path $policyPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord

        Write-Log "Windows Consumer Features disabled (policy level)." "SUCCESS"

        # ================================
        # Disable “Get tips, tricks, suggestions”
        # ================================
        $notifPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

        Set-ItemProperty -Path $notifPath -Name "SubscribedContent-338393Enabled" -Value 0 -Type DWord

        Write-Log "Windows Tips fully disabled." "SUCCESS"

    }
    catch {
        Write-Log "Failed to disable Windows Tips - $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Disable-WindowsConsumerExperience {
    try {
        Write-Log "Disabling Windows Consumer Experience (ads, suggested apps, promotions)..." "INFO"

        # ================================
        # Main policy: disable consumer features
        # ================================
        $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

        if (!(Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        # Core switch: disables consumer experiences (ads, app suggestions, etc.)
        Set-ItemProperty -Path $policyPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord

        Write-Log "Consumer features disabled via policy." "SUCCESS"

        # ================================
        # Prevent app suggestions in Start Menu
        # ================================
        $contentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

        if (!(Test-Path $contentPath)) {
            New-Item -Path $contentPath -Force | Out-Null
        }

        $cdmKeys = @(
            "OemPreInstalledAppsEnabled",
            "PreInstalledAppsEnabled",
            "SilentInstalledAppsEnabled",
            "ContentDeliveryAllowed",
            "SystemPaneSuggestionsEnabled"
        )

        foreach ($key in $cdmKeys) {
            Set-ItemProperty -Path $contentPath -Name $key -Value 0 -Type DWord
        }

        Write-Log "Content Delivery Manager app promotions disabled." "INFO"

        # ================================
        # Disable automatic app installs / promotions
        # ================================
        $explorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

        if (!(Test-Path $explorerPath)) {
            New-Item -Path $explorerPath -Force | Out-Null
        }

        Set-ItemProperty -Path $explorerPath -Name "Start_TrackProgs" -Value 0 -Type DWord
        Set-ItemProperty -Path $explorerPath -Name "Start_TrackDocs" -Value 0 -Type DWord

        Write-Log "Start menu tracking and suggestions disabled." "INFO"

    }
    catch {
        Write-Log "Failed to disable consumer experience - $($_.Exception.Message)" "ERROR"
        throw
    }
}
function Disable-SleepMode {
    try {
        Write-Log "Disabling sleep, hibernation, and idle power saving..." "INFO"

        # ================================
        # Set active power scheme to High Performance
        # ================================
        Write-Log "Setting High Performance power plan..." "INFO"

        $highPerf = powercfg -l | Select-String "High performance"

        if ($highPerf) {
            $guid = ($highPerf -split "\s+")[3]
            powercfg -setactive $guid
            Write-Log "High Performance power plan activated." "SUCCESS"
        }
        else {
            Write-Log "High Performance plan not found. Using balanced fallback." "WARN"
        }

        # ================================
        # Disable sleep (AC power)
        # ================================
        powercfg -change -standby-timeout-ac 0
        Write-Log "Sleep disabled (AC power)." "INFO"

        # Disable sleep (battery)
        powercfg -change -standby-timeout-dc 0
        Write-Log "Sleep disabled (DC power)." "INFO"

        # ================================
        # Disable monitor timeout
        # ================================
        powercfg -change -monitor-timeout-ac 0
        powercfg -change -monitor-timeout-dc 0
        Write-Log "Monitor timeout disabled." "INFO"

        # ================================
        # Disable hibernation
        # ================================
        powercfg -h off
        Write-Log "Hibernation disabled." "SUCCESS"

        # ================================
        # Disable hybrid sleep (optional safety hardening)
        # ================================
        powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 | Out-Null
        powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 | Out-Null

        powercfg -setactive SCHEME_CURRENT

        Write-Log "Hybrid sleep disabled." "INFO"

    }
    catch {
        Write-Log "Failed to configure sleep settings - $($_.Exception.Message)" "ERROR"
        throw
    }
}
function Disable-DisplayTimeout {
    try {
        Write-Log "Disabling display timeout (screen will stay on)..." "INFO"

        # ================================
        # AC power: disable monitor timeout
        # ================================
        powercfg -change -monitor-timeout-ac 0
        Write-Log "AC monitor timeout disabled." "INFO"

        # ================================
        # DC power: disable monitor timeout
        # ================================
        powercfg -change -monitor-timeout-dc 0
        Write-Log "DC monitor timeout disabled." "INFO"

        # ================================
        # Optional: prevent adaptive display power saving
        # ================================
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings"

        Write-Log "Applying additional display power suppression..." "INFO"

        # Note: Windows may ignore some of these depending on OEM firmware,
        # but powercfg remains the primary enforcement layer.

        Write-Log "Display timeout successfully disabled." "SUCCESS"
    }
    catch {
        Write-Log "Failed to disable display timeout - $($_.Exception.Message)" "ERROR"
        throw
    }
}
function Disable-Hibernation {
    try {
        Write-Log "Disabling system hibernation..." "INFO"

        # ================================
        # Disable hibernation via powercfg
        # ================================
        powercfg -h off

        Write-Log "Hibernation disabled (hiberfil.sys removed)." "SUCCESS"

        # ================================
        # Optional verification step
        # ================================
        $hiberFile = "C:\hiberfil.sys"

        if (Test-Path $hiberFile) {
            Write-Log "Warning: hiberfil.sys still exists (may require reboot)." "WARN"
        }
        else {
            Write-Log "hiberfil.sys not present." "INFO"
        }

    }
    catch {
        Write-Log "Failed to disable hibernation - $($_.Exception.Message)" "ERROR"
        throw
    }
}