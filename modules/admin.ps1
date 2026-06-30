function New-LocalAdminAccount {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username,

        [Parameter(Mandatory=$true)]
        [string]$PasswordPlain
    )

    try {
        Write-Log "Checking if user '$Username' exists..." "INFO"

        $user = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

        if ($user) {
            Write-Log "User '$Username' already exists. Skipping creation." "WARN"
        }
        else {
            Write-Log "Creating local user '$Username'..." "INFO"

            $securePassword = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force

            New-LocalUser `
                -Name $Username `
                -Password $securePassword `
                -FullName "INNUTRIRE Administrator" `
                -Description "Auto-created admin account for INNUTRIRE deployment" `
                -PasswordNeverExpires $true `
                -AccountNeverExpires $true

            Write-Log "User '$Username' created successfully." "SUCCESS"
        }

        Write-Log "Ensuring '$Username' is in Administrators group..." "INFO"

        # Add to Administrators group (idempotent-safe)
        Add-LocalGroupMember `
            -Group "Administrators" `
            -Member $Username `
            -ErrorAction SilentlyContinue

        Write-Log "User '$Username' is now in Administrators group." "SUCCESS"
    }
    catch {
        Write-Log "Failed to create admin account '$Username' - $($_.Exception.Message)" "ERROR"
        throw
    }
}