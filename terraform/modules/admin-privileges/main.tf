# Control 3: Restricting Admin Privileges
# Enables PIM and configures RBAC

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.30"
    }
  }
}

variable "environment" {
  type = string
}

# Create custom role with least privilege
resource "azurerm_role_definition" "least_privilege_admin" {
  name  = "${var.environment}-Least-Privilege-Admin"
  scope = data.azurerm_subscription.current.id
  
  permissions {
    actions = [
      "*/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete"
    ]
    not_actions = [
      "Microsoft.Authorization/classicAdministrators/write",
      "Microsoft.Authorization/classicAdministrators/delete"
    ]
  }
  
  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

# Enable PIM for Azure AD roles
resource "azurerm_pim_active_role_assignment" "admin" {
  scope              = "${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization"
  role_definition_id = "9b895d92-2cd3-44c7-9bc9-2e823930ff56"  # Global Administrator
  principal_id       = data.azurerm_client_config.current.object_id
  
  schedule {
    start_date_time = "2026-05-14T00:00:00Z"
    # Expires after 4 hours (per DISP requirements)
    expiration {
      duration_hours = 4
    }
  }
  
  ticket {
    number = "INCIDENT-001"
    system = "ServiceNow"
  }
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

output "custom_role_id" {
  value       = azurerm_role_definition.least_privilege_admin.id
  description = "Custom least privilege role ID"
}

output "pim_role_assignment_id" {
  value       = azurerm_pim_active_role_assignment.admin.id
  description = "PIM role assignment ID"
}