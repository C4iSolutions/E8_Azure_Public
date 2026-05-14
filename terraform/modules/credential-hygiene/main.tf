# Control 8: Credential Hygiene
# Configures Azure AD password policies and blocks legacy authentication

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.30"
    }
  }
}

resource "azuread_password_policy" "main" {
  # Password Policy Configuration per DISP standards
  min_password_length = 14
  require_uppercase   = true
  require_lowercase   = true
  require_numbers     = true
  require_symbols     = true
  
  # Do not require expiration (Microsoft best practice)
  password_never_expires = true
  
  # Password history - cannot reuse last 24 passwords
  password_history_count = 24
  
  # Account lockout settings
  lockout_threshold     = 10  # Lock after 10 failed attempts
  lockout_duration      = 10  # 10 minutes
  lockout_reset_period  = 1   # Reset counter after 1 minute
}

# Block legacy authentication (Basic Auth)
resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "Block Legacy Authentication"
  state        = "enabled"
  
  conditions {
    client_app_types = ["exchangeActiveSync", "other"]
    
    applications {
      included_applications = ["all"]
    }
    
    users {
      included_users = ["all"]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}

# Conditional Access: Require Modern Authentication
resource "azuread_conditional_access_policy" "require_modern_auth" {
  display_name = "Require Modern Authentication"
  state        = "enabled"
  
  conditions {
    client_app_types = ["exchangeActiveSync", "mobileAppsAndDesktopClients"]
    
    applications {
      included_applications = ["Office365"]
    }
    
    users {
      included_users = ["all"]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["require_compliant_device"]
  }
}

# Enable leaked credential detection
resource "azuread_security_defaults_policy" "main" {
  display_name              = "Security Defaults"
  is_enabled               = true
  require_mfa_for_admins   = true
}

output "password_policy_id" {
  value       = azuread_password_policy.main.id
  description = "Password policy ID"
}

output "block_legacy_auth_policy_id" {
  value       = azuread_conditional_access_policy.block_legacy_auth.id
  description = "Legacy auth blocking policy ID"
}