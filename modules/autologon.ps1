function Set-AutoLogon {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username,

        [Parameter(Mandatory=$true)]
        [string]$Password,

        [string]$Domain = $env:COMPUTERNAME
    )

    try {
        Write-Log "Configuring Auto Logon for user '$Username'..." "INFO"

        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

        # Enable AutoLogon
        Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"
        Write-Log "AutoAdminLogon enabled." "INFO"

        # Set username
        Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value $Username

        # Set domain / machine name
        Set-ItemProperty -Path $regPath -Name "DefaultDomainName" -Value $Domain

        # Set password (stored in registry - insecure but required for auto logon)
        Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $Password

        Write-Log "Auto Logon configured for '$Username' on domain '$Domain'." "SUCCESS"

        # Optional safety note
        Write-Log "WARNING: Password is stored in registry in plain text." "WARN"
    }
    catch {
        Write-Log "Failed to configure Auto Logon - $($_.Exception.Message)" "ERROR"
        throw
    }
}