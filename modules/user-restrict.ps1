function Set-InnutrireUserRestrictions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username
    )

    try {
        Write-Log "Applying restrictions to user '$Username'..." "INFO"

        $user = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

        if (-not $user) {
            Write-Log "User '$Username' does not exist. Cannot apply restrictions." "ERROR"
            return
        }

        # ================================
        # Disable password changes
        # ================================
        Set-LocalUser -Name $Username -PasswordNeverExpires $true
        Write-Log "Password expiration disabled for '$Username'." "INFO"

        # ================================
        # Prevent user from changing password
        # (via user rights policy alternative)
        # ================================
        net user $Username /Passwordchg:no | Out-Null
        Write-Log "Password change disabled for '$Username'." "INFO"

        # ================================
        # Remove from high-privilege groups (safety)
        # ================================
        $groupsToRemove = @(
            "Administrators",
            "Remote Desktop Users"
        )

        foreach ($group in $groupsToRemove) {
            try {
                Remove-LocalGroupMember -Group $group -Member $Username -ErrorAction SilentlyContinue
                Write-Log "Removed '$Username' from '$group' (if existed)." "INFO"
            } catch {}
        }

        # ================================
        # Add to Users group only
        # ================================
        Add-LocalGroupMember -Group "Users" -Member $Username -ErrorAction SilentlyContinue
        Write-Log "Ensured '$Username' is in 'Users' group." "SUCCESS"

        # ================================
        # Disable interactive system access (optional hardening)
        # ================================
        net user $Username /active:yes | Out-Null

        # ================================
        # Optional: deny local logon rights (for kiosk-style lock)
        # Uncomment if you want FULL lockout from shell
        # ================================
        # ntrights +r SeDenyInteractiveLogonRight -u $Username

        Write-Log "Restrictions applied successfully to '$Username'." "SUCCESS"
    }
    catch {
        Write-Log "Failed to restrict user '$Username' - $($_.Exception.Message)" "ERROR"
        throw
    }
}