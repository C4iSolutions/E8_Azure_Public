# Control 5: Multi-Factor Authentication
# Enables MFA and Conditional Access policies

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.30"
    }
  }
}

# Conditional Access: Require MFA for All Users
resource "azuread_conditional_access_policy" "require_mfa_all_users" {
  display_name = "Require MFA for All Users"
  state        = "enabled"
  
  conditions {
    sign_in_risk_levels = ["high", "medium"]
    
    applications {
      included_applications = ["all"]
    }
    
    users {
      included_users = ["all"]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["require_multifactor_authentication"]
  }
}

# Conditional Access: Require MFA for Admin Roles
resource "azuread_conditional_access_policy" "require_mfa_admins" {
  display_name = "Require MFA for Admin Roles"
  state        = "enabled"
  
  conditions {
    applications {
      included_applications = ["all"]
    }
    
    users {
      included_roles = [
        "9b895d92-2cd3-44c7-9bc9-2e823930ff56",  # Global Administrator
        "29232cdf-9323-42fd-ade2-1d097af620db",  # Security Administrator
        "194ae4cb-b126-40b2-bd5b-6091b380977d"   # Conditional Access Administrator
      ]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["require_multifactor_authentication"]
  }
}

# Conditional Access: Require MFA for External Users
resource "azuread_conditional_access_policy" "require_mfa_external" {
  display_name = "Require MFA for External Users"
  state        = "enabled"
  
  conditions {
    applications {
      included_applications = ["all"]
    }
    
    users {
      included_users = ["GuestsOrExternalUsers"]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["require_multifactor_authentication"]
  }
}

output "mfa_admin_policy_id" {
  value       = azuread_conditional_access_policy.require_mfa_admins.id
  description = "MFA for admins policy ID"
}

output "mfa_all_users_policy_id" {
  value       = azuread_conditional_access_policy.require_mfa_all_users.id
  description = "MFA for all users policy ID"
}