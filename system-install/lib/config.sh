#!/bin/bash

# Configuration Management Library
# Handles loading and validating configuration files

# Configuration loader
load_configuration() {
    local config_file="$CONFIG_DIR/$1"
    if [[ -f "$config_file" ]]; then
        log_info "Loading configuration: $1"
        source "$config_file"
    else
        log_error "Configuration file not found: $config_file"
        exit 1
    fi
}

# Load all configuration files
load_configurations() {
    log_step "Loading configuration files..."
    load_configuration "packages.conf"
    load_configuration "services.conf"
    log_success "All configurations loaded successfully"
}

# Validate configuration
validate_configuration() {
    log_info "Validating configuration..."
    
    # Check if required variables are set
    local required_vars=(
        "BASE_PACKAGES"
        "SYSTEM_SERVICES"
        "USER_SERVICES"
    )
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            log_error "Required configuration variable '$var' is not set"
            exit 1
        fi
    done
    
    log_success "Configuration validation passed"
}

# Apply user configuration files
apply_configurations() {
    log_step "Applying configuration files..."
    
    # Copy zsh configuration
    if [[ -f "$CONFIG_DIR/zshrc" ]]; then
        log_info "Applying zsh configuration..."
        cp "$CONFIG_DIR/zshrc" "$HOME/.zshrc"
        log_success "Zsh configuration applied"
    fi
    
    # Copy git configuration
    if [[ -f "$CONFIG_DIR/gitconfig" ]]; then
        log_info "Applying git configuration..."
        cp "$CONFIG_DIR/gitconfig" "$HOME/.gitconfig"
        log_success "Git configuration applied"
    fi
    
    # Copy openbox autostart
    if [[ -f "$CONFIG_DIR/openbox-autostart" ]]; then
        log_info "Applying openbox autostart configuration..."
        mkdir -p "$HOME/.config/openbox"
        cp "$CONFIG_DIR/openbox-autostart" "$HOME/.config/openbox/autostart"
        chmod +x "$HOME/.config/openbox/autostart"
        log_success "Openbox autostart configuration applied"
    fi
}
