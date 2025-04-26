# Changelog

All notable changes to this project will be documented in this file.

---

## [1.2.0] - 2025-04-26
### Changed
- Replaced scutil-based user detection with `who | awk '/console/'` for improved reliability.
- Updated `get_logged_in_user()` to guarantee accurate shortname detection.
- Fixed failures when promoting or revoking admin rights during fast user switching or FileVault unlock sessions.
- Improved logging consistency for detected user names.

---

## [1.1.0] - 2025-04-26
### Fixed
- Corrected logged-in user detection to sanitize whitespace and line breaks.
- Added validation step to confirm user exists before attempting group changes.
- Fixed dseditgroup error: "Record was not found" during promote/revoke operations.
- Improved logging for safer user operations and better troubleshooting.

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