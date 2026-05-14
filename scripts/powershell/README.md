# PowerShell Scripts - Essential 8 Implementation

This directory contains PowerShell scripts for deploying Essential 8 controls in Azure.

## Prerequisites

- PowerShell 7.0 or later
- Azure PowerShell module: `Install-Module -Name Az -Force`
- Azure AD module: `Install-Module -Name AzureAD -Force`
- Appropriate Azure permissions (Owner or Contributor)

## Quick Start

### 1. Connect to Azure
```powershell
Connect-AzAccount
Select-AzSubscription -SubscriptionId "<subscription-id>"
```

### 2. Run Script
```powershell
.\Control-1-AppControl.ps1
```

## Scripts Available

### Control 1: Application Control
**File:** `Control-1-AppControl.ps1`

Deploys AppLocker policies and application whitelisting.

```powershell
.\Control-1-AppControl.ps1 -ResourceGroupName "rg-e8" -Environment "production"
```

### Control 2: Patch Management
**File:** `Control-2-PatchManagement.ps1`

Configures Azure Update Management for automated patching.

```powershell
.\Control-2-PatchManagement.ps1 -AutomationAccountName "aa-e8" -ResourceGroupName "rg-e8"
```

### Control 3: Admin Privileges
**File:** `Control-3-AdminPrivileges.ps1`

Enables PIM and configures RBAC for privilege management.

```powershell
.\Control-3-AdminPrivileges.ps1 -TenantId "<tenant-id>"
```

### Control 4: User App Hardening
**File:** `Control-4-UserAppHardening.ps1`

Deploys Attack Surface Reduction rules and security baselines.

```powershell
.\Control-4-UserAppHardening.ps1 -ResourceGroupName "rg-e8"
```

### Control 5: Multi-Factor Authentication
**File:** `Control-5-MFA.ps1`

Enables MFA and Conditional Access policies.

```powershell
.\Control-5-MFA.ps1 -TenantId "<tenant-id>"
```

### Control 6: Logging & Monitoring
**File:** `Control-6-LoggingMonitoring.ps1`

Sets up Azure Monitor, Log Analytics, and Azure Sentinel.

```powershell
.\Control-6-LoggingMonitoring.ps1 -ResourceGroupName "rg-e8" -Location "australiaeast"
```

### Control 7: Regular Backups
**File:** `Control-7-Backups.ps1`

Configures Azure Backup and Recovery Services Vault.

```powershell
.\Control-7-Backups.ps1 -ResourceGroupName "rg-e8" -Location "australiaeast"
```

### Control 8: Credential Hygiene
**File:** `Control-8-CredentialHygiene.ps1`

Configures Azure AD password policies and blocks legacy authentication.

```powershell
.\Control-8-CredentialHygiene.ps1 -TenantId "<tenant-id>"
```

## Script Structure

Each script includes:

```powershell
# Parameters
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$Environment = "production"
)

# Logging
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message" | Tee-Object -FilePath "./deployment.log" -Append
}

# Error handling
try {
    # Configuration and deployment
} catch {
    Write-Log "Error: $_" "ERROR"
    exit 1
}

Write-Log "Deployment completed successfully" "INFO"
```

## Deployment Strategies

### Option 1: Full Deployment
Run all scripts in sequence:
```powershell
.\Control-1-AppControl.ps1
.\Control-2-PatchManagement.ps1
.\Control-3-AdminPrivileges.ps1
.\Control-4-UserAppHardening.ps1
.\Control-5-MFA.ps1
.\Control-6-LoggingMonitoring.ps1
.\Control-7-Backups.ps1
.\Control-8-CredentialHygiene.ps1
```

### Option 2: Phased Deployment
```powershell
# Phase 1: Quick wins
.\Control-5-MFA.ps1
.\Control-8-CredentialHygiene.ps1

# Phase 2: Endpoints
.\Control-1-AppControl.ps1
.\Control-4-UserAppHardening.ps1

# Phase 3: Operations
.\Control-2-PatchManagement.ps1
.\Control-6-LoggingMonitoring.ps1
.\Control-7-Backups.ps1

# Phase 4: Privileges
.\Control-3-AdminPrivileges.ps1
```

## Configuration

Edit variables at the top of each script:

```powershell
$Config = @{
    ResourceGroupName     = "rg-e8-prod"
    Environment          = "production"
    Location            = "australiaeast"
    SubscriptionId      = "<subscription-id>"
    TenantId            = "<tenant-id>"
    RetentionDays       = 90
}
```

## Error Handling

Scripts include comprehensive error handling:

```powershell
# Check prerequisites
if (-not (Get-Module Az -ListAvailable)) {
    Write-Log "Azure PowerShell module not found. Installing..." "WARN"
    Install-Module -Name Az -Force
}

# Validate Azure connection
if (-not (Get-AzContext)) {
    Write-Log "Not connected to Azure. Connecting..." "WARN"
    Connect-AzAccount
}
```

## Logging & Auditing

All scripts generate detailed logs:

```
Logs are saved to: ./deployment.log

Example:
[2026-05-14 10:30:45] [INFO] Starting Control 5 - MFA deployment
[2026-05-14 10:30:46] [INFO] Checking prerequisites...
[2026-05-14 10:30:47] [INFO] Creating Conditional Access policy...
[2026-05-14 10:30:52] [INFO] Policy created successfully: policy-mfa-all-users
[2026-05-14 10:30:53] [INFO] Deployment completed successfully
```

## Common Issues

### Issue: Module Not Found
```powershell
Install-Module -Name Az -Force
Install-Module -Name AzureAD -Force
```

### Issue: Permission Denied
Ensure your Azure account has "Owner" or "Contributor" role on the subscription.

### Issue: Tenant ID Not Found
```powershell
(Get-AzTenant).Id
```

## Best Practices

1. **Test First:** Run scripts in non-production environment first
2. **Review Changes:** Examine what each script will create/modify
3. **Backup State:** Export Azure configuration before running
4. **Monitor Logs:** Check deployment.log for errors
5. **Document Changes:** Record all modifications
6. **Verify Deployment:** Confirm all changes in Azure Portal

## Support & Documentation

- [Azure PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/azure/)
- [Azure AD PowerShell](https://docs.microsoft.com/en-us/powershell/azure/active-directory/overview)
- [Intune PowerShell](https://docs.microsoft.com/en-us/powershell/intune/)

## Contributing

To contribute improvements:
1. Test changes thoroughly
2. Add comprehensive comments
3. Update documentation
4. Submit pull request

---

**Last Updated:** 2026-05-14  
**PowerShell Version:** 7.0+  
**Azure Module Version:** 9.0+
