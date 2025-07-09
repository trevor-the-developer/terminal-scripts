#!/bin/bash

# Archcraft System Installation Orchestrator
# Lightweight main script that coordinates the installation process

set -e  # Exit on any error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
LIB_DIR="$SCRIPT_DIR/lib"

# Source all library files
source "$LIB_DIR/logging.sh"
source "$LIB_DIR/config.sh"
source "$LIB_DIR/packages.sh"
source "$LIB_DIR/services.sh"
source "$LIB_DIR/fixes.sh"
source "$LIB_DIR/finalise.sh"

# Pre-installation checks
pre_install_checks() {
    log_step "Running pre-installation checks..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
    
    # Check if required directories exist
    if [[ ! -d "$CONFIG_DIR" ]]; then
        log_error "Configuration directory not found: $CONFIG_DIR"
        exit 1
    fi
    
    if [[ ! -d "$LIB_DIR" ]]; then
        log_error "Library directory not found: $LIB_DIR"
        exit 1
    fi
    
    # Check for required commands
    local required_commands=("sudo" "pacman" "systemctl")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    log_success "Pre-installation checks passed"
}

# Main installation orchestrator
main() {
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Archcraft System Installation Script                     ║"
    echo "║                          Modular Architecture                               ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    
    # Pre-installation checks
    pre_install_checks
    
    # Load and validate configurations
    load_configurations
    validate_configuration
    
    # Installation steps
    log_step "Starting installation process..."
    
    # Step 1: Package Installation
    install_packages
    install_aur_packages
    
    # Step 2: Service Configuration
    configure_services
    
    # Step 3: Apply User Configurations
    apply_configurations
    
    # Step 4: Apply System Fixes
    fix_archcraft_issues
    configure_openbox
    optimise_system
    configure_firewall
    
    # Step 5: Finalisation
    finalise_setup
    
    # Step 6: Generate Report and Cleanup
    generate_report
    cleanup
    
    # Display completion message
    display_completion
}

# Handle script interruption
trap 'log_error "Installation interrupted!"; exit 1' INT TERM

# Run main function
main "$@"
