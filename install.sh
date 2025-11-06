#!/bin/bash
set -euo pipefail

# Omarchy Theme Generator - Installation Script
# Installs omarchy-* scripts to ~/.local/share/omarchy/bin
# Backs up existing files before overwriting

# ANSI Color codes
PINK='\033[95m'
CYAN='\033[96m'
BOLD='\033[1m'
RESET='\033[0m'
DIM='\033[2m'

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

print_success() {
    echo -e "${BOLD}${CYAN}$1${RESET}"
}

# Generate timestamp for backup files
get_timestamp() {
    date +%Y%m%d_%H%M%S
}

# Backup existing file with timestamp if needed
backup_file() {
    local file="$1"
    local backup_base="${file}.backup"

    if [[ ! -f "$file" ]]; then
        return 0  # Nothing to backup
    fi

    # Check if .backup already exists
    if [[ -f "$backup_base" ]]; then
        # Create timestamped backup instead
        local timestamp=$(get_timestamp)
        local backup_file="${backup_base}.${timestamp}"
        mv "$file" "$backup_file"
        print_info "   Backed up existing file: $(basename "$backup_file")"
    else
        # Create simple .backup
        mv "$file" "$backup_base"
        print_info "   Backed up existing file: $(basename "$backup_base")"
    fi
}

# Main installation
main() {
    print_header "=================================="
    print_header "  Omarchy Theme Generator Setup"
    print_header "=================================="
    echo ""

    # Create installation directories
    print_info "Creating installation directories..."
    mkdir -p "$INSTALL_BIN_DIR"
    mkdir -p "$INSTALL_APPS_DIR"
    echo ""

    # Install omarchy-* scripts
    print_info "Installing scripts to $INSTALL_BIN_DIR"
    echo ""

    local installed_count=0
    local backed_up_count=0

    for script in "$SCRIPT_DIR"/omarchy-*; do
        if [[ -f "$script" ]] && [[ -x "$script" ]]; then
            local script_name=$(basename "$script")
            local target="$INSTALL_BIN_DIR/$script_name"

            print_dim "   Installing: $script_name"

            # Backup existing file if present
            if [[ -f "$target" ]]; then
                backup_file "$target"
                backed_up_count=$((backed_up_count + 1))
            fi

            # Copy new file
            cp "$script" "$target"
            chmod +x "$target"
            installed_count=$((installed_count + 1))
        fi
    done

    echo ""
    print_success "   Installed $installed_count script(s)"
    if [[ $backed_up_count -gt 0 ]]; then
        print_info "   Created $backed_up_count backup(s)"
    fi
    echo ""

    # Install desktop file if it exists
    if [[ -f "$SCRIPT_DIR/theme-generator.desktop" ]]; then
        print_info "Installing desktop application..."
        local desktop_target="$INSTALL_APPS_DIR/theme-generator.desktop"

        if [[ -f "$desktop_target" ]]; then
            backup_file "$desktop_target"
        fi

        cp "$SCRIPT_DIR/theme-generator.desktop" "$desktop_target"
        chmod +x "$desktop_target"

        # Update desktop database if available
        if command -v update-desktop-database >/dev/null 2>&1; then
            update-desktop-database "$INSTALL_APPS_DIR" 2>/dev/null || true
        fi

        print_success "   Desktop file installed"
        echo ""
    fi

    print_header "=================================="
    print_success "  Installation Complete"
    print_header "=================================="
    echo ""
    print_info "Run 'omarchy-theme-generate --help' to get started"
    echo ""
}

# Run main installation
main
