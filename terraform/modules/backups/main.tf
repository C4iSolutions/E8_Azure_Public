# Control 7: Regular Backups
# Configures Azure Backup and Recovery Services Vault

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 90
}

# Create Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                        = "vault-e8-${var.environment}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku                         = "Standard"
  immutable_vaults_enabled    = true
  soft_delete_enabled         = true
  cross_region_restore_enabled = true
  
  tags = {
    environment = var.environment
    control     = "7-backups"
  }
}

# Configure backup policy for VMs
resource "azurerm_backup_policy_vm" "daily" {
  name                = "policy-vm-daily"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  
  backup {
    frequency = "Daily"
    time      = "04:00"
  }
  
  retention_daily {
    count = 7  # Keep 7 days of daily backups
  }
  
  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }
  
  retention_monthly {
    count    = 12
    monthdays = [1]
  }
  
  retention_yearly {
    count    = 5
    monthdays = [1]
    months   = ["January"]
  }
}

# Configure backup policy for SQL
resource "azurerm_backup_policy_sql_database" "daily" {
  name                = "policy-sql-daily"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  
  backup {
    frequency       = "Daily"
    time            = "04:00"
    retention_days  = var.retention_days
  }
  
  retention_daily {
    count = 7
  }
  
  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }
  
  retention_monthly {
    count    = 12
    monthdays = [1]
  }
}

# Enable soft delete for backups
resource "azurerm_recovery_services_vault_resource_group_mapping" "main" {
  recovery_vault_name       = azurerm_recovery_services_vault.main.name
  resource_group_name       = var.resource_group_name
  backup_policy_type        = "AzureIaaSVM"
  soft_delete_enabled       = true
  cross_region_restore_enabled = true
}

output "recovery_vault_id" {
  value       = azurerm_recovery_services_vault.main.id
  description = "Recovery Services Vault ID"
}

output "backup_policy_vm_id" {
  value       = azurerm_backup_policy_vm.daily.id
  description = "VM backup policy ID"
}

output "backup_policy_sql_id" {
  value       = azurerm_backup_policy_sql_database.daily.id
  description = "SQL backup policy ID"
}