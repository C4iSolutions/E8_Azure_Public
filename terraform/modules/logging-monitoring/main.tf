# Control 6: Security Logging & Monitoring
# Sets up Azure Monitor, Log Analytics, and Azure Sentinel

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

# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-e8-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  daily_quota_gb      = 10
  
  tags = {
    environment = var.environment
    control     = "6-logging-monitoring"
  }
}

# Enable Azure Sentinel on Log Analytics Workspace
resource "azurerm_sentinel_alert_rule" "failed_signin" {
  name                       = "FailedSignInAlerts"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  alert_rule_template_guid   = "7cb0915f-2ad5-4d71-a1d8-5014d119b192"
  enabled                    = true
}

# Create Azure Monitor Alert for Multiple Failed Sign-Ins
resource "azurerm_monitor_metric_alert" "failed_logins" {
  name                = "alert-failed-logins"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Alert when multiple failed sign-in attempts detected"
  enabled             = true
  
  criteria {
    metric_name      = "SignInFailureCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 5
    metric_namespace = "Microsoft.Insights/virtualMachines"
  }
  
  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Create Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-e8-security"
  resource_group_name = var.resource_group_name
  short_name          = "e8sec"
  
  email_receiver {
    name          = "Security Team"
    email_address = "security@example.com"
  }
}

# Configure Azure AD Audit Logs
resource "azurerm_monitor_diagnostic_setting" "aad_audit" {
  name                       = "diag-aad-audit"
  target_resource_id         = azurerm_log_analytics_workspace.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  log {
    category = "AuditLogs"
    enabled  = true
    
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
  
  log {
    category = "SignInLogs"
    enabled  = true
    
    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "Log Analytics Workspace ID"
}

output "action_group_id" {
  value       = azurerm_monitor_action_group.main.id
  description = "Monitor Action Group ID for alerts"
}