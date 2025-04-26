#!/bin/bash

#########################################################################################################################################################################
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
#                   - Add or remove the user from the admin group accordingly
#                   - Log all actions, warnings, errors, and debug information into /var/log/admin_rights_update.log
#
# Notes:
# - Must be run as root (required for dseditgroup changes).
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
#########################################################################################################################################################################

# Global Variables
LOG_FILE="/var/log/admin_rights_update.log"
SCRIPT_VERSION="1.0.0"

# Logging Functions
log_info() { printf "[%s] [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_warn() { printf "[%s] [WARN] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
log_error() { printf "[%s] [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }

# Function to get the current logged-in user
get_logged_in_user() {
    local logged_in_user;
    logged_in_user=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && !/loginwindow/ { print $3 }')

    if [[ -z "$logged_in_user" ]]; then
        log_error "Unable to determine logged-in user."
        return 1
    fi

    log_info "Detected logged-in user: $logged_in_user"
    printf "%s" "$logged_in_user"
}

# Function to revoke admin rights
revoke_admin_rights() {
    local user="$1"

    if dseditgroup -o edit -d "$user" -t user admin; then
        log_info "Successfully revoked admin rights for user: $user"
    else
        log_error "Failed to revoke admin rights for user: $user"
        return 1
    fi
}

# Function to promote to admin rights
promote_to_admin() {
    local user="$1"

    if dseditgroup -o edit -a "$user" -t user admin; then
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