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
#                   - Detect the currently logged-in console user safely using scutil
#                   - Validate the requested action
#                   - Add or remove the user from the admin group using dseditgroup
#                   - Log all actions, warnings, errors, and debug information into /var/log/admin_rights_update.log
#                   - Allow optional DEBUG_MODE for detailed troubleshooting
#
# Notes:
# - Must be run as root (required for group modifications).
# - Designed for use inside Jamf Pro policies with script parameters or standalone use.
# - DEBUG_MODE can be enabled internally to show additional debug output.
#
# License:
# This script is licensed under the MIT License.
# See the LICENSE file in the root of this repository for details.
#
# Change Log:
# Version 1.0.0 - 2025-04-26
#   - Initial creation of script.
#
# Version 1.1.0 - 2025-04-26
#   - Added optional DEBUG_MODE for expanded internal logging.
#   - Improved console user detection using scutil directly without wrapping function.
#   - Polished admin rights promotion and revocation with dseditgroup.
#   - Finalized for Jamf Pro deployment with structured, timestamped logging.
#
#########################################################################################################################################################################

# Global Variables
LOG_FILE="/var/log/admin_rights_update.log"
SCRIPT_VERSION="1.1.0"
DEBUG_MODE="false"

# Logging Functions
log_info() { printf "[%s] [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_warn() { printf "[%s] [WARN] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_error() { printf "[%s] [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_debug() {
    if [[ "$DEBUG_MODE" == "true" ]]; then
        printf "[%s] [DEBUG] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
    fi
}

# Function to revoke admin rights
revoke_admin_rights() {
    local user="$1"

    log_debug "Attempting to revoke admin rights from user: $user"
    if dseditgroup -o edit -d "$user" -t user admin; then
        log_info "Successfully revoked admin rights for user: $user"
    else
        log_warn "User $user may not have been in the admin group. Revocation skipped or unnecessary."
    fi
}

# Function to promote to admin rights
promote_to_admin() {
    local user="$1"

    log_debug "Attempting to promote user: $user to admin"
    if dseditgroup -o edit -a "$user" -t user admin; then
        log_info "Successfully granted admin rights to user: $user"
    else
        log_warn "User $user may already have admin rights. Promotion skipped or unnecessary."
    fi
}

# Main Execution
main() {
    local action="$1"
    local user

    log_info "Starting admin rights update script version $SCRIPT_VERSION"

    if [[ -z "$action" ]]; then
        log_error "No action specified. Usage: $0 [promote|revoke]"
        return 1
    fi

    if [[ "$action" != "promote" && "$action" != "revoke" ]]; then
        log_error "Invalid action specified: $action. Must be 'promote' or 'revoke'."
        return 1
    fi

    user=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && !/loginwindow/ { print $3 }')

    if [[ -z "$user" ]]; then
        log_error "Failed to retrieve logged-in user."
        return 1
    fi

    log_info "Detected logged-in user: $user"
    log_debug "Detected user raw value: '$user'"

    if [[ "$action" == "promote" ]]; then
        promote_to_admin "$user"
    elif [[ "$action" == "revoke" ]]; then
        revoke_admin_rights "$user"
    fi

    log_info "Admin rights update script completed."
}

# Detecting input
# If Jamf Pro parameter 4 ($4) exists, use it, otherwise use command-line argument 1
ACTION="${4:-$1}"

main "$ACTION"