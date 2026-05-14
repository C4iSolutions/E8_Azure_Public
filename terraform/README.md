# Terraform - Essential 8 Controls Implementation

This directory contains Terraform modules for deploying Essential 8 controls in Azure.

## Structure

```
terraform/
├── modules/
│   ├── app-control/              # Control 1: Application Whitelisting
│   ├── patch-management/         # Control 2: Patch Management
│   ├── admin-privileges/         # Control 3: Restricting Admin Privileges
│   ├── app-hardening/            # Control 4: User Application Hardening
│   ├── mfa/                      # Control 5: Multi-Factor Authentication
│   ├── logging-monitoring/       # Control 6: Security Logging & Monitoring
│   ├── backups/                  # Control 7: Regular Backups
│   └── credential-hygiene/       # Control 8: Credential Hygiene
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

## Prerequisites

- Terraform >= 1.0
- Azure CLI authenticated
- Appropriate Azure permissions
- Azure subscription

## Quick Start

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review Changes
```bash
terraform plan -out=tfplan
```

### 3. Apply Configuration
```bash
terraform apply tfplan
```

### 4. Verify Deployment
```bash
terraform output
```

## Module Details

Each module can be deployed independently or as part of the complete deployment.

### Module: app-control
Deploys AppLocker policies and application whitelisting rules.
```hcl
module "app_control" {
  source = "./modules/app-control"
  
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}
```

### Module: patch-management
Configures Azure Update Management for automated patching.
```hcl
module "patch_management" {
  source = "./modules/patch-management"
  
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  automation_account  = azurerm_automation_account.main.id
}
```

### Module: admin-privileges
Enables PIM and configures RBAC for privilege management.
```hcl
module "admin_privileges" {
  source = "./modules/admin-privileges"
  
  environment = var.environment
  tenant_id   = data.azurerm_client_config.current.tenant_id
}
```

### Module: app-hardening
Deploys Attack Surface Reduction rules and security baselines.
```hcl
module "app_hardening" {
  source = "./modules/app-hardening"
  
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
}
```

### Module: mfa
Enables MFA and Conditional Access policies.
```hcl
module "mfa" {
  source = "./modules/mfa"
  
  environment       = var.environment
  tenant_id         = data.azurerm_client_config.current.tenant_id
  azure_ad_group_id = azurerm_ad_group.all_users.id
}
```

### Module: logging-monitoring
Sets up Azure Monitor, Log Analytics, and Azure Sentinel.
```hcl
module "logging_monitoring" {
  source = "./modules/logging-monitoring"
  
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}
```

### Module: backups
Configures Azure Backup and Recovery Services Vault.
```hcl
module "backups" {
  source = "./modules/backups"
  
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  retention_days      = 90
}
```

### Module: credential-hygiene
Configures Azure AD password policies and blocks legacy authentication.
```hcl
module "credential_hygiene" {
  source = "./modules/credential-hygiene"
  
  environment = var.environment
  tenant_id   = data.azurerm_client_config.current.tenant_id
}
```

## Deployment Strategies

### Option 1: Full Deployment
Deploy all controls at once:
```bash
terraform apply
```

### Option 2: Phased Deployment
Deploy controls in phases (create separate .tfvars for each phase):
```bash
# Phase 1: MFA + Credentials
terraform apply -var-file="phase1.tfvars"

# Phase 2: Endpoints
terraform apply -var-file="phase2.tfvars"

# Phase 3: Monitoring + Backup
terraform apply -var-file="phase3.tfvars"
```

### Option 3: Module-Specific Deployment
Deploy individual modules:
```bash
terraform apply -target=module.mfa
terraform apply -target=module.admin_privileges
```

## Variables

### Environment
```hcl
variable "environment" {
  type    = string
  default = "production"
  # Options: dev, staging, production
}
```

### Location
```hcl
variable "location" {
  type    = string
  default = "australiaeast"
  # Use location close to your organization
}
```

### Resource Naming
```hcl
variable "resource_prefix" {
  type    = string
  default = "e8"
  # Customize for your organization
}
```

## Outputs

Terraform outputs key resource IDs for integration with other tools:

```bash
terraform output
```

Example outputs:
- `log_analytics_workspace_id`
- `automation_account_id`
- `recovery_vault_id`
- `key_vault_id`

## State Management

### Remote State (Recommended)
Store state in Azure Storage:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

### Local State (Development Only)
```bash
terraform init  # Creates local .tfstate file
```

## Monitoring & Troubleshooting

### Check Deployment Status
```bash
terraform show
```

### Review Logs
```bash
terraform apply -var-file="prod.tfvars" -var="debug=true"
```

### Common Issues

#### Issue: Authentication Failed
```bash
az login
az account set --subscription <subscription-id>
```

#### Issue: Insufficient Permissions
Ensure user has "Owner" or "Contributor" role on subscription.

#### Issue: Resource Already Exists
Check if resource exists in Azure portal and import if needed:
```bash
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/...
```

## Best Practices

1. **Use Remote State:** Store state in Azure Storage Accounts
2. **Version Control:** Commit .tf files to Git (not .tfstate)
3. **Code Review:** Use Terraform Cloud or GitOps for approvals
4. **Testing:** Run `terraform plan` before `apply`
5. **Tagging:** Implement consistent resource tagging
6. **Documentation:** Update comments for custom configurations
7. **Backup:** Export state files regularly
8. **Rotation:** Rotate Azure credentials regularly

## Security Considerations

- Store sensitive variables in Azure Key Vault
- Use managed identities for Azure authentication
- Enable audit logging for all Terraform operations
- Implement RBAC for Terraform state access
- Use Terraform remote state with encryption
- Rotate service principal credentials annually

## Maintenance

### Regular Tasks
- [ ] Review Terraform versions monthly
- [ ] Update module versions quarterly
- [ ] Test disaster recovery annually
- [ ] Audit resource changes monthly

### Update Terraform Version
```bash
terraform version                    # Check current version
terraform init -upgrade              # Update to latest version
terraform plan                       # Review changes
terraform apply                      # Apply updates
```

## Support & Documentation

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/glossary)
- [Azure Terraform Modules](https://registry.terraform.io/namespaces/Azure)

## Contributing

To contribute improvements:
1. Create a feature branch
2. Test changes thoroughly
3. Submit pull request with documentation
4. Await review and approval

## License

[Specify your license]

---

**Last Updated:** 2026-05-14  
**Terraform Version:** >= 1.0  
**Azure Provider Version:** >= 3.0
