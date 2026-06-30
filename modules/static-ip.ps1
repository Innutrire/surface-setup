function Set-StaticIP {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InterfaceAlias,

        [Parameter(Mandatory=$true)]
        [string]$IPAddress,

        [Parameter(Mandatory=$true)]
        [string]$PrefixLength,

        [Parameter(Mandatory=$true)]
        [string]$DefaultGateway,

        [string[]]$DnsServers = @("8.8.8.8", "1.1.1.1")
    )

    try {
        Write-Log "Configuring static IP for interface '$InterfaceAlias'..." "INFO"

        # ================================
        # Remove existing IP configuration
        # ================================
        Write-Log "Clearing existing IP configuration..." "INFO"

        Get-NetIPAddress -InterfaceAlias $InterfaceAlias -ErrorAction SilentlyContinue |
            Where-Object { $_.AddressFamily -eq "IPv4" } |
            Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

        Get-NetRoute -InterfaceAlias $InterfaceAlias -ErrorAction SilentlyContinue |
            Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

        # ================================
        # Set new static IP
        # ================================
        Write-Log "Setting IP: $IPAddress / $PrefixLength" "INFO"

        New-NetIPAddress `
            -InterfaceAlias $InterfaceAlias `
            -IPAddress $IPAddress `
            -PrefixLength $PrefixLength `
            -DefaultGateway $DefaultGateway

        Write-Log "Static IP configured successfully." "SUCCESS"

        # ================================
        # Configure DNS
        # ================================
        Write-Log "Setting DNS servers..." "INFO"

        Set-DnsClientServerAddress `
            -InterfaceAlias $InterfaceAlias `
            -ServerAddresses $DnsServers

        Write-Log "DNS configured: $($DnsServers -join ', ')" "SUCCESS"

    }
    catch {
        Write-Log "Failed to configure static IP - $($_.Exception.Message)" "ERROR"
        throw
    }
}