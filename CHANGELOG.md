# Changelog

All notable changes to this project will be documented in this file.

---

## [1.0.0] - 2025-04-26
### Added
- Initial creation of `revoke_or_promote_admin.sh`.
- Support for promoting or revoking admin rights for the logged-in user.
- Accepts action via Jamf Pro Script Parameter 4 or standard command-line argument.
- Built-in safe detection of the console user using `scutil`.
- Full operational logging to `/var/log/admin_rights_update.log`.
- Clean console output for Jamf Pro compatibility.
- Implemented full validation, error handling, and safe exits.