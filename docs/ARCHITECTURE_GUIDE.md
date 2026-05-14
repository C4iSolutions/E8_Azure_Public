# Essential 8 Azure Architecture Guide

## Overview

This guide describes the recommended architecture for implementing all 8 Essential 8 controls in Microsoft Azure.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Azure Environment                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │             Azure Active Directory (AAD)                     │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │   │
│  │  │  Users       │  │  Groups      │  │  Roles & PIM     │  │   │
│  │  │  (Control 8) │  │  (Control 3) │  │  (Control 3,5)   │  │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘  │   │
│  │  ┌─────────────────────────────────────────────────────┐    │   │
│  │  │  Conditional Access & MFA (Control 5)              │    │   │
│  │  │  - Device compliance                               │    │   │
│  │  │  - Sign-in risk policies                           │    │   │
│  │  │  - Require MFA for all users                       │    │   │
│  │  └─────────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                               │                                     │
│          ┌────────────────────┼────────────────────┐               │
│          ▼                    ▼                    ▼               │
│  ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐  │
│  │ ENDPOINT MGMT    │ │ SECURITY CENTER  │ │ MONITOR & SENTINEL│  │
│  │                  │ │                  │ │ (Control 6)       │  │
│  │ - AppLocker      │ │ - Vulnerabilities│ │ - Log Analytics   │  │
│  │   (Control 1)    │ │ - Recommendations│ │ - Alert Rules     │  │
│  │ - Patch Mgmt     │ │ - Compliance     │ │ - Playbooks       │  │
│  │   (Control 2)    │ │   (Controls 1-8) │ │ - Dashboards      │  │
│  │ - ASR Rules      │ │                  │ │                   │  │
│  │   (Control 4)    │ │                  │ │                   │  │
│  └──────────────────┘ └──────────────────┘ └──────────────────┘  │
│          │                    │                    │               │
│          └────────────────────┼────────────────────┘               │
│                               ▼                                    │
│                  ┌───────────────────────────┐                    │
│                  │  COMPUTE & DATA SERVICES   │                    │
│                  │  ┌─────────────────────┐  │                    │
│                  │  │ Virtual Machines    │  │                    │
│                  │  │ - Updates (Control 2)   │                    │
│                  │  │ - Hardening (Control 4) │                    │
│                  │  │ - Backup (Control 7)    │                    │
│                  │  └─────────────────────┘  │                    │
│                  │  ┌─────────────────────┐  │                    │
│                  │  │ Databases           │  │                    │
│                  │  │ - Backup (Control 7)    │                    │
│                  │  │ - Monitoring (Control 6)│                    │
│                  │  └─────────────────────┘  │                    │
│                  │  ┌─────────────────────┐  │                    │
│                  │  │ Storage             │  │                    │
│                  │  │ - Backup (Control 7)    │                    │
│                  │  │ - Encryption        │  │                    │
│                  │  └─────────────────────┘  │                    │
│                  └───────────────────────────┘                    │
│                               │                                    │
│                               ▼                                    │
│                  ┌───────────────────────────┐                    │
│                  │    BACKUP & RECOVERY      │                    │
│                  │ (Control 7)               │                    │
│                  │ - Recovery Services Vault │                    │
│                  │ - Daily backups           │                    │
│                  │ - GRS replication         │                    │
│                  └───────────────────────────┘                    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Control Implementation Architecture

### Control 1: Application Control (AppLocker)

**Location:** Endpoint Management / Intune

```
┌─────────────────────────────────────┐
│     Application Control             │
├─────────────────────────────────────┤
│                                     │
│  Intune Configuration:              │
│  ├─ Device Compliance Policies      │
│  ├─ Endpoint Protection Policies    │
│  ├─ App Protection Policies         │
│  └─ Deployment Profiles             │
│                                     │
│  Deployed to:                       │
│  ├─ Windows 10/11 Endpoints         │
│  └─ Hybrid Azure AD Joined Devices  │
│                                     │
│  Monitoring:                        │
│  ├─ Event Viewer (AppLocker logs)   │
│  ├─ Log Analytics Workspace         │
│  └─ Azure Monitor                   │
│                                     │
└─────────────────────────────────────┘
```

### Control 2: Patch Management

**Location:** Azure Update Management / Intune

```
┌──────────────────────────────────────┐
│     Patch Management                 │
├──────────────────────────────────────┤
│                                      │
│  Update Management Service:          │
│  ├─ Scan for updates                 │
│  ├─ Download updates                 │
│  ├─ Test deployment (non-prod)       │
│  └─ Staged production rollout        │
│                                      │
│  Update Schedules:                   │
│  ├─ Critical: Deployed within 7 days │
│  ├─ Important: Deployed within 30d   │
│  └─ Other: Quarterly reviews         │
│                                      │
│  Monitoring:                         │
│  ├─ Update Compliance Dashboard      │
│  ├─ Failed Update Reports            │
│  └─ Compliance Metrics               │
│                                      │
└──────────────────────────────────────┘
```

### Control 3: Restricting Admin Privileges

**Location:** Azure AD / IAM

```
┌──────────────────────────────────────────┐
│    Restricting Admin Privileges          │
├──────────────────────────────────────────┤
│                                          │
│  Role-Based Access Control (RBAC):      │
│  ├─ Custom roles with least privilege   │
│  ├─ Service principals for automation   │
│  └─ Managed identities for applications │
│                                          │
│  Privileged Identity Management (PIM):  │
│  ├─ Just-in-time (JIT) access          │
│  ├─ Multi-stage approval workflows      │
│  ├─ Time-limited role assignments       │
│  └─ Audit logging                       │
│                                          │
│  Access Reviews:                        │
│  ├─ Quarterly reviews of assignments    │
│  ├─ Automatic removal of unused access  │
│  └─ Compliance reporting                │
│                                          │
└──────────────────────────────────────────┘
```

### Control 4: User Application Hardening

**Location:** Endpoint Management / Group Policy

```
┌────────────────────────────────────────┐
│   User Application Hardening           │
├────────────────────────────────────────┤
│                                        │
│  Browser Hardening:                   │
│  ├─ Disable plugins                   │
│  ├─ Enforce HTTPS                     │
│  └─ Block pop-ups and auto-downloads  │
│                                        │
│  Office Hardening:                    │
│  ├─ Disable macros (except trusted)   │
│  ├─ Block external scripts            │
│  └─ Enable protected view             │
│                                        │
│  Attack Surface Reduction (ASR):      │
│  ├─ Block Office from creating        │
│  │  child processes                   │
│  ├─ Block execution of code from      │
│  │  email clients                     │
│  └─ Additional threat-specific rules  │
│                                        │
│  Monitoring:                          │
│  ├─ ASR rule violations logged        │
│  └─ Azure Monitor dashboards          │
│                                        │
└────────────────────────────────────────┘
```

### Control 5: Multi-Factor Authentication

**Location:** Azure AD / Conditional Access

```
┌──────────────────────────────────────────┐
│     Multi-Factor Authentication          │
├──────────────────────────────────────────┤
│                                          │
│  Conditional Access Policies:           │
│  ├─ Require MFA for all users           │
│  ├─ Require MFA for admin roles         │
│  ├─ Require MFA for risky sign-ins      │
│  └─ Device compliance requirements      │
│                                          │
│  MFA Methods Supported:                │
│  ├─ Microsoft Authenticator app         │
│  ├─ Phone call                          │
│  ├─ SMS text message                    │
│  ├─ FIDO2 security keys                 │
│  └─ Password + second factor            │
│                                          │
│  Grace Periods (if needed):             │
│  ├─ Limited time for users to register  │
│  └─ Monitored exceptions                │
│                                          │
│  Monitoring:                            │
│  ├─ MFA registration status             │
│  ├─ Sign-in success/failure rates       │
│  └─ Suspicious activity alerts          │
│                                          │
└──────────────────────────────────────────┘
```

### Control 6: Security Logging & Monitoring

**Location:** Azure Monitor / Sentinel

```
┌─────────────────────────────────────────────┐
│   Security Logging & Monitoring             │
├─────────────────────────────────────────────┤
│                                             │
│  Data Sources:                              │
│  ├─ Azure AD sign-in logs                   │
│  ├─ Azure AD audit logs                     │
│  ├─ Azure Activity logs                     │
│  ├─ Resource diagnostic settings            │
│  ├─ Network flow logs                       │
│  └─ Security Center recommendations         │
│                                             │
│  Log Collection:                            │
│  ├─ Log Analytics Workspace                 │
│  │  └─ KQL queries for analysis             │
│  └─ Azure Sentinel (SIEM/SOAR)              │
│     ├─ Detection rules                      │
│     ├─ Automated responses/playbooks        │
│     └─ Incident management                  │
│                                             │
│  Key Alerts:                                │
│  ├─ Multiple failed sign-in attempts        │
│  ├─ Risky sign-ins detected                 │
│  ├─ Privileged role assignments             │
│  ├─ Policy changes                          │
│  └─ Security alerts from services           │
│                                             │
│  Retention:                                 │
│  ├─ 90 days default                         │
│  ├─ Up to 2 years for compliance            │
│  └─ Long-term archive if needed             │
│                                             │
└─────────────────────────────────────────────┘
```

### Control 7: Regular Backups

**Location:** Azure Backup Service

```
┌──────────────────────────────────────────┐
│        Regular Backups                    │
├──────────────────────────────────────────┤
│                                          │
│  Backup Coverage:                        │
│  ├─ Azure VMs (full backups)             │
│  ├─ SQL Databases                        │
│  ├─ File Shares                          │
│  ├─ On-premises servers (MARS agent)     │
│  └─ SAP HANA databases                   │
│                                          │
│  Backup Schedules:                       │
│  ├─ Daily incremental backups            │
│  ├─ Weekly full backups                  │
│  ├─ Monthly retention                    │
│  └─ Annual retention for compliance      │
│                                          │
│  Recovery Strategy:                      │
│  ├─ Recovery Services Vault (GRS)        │
│  ├─ Geo-redundant storage                │
│  ├─ Recovery Site (optional DR)          │
│  └─ Regular recovery testing (quarterly) │
│                                          │
│  Monitoring:                             │
│  ├─ Daily backup job status              │
│  ├─ Failed backup alerts                 │
│  ├─ Backup data integrity checks         │
│  └─ Recovery capability testing          │
│                                          │
└──────────────────────────────────────────┘
```

### Control 8: Credential Hygiene

**Location:** Azure AD / Password Policy

```
┌────────────────────────────────────────────┐
│       Credential Hygiene                   │
├────────────────────────────────────────────┤
│                                            │
│  Password Policies:                        │
│  ├─ Minimum length: 14 characters          │
│  ├─ Complexity: Upper, lower, digits, char│
│  ├─ Expiration: No fixed expiration*       │
│  ├─ History: Cannot reuse last 24 password│
│  └─ Lockout: 10 attempts, 10 min lockout  │
│                                            │
│  Password Monitoring:                      │
│  ├─ Banned password list (common/breached)│
│  ├─ Custom password ban lists (org-specific)
│  ├─ Leaked credential detection           │
│  └─ High-risk password changes            │
│                                            │
│  Legacy Authentication Blocking:           │
│  ├─ Block basic authentication            │
│  ├─ Require modern authentication         │
│  ├─ Conditional Access policies           │
│  └─ Service principal restrictions        │
│                                            │
│  Monitoring:                               │
│  ├─ Password reset requests                │
│  ├─ Failed login attempts                  │
│  ├─ Compromised password alerts            │
│  └─ Anomalous sign-in activity            │
│                                            │
│  * (Microsoft recommends no expiration)    │
│                                            │
└────────────────────────────────────────────┘
```

---

## Data Flow

### Authentication & Authorization Flow

```
User Initiates Login
        │
        ▼
   Azure AD
   (Control 5: MFA Check)
        │
        ├─ MFA Challenge
        │  (Authenticator, Phone, FIDO2)
        │
        └─ Conditional Access Evaluation
           (Device compliance, location, risk)
        │
        ▼
   Authentication Decision
        │
        ├─ Success → Token Issued
        │           (Control 3: RBAC Check)
        │
        └─ Failure → Log Event
                    (Control 6: Monitoring)
```

### Security Event Flow

```
Security Event Occurs
        │
        ▼
   Event Logged
   (Control 6: Logging)
        │
        ▼
   Log Aggregation
   (Log Analytics)
        │
        ▼
   Analysis & Detection
   (Sentinel Detection Rules)
        │
        ├─ Automated Response
        │  (Disable account, block IP)
        │
        └─ Alert to Security Team
           (Incident creation)
           │
           ▼
        Investigation & Response
```

---

## Security Boundaries

### Management Plane
- Restricted to authorized administrators
- Protected by PIM (Control 3)
- Monitored by logging (Control 6)

### Data Plane
- Protected by application controls (Control 1)
- Backed up regularly (Control 7)
- Monitored for unusual access patterns

### Identity Plane
- Protected by strong credentials (Control 8)
- Enforced with MFA (Control 5)
- Monitored for compromise indicators

---

## Scalability Considerations

### Small Deployments (< 100 users)
- Implement all controls manually or with scripts
- Use shared Azure services (Log Analytics, Backup)
- Quarterly compliance reviews

### Medium Deployments (100-1000 users)
- Use Terraform for consistency
- Dedicated monitoring team
- Monthly compliance reviews

### Large Deployments (> 1000 users)
- Full Infrastructure-as-Code approach
- Azure Sentinel with advanced analytics
- Continuous monitoring and real-time response
- Dedicated security operations center (SOC)

---

## Disaster Recovery & Business Continuity

### Backup Strategy
- RPO: 24 hours (daily backups)
- RTO: 4 hours (system recovery target)
- Geo-redundant storage (Azure Backup)
- Regular recovery testing (quarterly)

### High Availability
- Multi-region deployment (if applicable)
- Load balancing across regions
- Automated failover

### Compliance & Audit Trail
- 90 days of detailed logs (control 6)
- 2+ years of audit logs (compliance)
- Immutable audit logs (if required)
- Regular compliance reports

---

## Next Steps

1. Review this architecture for your organization
2. Customize for your specific requirements
3. Choose implementation approach (Terraform, PowerShell, Manual)
4. Follow the Implementation Roadmap in `IMPLEMENTATION_ROADMAP.md`
5. Use the Compliance Checklist to track progress
