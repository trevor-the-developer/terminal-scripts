#!/bin/bash

# System Fixes and Configuration Library
# Handles Archcraft-specific fixes and optimizations

# Fix common Archcraft issues
fix_archcraft_issues() {
    log_step "Applying common Archcraft fixes..."
    
    # Import and trust warpdotdev PGP key
    log_info "Configuring warpdotdev PGP key..."
    if sudo pacman-key --recv-keys 19A1E427461B1795F73F629631F4254AFE49E02E; then
        sudo pacman-key --lsign-key 19A1E427461B1795F73F629631F4254AFE49E02E
        log_success "warpdotdev PGP key configured"
    else
        log_warning "Failed to configure warpdotdev PGP key"
    fi
    
    # Update icon caches
    log_info "Updating icon caches..."
    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor/
    gtk-update-icon-cache -f ~/.local/share/icons/ 2>/dev/null || true
    gtk-update-icon-cache -f ~/.icons/ 2>/dev/null || true
    log_success "Icon caches updated"
    
    # Initialize jgmenu
    log_info "Initializing jgmenu..."
    jgmenu_run init --icon-size=22 >/dev/null 2>&1 || true
    log_success "jgmenu initialized"
    
    # Remove ksuperkey to prevent conflicts
    log_info "Removing ksuperkey to prevent Super key conflicts..."
    sudo pacman -Rs ksuperkey --noconfirm || true
    log_success "ksuperkey removed"
    
    # Disable ksuperkey in autostart
    if [[ -f ~/.config/openbox/autostart ]]; then
        sed -i 's/^ksuperkey/#ksuperkey/' ~/.config/openbox/autostart
        log_success "Disabled ksuperkey in autostart"
    fi
    
    log_success "Archcraft fixes applied"
}

# Configure openbox keybindings
configure_openbox() {
    log_step "Configuring Openbox keybindings..."
    
    # Check if openbox configuration exists
    if [[ -f ~/.config/openbox/rc.xml ]]; then
        # Backup original configuration
        cp ~/.config/openbox/rc.xml ~/.config/openbox/rc.xml.backup
        log_info "Backed up original Openbox configuration"
        
        # Modify W-space binding to use rofi-launcher
        sed -i '/<keybind key=\"W-space\">/,/<\/keybind>/{
            s/<action name=\"ShowMenu\">/<action name=\"Execute\">/
            s/<menu>root-menu<\/menu>/<command>rofi-launcher<\/command>/
        }' ~/.config/openbox/rc.xml
        
        # Reconfigure openbox
        if openbox --reconfigure; then
            log_success "Openbox keybindings configured"
        else
            log_warning "Failed to reconfigure Openbox"
        fi
    else
        log_warning "Openbox configuration file not found"
    fi
}

# Optimize system performance
optimize_system() {
    log_step "Optimizing system performance..."
    
    # Configure swappiness
    log_info "Configuring swappiness..."
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    
    # Configure I/O scheduler
    log_info "Configuring I/O scheduler..."
    echo 'ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/scheduler}="mq-deadline"' | sudo tee /etc/udev/rules.d/60-ioschedulers.rules
    
    # Configure journald
    log_info "Configuring journald..."
    sudo mkdir -p /etc/systemd/journald.conf.d
    echo -e "[Journal]\nSystemMaxUse=500M\nSystemMaxFiles=5" | sudo tee /etc/systemd/journald.conf.d/00-journal-size.conf
    
    log_success "System optimization completed"
}

# Configure firewall
configure_firewall() {
    log_step "Configuring firewall..."
    
    # Enable UFW
    log_info "Enabling UFW firewall..."
    sudo ufw --force enable
    
    # Set default policies
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    
    # Allow SSH (if needed)
    # sudo ufw allow ssh
    
    log_success "Firewall configured"
}

# Update system mirror list
update_mirrors() {
    log_step "Updating mirror list..."
    
    # Update mirror list with reflector
    log_info "Updating mirrors with reflector..."
    sudo reflector --country 'United States' --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    
    log_success "Mirror list updated"
}
