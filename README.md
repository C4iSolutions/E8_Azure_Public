# Essential 8 Azure Compliance Implementation

This repository contains comprehensive implementation guides, infrastructure-as-code templates, and automation scripts to help organizations meet the Australian Essential 8 security controls in Azure cloud environments.

## Project Overview

The Essential 8 is a prioritized set of cyber security strategies to mitigate targeted cyber intrusions. This project provides step-by-step implementations for all 8 controls in Microsoft Azure.

## Quick Links

- **[Implementation Roadmap](docs/IMPLEMENTATION_ROADMAP.md)** - Project timeline and dependencies
- **[Compliance Checklist](docs/COMPLIANCE_CHECKLIST.md)** - Track progress across all controls
- **[Architecture Guide](docs/ARCHITECTURE_GUIDE.md)** - Detailed architecture diagrams

## Essential 8 Controls

1. **[Control 1: Application Control](docs/controls/01-application-control.md)** - Whitelisting and AppLocker
2. **[Control 2: Patch Management](docs/controls/02-patch-management.md)** - Azure Update Management
3. **[Control 3: Restricting Admin Privileges](docs/controls/03-admin-privileges.md)** - IAM and PIM
4. **[Control 4: User Application Hardening](docs/controls/04-user-app-hardening.md)** - Browser and Office hardening
5. **[Control 5: Multi-Factor Authentication](docs/controls/05-mfa.md)** - Azure AD Conditional Access
6. **[Control 6: Security Logging & Monitoring](docs/controls/06-logging-monitoring.md)** - Azure Monitor and Sentinel
7. **[Control 7: Regular Backups](docs/controls/07-backups.md)** - Azure Backup configuration
8. **[Control 8: Credential Hygiene](docs/controls/08-credential-hygiene.md)** - Password policies

## Implementation Approaches

### Infrastructure as Code (Terraform)
Located in `terraform/` directory - complete Terraform modules for each control.

### PowerShell Automation
Located in `scripts/powershell/` directory - ready-to-run PowerShell scripts.

### Manual Implementation
Located in `docs/controls/` directory - step-by-step guides for manual configuration.

## Prerequisites

- Azure subscription with appropriate permissions
- Terraform >= 1.0 (for Terraform approach)
- PowerShell 7+ (for PowerShell scripts)
- Azure CLI or Azure PowerShell modules

## Getting Started

1. Clone this repository
2. Review the [Implementation Roadmap](docs/IMPLEMENTATION_ROADMAP.md)
3. Choose your deployment method (Terraform, PowerShell, or Manual)
4. Follow the control-specific documentation
5. Track progress using the [Compliance Checklist](docs/COMPLIANCE_CHECKLIST.md)

## Directory Structure

```
├── docs/
│   ├── IMPLEMENTATION_ROADMAP.md
│   ├── COMPLIANCE_CHECKLIST.md
│   ├── ARCHITECTURE_GUIDE.md
│   └── controls/
│       ├── 01-application-control.md
│       ├── 02-patch-management.md
│       ├── 03-admin-privileges.md
│       ├── 04-user-app-hardening.md
│       ├── 05-mfa.md
│       ├── 06-logging-monitoring.md
│       ├── 07-backups.md
│       └── 08-credential-hygiene.md
├── terraform/
│   ├── modules/
│   ├── environments/
│   └── README.md
├── scripts/
│   ├── powershell/
│   └── README.md
└── README.md
```

## Support

For issues, questions, or contributions, please create an issue in this repository.

## License

[Specify your license here]
