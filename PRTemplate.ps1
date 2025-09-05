# ===============================
# Post-Recovery Script Template
# ===============================

# Log start
$logPath = "C:\RecoveryLogs\PostRecovery_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logPath

Write-Host "Starting post-recovery tasks..."

# 1. Reconfigure DNS
Write-Host "Updating DNS settings..."
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8", "8.8.4.4")

# 2. Restart critical services
$services = @("wuauserv", "BITS", "WinDefend", "Dnscache")
foreach ($svc in $services) {
    Write-Host "Restarting service: $svc"
    Restart-Service -Name $svc -Force
}

# 3. Rejoin domain (if needed)
$domain = "corp.example.com"
$ouPath = "OU=Workstations,DC=corp,DC=example,DC=com"
$domainCred = Get-Credential -Message "Enter domain join credentials"
Add-Computer -DomainName $domain -OUPath $ouPath -Credential $domainCred -Restart

# 4. Reapply baseline GPOs
Write-Host "Forcing Group Policy update..."
gpupdate /force

# 5. Run malware scan (Defender)
Write-Host "Running quick malware scan..."
Start-MpScan -ScanType QuickScan

# 6. Validate firewall rules
Write-Host "Checking firewall status..."
Get-NetFirewallProfile | Format-Table Name, Enabled

# 7. Re-register system in monitoring tools (placeholder)
Write-Host "Re-registering system in monitoring tools..."
# Example: Invoke-RestMethod to monitoring API or run agent installer

# 8. Cleanup temp files
Write-Host "Cleaning up temp files..."
Get-ChildItem -Path "C:\Windows\Temp" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue

# Log end
Write-Host "Post-recovery tasks completed."
Stop-Transcript
