# Changelog

All notable changes to this project will be documented in this file.

---

## [1.3.1] - 2025-04-26
### Fixed
- Added second-stage sanitization of the detected logged-in username using `tr -d '[:space:]'` inside `main()` function.
- Eliminated issues where Jamf Pro or shell environments could pass hidden whitespace characters causing `dscl` group modification failures.
- Ensured admin rights promotion and revocation are consistently successful regardless of input formatting.
- Bumped internal script version to 1.3.1 for reliability improvements.

---

## [1.3.0] - 2025-04-26
### Changed
- Replaced admin rights modifications to use `dscl` instead of `dseditgroup`.
- Removed local system user validation to support mobile, network, and Jamf Connect accounts.
- Simplified promotion and revocation of admin rights with direct group edits.

---

## [1.2.1] - 2025-04-26
### Fixed
- Added validation step to confirm detected console user is a local user before attempting admin modifications.
- Improved logging clarity during user validation steps.
- Prevented dseditgroup failures in Jamf Pro deployments with network-bound or mobile users.

---

## [1.2.0] - 2025-04-26
### Changed
- Replaced scutil-based console user detection with who/awk.
- Improved fast-user-switching and FileVault login session resilience.
- Made admin promotion and revocation more consistent across macOS 15+.

---

## [1.1.0] - 2025-04-26
### Fixed
- Corrected detection and handling of logged-in users.
- Improved error handling when promoting or revoking admin rights.

---

## [1.0.0] - 2025-04-26
### Added
- Initial release.
- Support for promoting and revoking admin rights.
- Integrated full logging and safe exit handling.