# Changelog

## [1.1.0] - 2025-04-26

### Added
- Implemented optional `DEBUG_MODE` to allow expanded internal logging for troubleshooting.
- Structured logging with timestamps for INFO, WARN, ERROR, and DEBUG levels to `/var/log/admin_rights_update.log`.
- Start and completion logging for each script execution.

### Changed
- Improved logged-in user detection by directly using `scutil show State:/Users/ConsoleUser` without any function wrapping.
- Removed the old `get_logged_in_user()` function to avoid username corruption in Jamf Pro environments.
- Modified admin rights promotion and revocation to use `dseditgroup` for compatibility with local, mobile, and MDM users.
- Enhanced script resilience against missing or unexpected user session conditions.

### Fixed
- Eliminated false user detection failures when running inside Jamf Pro agent context.
- Prevented admin rights modification errors caused by incorrect user handling.

---

## [1.0.0] - 2025-04-26

### Added
- Initial creation of script for revoking or promoting admin rights.
- Basic logging for success and failure to `/var/log/admin_rights_update.log`.
- First version designed for Jamf Pro parameterized execution.