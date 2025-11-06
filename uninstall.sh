#!/bin/bash
set -euo pipefail

# Omarchy Theme Generator - Uninstallation Script
# Removes installed omarchy-* scripts and restores backups

# ANSI Color codes
PINK='\033[95m'
CYAN='\033[96m'
BOLD='\033[1m'
RESET='\033[0m'
DIM='\033[2m'
YELLOW='\033[93m'

# Installation directories
INSTALL_BIN_DIR="$HOME/.local/share/omarchy/bin"
INSTALL_APPS_DIR="$HOME/.local/share/applications"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Print colored messages
print_header() {
    echo -e "${BOLD}${PINK}$1${RESET}"
}

print_info() {
    echo -e "${CYAN}$1${RESET}"
}

print_dim() {
    echo -e "${DIM}$1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}$1${RESET}"
}

print_success() {
    echo -e "${BOLD}${CYAN}$1${RESET}"
}

# Restore backup file if it exists
restore_backup() {
    local file="$1"
    local backup="${file}.backup"

    if [[ -f "$backup" ]]; then
        mv "$backup" "$file"
        print_info "   Restored backup: $(basename "$file")"
        return 0
    fi
    return 1
}

# Main uninstallation
main() {
    print_header "===================================="
    print_header "  Omarchy Theme Generator Removal"
    print_header "===================================="
    echo ""

    # Check if installation directory exists
    if [[ ! -d "$INSTALL_BIN_DIR" ]]; then
        print_warning "Installation directory not found: $INSTALL_BIN_DIR"
        print_info "Omarchy may not be installed or was already removed"
        echo ""
        exit 0
    fi

    print_info "Uninstalling scripts from $INSTALL_BIN_DIR"
    echo ""

    local removed_count=0
    local restored_count=0
    local not_found_count=0

    # Process only omarchy-* files from the source directory
    for source_script in "$SCRIPT_DIR"/omarchy-*; do
        # Skip if glob didn't match anything or file doesn't exist
        [[ -f "$source_script" ]] || continue

        # Skip if not executable (not a script)
        [[ -x "$source_script" ]] || continue

        local script_name=$(basename "$source_script")
        local installed_script="$INSTALL_BIN_DIR/$script_name"

        print_dim "   Removing: $script_name"

        if [[ -f "$installed_script" ]]; then
            rm "$installed_script"
            removed_count=$((removed_count + 1))

            # Try to restore backup
            if restore_backup "$installed_script"; then
                restored_count=$((restored_count + 1))
            fi
        else
            not_found_count=$((not_found_count + 1))
        fi
    done

    echo ""
    print_success "   Removed $removed_count script(s)"
    if [[ $restored_count -gt 0 ]]; then
        print_info "   Restored $restored_count backup(s)"
    fi
    echo ""

    # Remove timestamped backup files for scripts we installed
    print_info "Cleaning up timestamped backups..."
    local backup_cleaned=0
    for source_script in "$SCRIPT_DIR"/omarchy-*; do
        [[ -f "$source_script" ]] || continue
        [[ -x "$source_script" ]] || continue

        local script_name=$(basename "$source_script")
        local backup_pattern="$INSTALL_BIN_DIR/${script_name}.backup.*"

        for backup in $backup_pattern; do
            [[ -f "$backup" ]] || continue
            print_dim "   Removing: $(basename "$backup")"
            rm "$backup"
            backup_cleaned=1
        done
    done
    [[ $backup_cleaned -eq 1 ]] && echo ""

    # Remove desktop file
    local desktop_file="$INSTALL_APPS_DIR/theme-generator.desktop"
    if [[ -f "$desktop_file" ]]; then
        print_info "Removing desktop application..."
        rm "$desktop_file"

        # Restore backup if exists
        restore_backup "$desktop_file" || true

        # Update desktop database if available
        if command -v update-desktop-database >/dev/null 2>&1; then
            update-desktop-database "$INSTALL_APPS_DIR" 2>/dev/null || true
        fi

        print_success "   Desktop file removed"
        echo ""
    fi

    # Remove timestamped desktop backups
    local desktop_backups=("$INSTALL_APPS_DIR"/theme-generator.desktop.backup.*)
    if [[ -f "${desktop_backups[0]}" ]]; then
        print_info "Cleaning up desktop file backups..."
        for backup in "${desktop_backups[@]}"; do
            [[ -f "$backup" ]] || continue
            print_dim "   Removing: $(basename "$backup")"
            rm "$backup"
        done
        echo ""
    fi

    print_header "===================================="
    print_success "  Uninstallation Complete"
    print_header "===================================="
    echo ""

    if [[ $restored_count -gt 0 ]]; then
        print_info "Restored files:"
        for script in "$INSTALL_BIN_DIR"/omarchy-*; do
            if [[ -f "$script" ]]; then
                print_dim "   - $(basename "$script")"
            fi
        done
        echo ""
    fi

}

# Run main uninstallation
main
