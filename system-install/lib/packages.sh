#!/bin/bash

# Package Management Library
# Handles package installation and management

# Install package groups
install_packages() {
    log_step "Installing package groups..."
    
    # Update system first
    log_info "Updating system..."
    sudo pacman -Syu --noconfirm
    
    # Install package groups
    local groups=(
        "BASE_PACKAGES"
        "DEV_TOOLS" 
        "COMPRESSION_TOOLS"
        "FILESYSTEM_TOOLS"
        "GRAPHICS_FIRMWARE"
        "ARCHCRAFT_DE"
        "NETWORKING"
        "SECURITY"
        "POWER_MANAGEMENT"
        "AUDIO"
        "DESKTOP_CORE"
        "MENU_LAUNCHERS"
        "TERMINAL_SHELL"
        "DEV_APPS"
        "MULTIMEDIA"
        "FILE_MANAGEMENT"
        "SYSTEM_MONITORING"
        "GAMING"
        "BROWSERS"
        "MAINTENANCE"
    )
    
    local total=${#groups[@]}
    local current=0
    
    for group in "${groups[@]}"; do
        current=$((current + 1))
        local -n packages=$group
        
        log_info "Installing $group packages... ($current/$total)"
        show_progress $current $total
        
        if ! sudo pacman -S --noconfirm "${packages[@]}"; then
            log_warning "Some packages in $group failed to install, continuing..."
        fi
    done
    
    log_success "Package installation completed"
}

# Install AUR packages
install_aur_packages() {
    log_step "Installing AUR packages..."
    
    # Check if yay is installed
    if ! command -v yay &> /dev/null; then
        log_error "yay is not installed. Please install yay first."
        exit 1
    fi
    
    # Install AUR packages
    if [[ ${#AUR_PACKAGES[@]} -gt 0 ]]; then
        log_info "Installing AUR packages..."
        yay -S --noconfirm "${AUR_PACKAGES[@]}"
        log_success "AUR packages installed"
    else
        log_info "No AUR packages to install"
    fi
}

# Update package database
update_package_database() {
    log_info "Updating package database..."
    sudo pacman -Sy --noconfirm
    log_success "Package database updated"
}

# Clean package cache
clean_package_cache() {
    log_info "Cleaning package cache..."
    sudo pacman -Sc --noconfirm
    log_success "Package cache cleaned"
}
