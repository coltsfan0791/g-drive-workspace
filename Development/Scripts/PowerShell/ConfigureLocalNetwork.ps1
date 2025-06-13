function Set-LocalNetworkSettings {
    param (
        [string]$WorkgroupName,
        [string[]]$ComputerNames = @()
    )

    try {
        # Rename computer and add to workgroup if necessary
        if ($env:COMPUTERNAME -ne $env:COMPUTERNAME.ToUpper()) {
            Rename-Computer -NewName $env:COMPUTERNAME.ToUpper() -Force
        }

        if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq $false -and (Get-WmiObject -Class Win32_ComputerSystem).Workgroup -ne $WorkgroupName) {
            Add-Computer -WorkgroupName $WorkgroupName -Force
        }

        # Enable network discovery and file sharing for all profiles
        Get-NetConnectionProfile | ForEach-Object {
            if ($_.NetworkCategory -ne 'Private') {
                Set-NetConnectionProfile -InterfaceAlias $_.InterfaceAlias -NetworkCategory Private
            }
        }
        Enable-NetAdapterBinding -Name "*" -ComponentID ms_server
        Enable-NetAdapterBinding -Name "*" -ComponentID ms_pacer

        Write-Host "Network settings configured successfully."
    } catch {
        Write-Error "Failed to configure network settings: $_"
    }

    # Test network connectivity (optional)
    foreach ($Computer in $ComputerNames) {
        try {
            if (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
                Write-Host "${Computer}: Network connection successful."
            } else {
                Write-Host "${Computer}: Network connection failed."
            }
        } catch {
            Write-Error "Error testing connection to ${Computer}: $_"
        }
    }
}

# Call the function to configure the local computer
Set-LocalNetworkSettings -WorkgroupName "workgroup" -ComputerNames @("Computer1", "Computer2")