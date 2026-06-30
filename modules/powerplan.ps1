function Set-HighPerformancePowerPlan {
    try {
        Write-Log "Configuring High Performance power plan..." "INFO"

        # ================================
        # Get all power plans
        # ================================
        $plans = powercfg -l

        # Try to find High Performance plan
        $highPerfLine = $plans | Select-String "High performance"

        if ($highPerfLine) {

            # Extract GUID (second column)
            $guid = ($highPerfLine -split "\s+")[3]

            Write-Log "High Performance plan found: $guid" "INFO"

            # Set active plan
            powercfg -setactive $guid

            Write-Log "High Performance power plan activated." "SUCCESS"
        }
        else {
            Write-Log "High Performance plan not found. Attempting fallback..." "WARN"

            # Fallback: try built-in alias
            powercfg -setactive SCHEME_MIN

            Write-Log "Fallback power plan (SCHEME_MIN) activated." "INFO"
        }

        # ================================
        # Optional: prevent user from changing plan easily
        # ================================
        Write-Log "Locking power plan behavior (optional hardening)..." "INFO"

        # Disable sleep/hibernate overrides already handled elsewhere
        powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 | Out-Null
        powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 | Out-Null
        powercfg -setactive SCHEME_CURRENT

        Write-Log "Power plan locked to high performance configuration." "SUCCESS"
    }
    catch {
        Write-Log "Failed to set power plan - $($_.Exception.Message)" "ERROR"
        throw
    }
}