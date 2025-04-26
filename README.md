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
  - As a Jamf Pro Script Parameter 4
  - Or as a standard command-line argument
- The script will:
  - Detect the active console user safely
  - Validate input arguments
  - Promote or revoke admin rights accordingly
  - Log all actions, warnings, errors, and debug info into `/var/log/admin_rights_update.log`

---

### Notes:
- Must be run as **root** (required for group membership changes).
- Designed for use inside **Jamf Pro** policies or **standalone Terminal execution**.
- Internal full logging to `/var/log/admin_rights_update.log`.
- Console output is filtered and clean for Jamf visibility.

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
| **Command Line (Terminal)** | `sudo ./revoke_or_promote_admin.sh promote` |
| **Command Line (Terminal)** | `sudo ./revoke_or_promote_admin.sh revoke` |

---

### Requirements:
- macOS 11+ (tested up to macOS 15)
- Root privileges
- Jamf Pro (optional, for scripted deployment)

---

### Version:
`v1.0.0`

---

> End of Script: **revoke_or_promote_admin.sh**  
> MacJediWizard Consulting, Inc. © 2025. All rights reserved.