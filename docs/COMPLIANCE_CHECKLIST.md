# Essential 8 - DISP Compliance Checklist

Track your organization's Essential 8 compliance against DISP standards.

## Control 1: Application Whitelisting
- [ ] Approved applications list defined
- [ ] AppLocker policies deployed to all endpoints
- [ ] Exceptions documented and approved
- [ ] Monthly review of AppLocker events
- [ ] Monitoring dashboard configured

**DISP Requirement:** All applications must be explicitly approved before execution.

---

## Control 2: Patch Management
- [ ] Monthly patch deployment schedule defined
- [ ] Critical patches deployed within 7 days
- [ ] Non-critical patches deployed within 30 days
- [ ] Pre-production testing completed
- [ ] Update Management configured in Azure
- [ ] Compliance reports generated monthly

**DISP Requirement:** All systems must be patched within defined timeframes.

---

## Control 3: Restricting Admin Privileges
- [ ] Inventory of privileged accounts completed
- [ ] Just-In-Time (JIT) access enabled for admin roles
- [ ] PIM approval workflows configured
- [ ] Time-limited role assignments (max 4 hours)
- [ ] Quarterly access reviews scheduled
- [ ] Service account permissions minimized

**DISP Requirement:** Administrative privileges limited to necessity and time-bounded.

---

## Control 4: User Application Hardening
- [ ] Attack Surface Reduction (ASR) rules deployed
- [ ] Office macro policies configured
- [ ] Script execution policies enforced
- [ ] Browser pop-ups and plugins disabled
- [ ] USB restrictions configured
- [ ] Monthly vulnerability scans completed

**DISP Requirement:** Applications hardened to prevent common attack vectors.

---

## Control 5: Multi-Factor Authentication (MFA)
- [ ] MFA enabled for all users
- [ ] MFA mandatory for admin accounts
- [ ] Conditional Access policies configured
- [ ] MFA registration enforced
- [ ] Backup authentication methods enabled
- [ ] MFA enforcement dashboard monitored weekly

**DISP Requirement:** All user authentication requires multiple factors.

---

## Control 6: Security Logging & Monitoring
- [ ] Azure Monitor configured
- [ ] Log Analytics Workspace created
- [ ] Azure Sentinel enabled (or alternative SIEM)
- [ ] Critical alerts configured
- [ ] Daily log review process established
- [ ] 90-day log retention enabled
- [ ] Incident response procedures documented

**DISP Requirement:** All security events logged and monitored in real-time.

---

## Control 7: Regular Backups
- [ ] Daily backup schedule configured
- [ ] Recovery Services Vault created
- [ ] Geo-redundant storage (GRS) enabled
- [ ] Backup encryption enabled
- [ ] Quarterly recovery testing completed
- [ ] Recovery time objective (RTO): 4 hours
- [ ] Recovery point objective (RPO): 24 hours

**DISP Requirement:** Regular backups tested and verified for recovery capability.

---

## Control 8: Credential Hygiene
- [ ] Password policy enforced:
  - [ ] Minimum 14 characters
  - [ ] Complexity required (upper, lower, number, symbol)
  - [ ] No reuse of last 24 passwords
  - [ ] Account lockout after 10 failed attempts
- [ ] Banned password list configured
- [ ] Leaked credential alerts enabled
- [ ] Legacy authentication (Basic Auth) blocked
- [ ] Conditional Access policy enforces strong auth
- [ ] Quarterly password audit completed

**DISP Requirement:** Strong credentials required and legacy authentication blocked.

---

## Summary

| Control | Status | Owner | Last Review |
|---------|--------|-------|-------------|
| 1. Application Control | ☐ Not Started | | |
| 2. Patch Management | ☐ Not Started | | |
| 3. Admin Privileges | ☐ Not Started | | |
| 4. User App Hardening | ☐ Not Started | | |
| 5. MFA | ☐ Not Started | | |
| 6. Logging & Monitoring | ☐ Not Started | | |
| 7. Regular Backups | ☐ Not Started | | |
| 8. Credential Hygiene | ☐ Not Started | | |

---

## DISP Compliance Standards

**Reference:** Australian Government Information Security Manual (ISM) - Essential 8 Maturity Model

### Maturity Levels

| Level | Description |
|-------|-------------|
| **1** | Ad hoc / Reactive - Minimal controls |
| **2** | Defined - Basic controls documented |
| **3** | Managed - Controls monitored regularly |
| **4** | Optimized - Continuous improvement |

**DISP Target:** Level 3 (Managed) minimum for all controls

---

## Approval & Sign-Off

- **Compliance Officer:** _________________ Date: _______
- **Security Officer:** _________________ Date: _______
- **IT Manager:** _________________ Date: _______

---

## Review Schedule

- Monthly: Control compliance status
- Quarterly: Access reviews and testing
- Semi-annually: Policy updates
- Annually: Full compliance audit

Last Updated: 2026-05-14
Next Review: 2026-08-14
