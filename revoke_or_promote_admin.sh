#!/bin/bash

#########################################################################################################################################################################
#
# MacJediWizard Consulting, Inc.
# Copyright (c) 2025 MacJediWizard Consulting, Inc.
# All rights reserved.
# Created by: William Grzybowski
#
# Script: revoke_or_promote_admin.sh
#
# Description: - This script promotes or revokes admin rights for the current logged-in user on macOS.
#               - The action ("promote" or "revoke") can be passed as a command-line argument or as Jamf Pro Parameter 4.
#               - The script will:
#                   - Detect the currently logged-in console user safely
#                   - Validate the requested action
#                   - Add or remove the user from the admin group using dscl
#                   - Log all actions, warnings, errors, and debug information into /var/log/admin_rights_update.log
#
# Notes:
# - Must be run as root (required for group modifications).
# - Designed for use inside Jamf Pro policies with script parameters or standalone use.
#
# License:
# This script is licensed under the MIT License.
# See the LICENSE file in the root of this repository for details.
#
# Change Log:
# Version 1.0.0 - 2025-04-26
#   - Initial creation of script.
#   - Added support for revoking or promoting admin rights via command-line argument or Jamf parameter.
#   - Integrated logging system for audit purposes.
#   - Implemented full validation and error handling.
#
# Version 1.1.0 - 2025-04-26
#   - Fixed issue where dseditgroup could fail with "Record was not found."
#   - Updated get_logged_in_user() to sanitize username and trim whitespace.
#   - Added verification that the detected user exists using id command before modifying group membership.
#   - Improved logging for user detection and validation process.
#
# Version 1.2.0 - 2025-04-26
#   - Replaced scutil-based logged-in user detection with who/awk method for higher reliability.
#   - Updated get_logged_in_user() to use who | awk '/console/' for accurate shortname detection.
#   - Ensured correct user targeting when promoting or revoking admin rights.
#   - Improved resilience against FileVault and fast-user-switching session issues.
#
# Version 1.2.1 - 2025-04-26
#   - Added validation to ensure detected user is a local system account using dscl.
#   - Improved protection against network or mobile users that dseditgroup cannot modify.
#   - Enhanced logging when user validation fails.
#
# Version 1.3.0 - 2025-04-26
#   - Updated admin rights modifications to use dscl directly instead of dseditgroup.
#   - Removed local user validation to allow mobile, MDM, and network-bound accounts.
#   - Simplified and strengthened admin rights assignment for Jamf Pro compatibility.
#
# Version 1.3.1 - 2025-04-26
#   - Added second-stage username sanitization inside main() to eliminate hidden whitespace issues before dscl operations.
#   - Ensured reliable group modification even in Jamf Pro environments passing variables with unexpected formatting.
#########################################################################################################################################################################

# Global Variables
LOG_FILE="/var/log/admin_rights_update.log"
SCRIPT_VERSION="1.3.1"

# Logging Functions
log_info() { printf "[%s] [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_warn() { printf "[%s] [WARN] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_error() { printf "[%s] [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }

# Function to get the current logged-in user
get_logged_in_user() {
    local logged_in_user;
    logged_in_user=$(who | awk '/console/ { print $1 }')

    if [[ -z "$logged_in_user" ]]; then
        log_error "Unable to determine logged-in console user."
        return 1
    fi

    logged_in_user=$(printf "%s" "$logged_in_user" | tr -d '[:space:]')

    log_info "Detected logged-in user shortname: $logged_in_user"
    printf "%s" "$logged_in_user"
}

# Function to revoke admin rights
revoke_admin_rights() {
    local user="$1"

    if dscl . -delete /Groups/admin GroupMembership "$user"; then
        log_info "Successfully revoked admin rights for user: $user"
    else
        log_error "Failed to revoke admin rights for user: $user"
        return 1
    fi
}

# Function to promote to admin rights
promote_to_admin() {
    local user="$1"

    if dscl . -append /Groups/admin GroupMembership "$user"; then
        log_info "Successfully granted admin rights to user: $user"
    else
        log_error "Failed to promote user: $user to admin."
        return 1
    fi
}

# Main Execution
main() {
    local action="$1"
    local user;

    if [[ -z "$action" ]]; then
        log_error "No action specified. Usage: $0 [promote|revoke]"
        return 1
    fi

    if [[ "$action" != "promote" && "$action" != "revoke" ]]; then
        log_error "Invalid action specified: $action. Must be 'promote' or 'revoke'."
        return 1
    fi

    if ! user=$(get_logged_in_user); then
        log_error "Failed to retrieve logged-in user."
        return 1
    fi

    # Re-sanitize user again to remove hidden characters before dscl
    user=$(printf "%s" "$user" | tr -d '[:space:]')

    if [[ "$action" == "promote" ]]; then
        promote_to_admin "$user"
    elif [[ "$action" == "revoke" ]]; then
        revoke_admin_rights "$user"
    fi
}

# Detecting input
# If Jamf Pro parameter 4 ($4) exists, use it, otherwise use command-line argument 1
ACTION="${4:-$1}"

main "$ACTION"