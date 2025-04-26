# revoke_or_promote_admin.sh

---

### MacJediWizard Consulting, Inc.
**Copyright (c) 2025 MacJediWizard Consulting, Inc.**  
All rights reserved.  
Created by: **William Grzybowski**

---

### Description:
- This script promotes or revokes admin rights for the currently logged-in user on macOS.
- The requested action ("promote" or "revoke") can be passed:
  - As a **Jamf Pro Script Parameter 4**
  - Or as a **standard command-line argument**
- The script will:
  - Detect the active console user safely via `scutil`
  - Validate and sanitize input
  - Promote or revoke admin rights securely using `dseditgroup`
  - Log all actions, warnings, errors, and debug info into `/var/log/admin_rights_update.log`
  - Optionally enable `DEBUG_MODE` internally for detailed troubleshooting

---

### Notes:
- Must be run as **root** (required for group membership changes).
- Designed for use inside **Jamf Pro policies** or **standalone Terminal execution**.
- Internal full structured logging system into `/var/log/admin_rights_update.log`.
- Clean console output designed for Jamf Pro visibility.

---

### License:
This project is licensed under the **MIT License**.  
See the [LICENSE](LICENSE) file for full details.

---

### Usage Examples:
| Context | Command |
|:--------|:--------|
| **Jamf Pro Policy** (Parameter 4 = `promote`) | Runs automatically |
| **Jamf Pro Policy** (Parameter 4 = `revoke`) | Runs automatically |
| **Terminal (Command Line)** | `sudo ./revoke_or_promote_admin.sh promote` |
| **Terminal (Command Line)** | `sudo ./revoke_or_promote_admin.sh revoke` |

---

### Requirements:
- macOS 11 or higher (tested through macOS 15.x)
- Root privileges
- Jamf Pro (optional for managed deployment)

---

### Version:
`v1.1.0`

---

> End of Script Documentation: **revoke_or_promote_admin.sh**  
> MacJediWizard Consulting, Inc. © 2025. All rights reserved.