#!/bin/bash

# System Finalisation Library
# Handles final system setup and cleanup

# Finalise system setup
finalise_setup() {
    log_step "Finalising system setup..."
    
    # Update mirror list
    update_mirrors
    
    # Rebuild initramfs
    log_info "Rebuilding initramfs..."
    sudo mkinitcpio -P
    log_success "Initramfs rebuilt"
    
    # Update GRUB configuration
    log_info "Updating GRUB configuration..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    log_success "GRUB configuration updated"
    
    # Clean package cache
    clean_package_cache
    
    log_success "System setup finalised"
}

# Display system information
display_system_info() {
    log_step "System Information"
    
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
    echo "Disk Usage: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
    echo "CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
}

# Generate installation report
generate_report() {
    local report_file="$HOME/archcraft-install-report.txt"
    
    log_step "Generating installation report..."
    
    {
        echo "# Archcraft Installation Report"
        echo "Date: $(date)"
        echo "User: $(whoami)"
        echo "Host: $(hostname)"
        echo ""
        echo "## System Information"
        display_system_info
        echo ""
        echo "## Service Status"
        service_status_report
        echo ""
        echo "## Installed Package Groups"
        echo "- Base system packages"
        echo "- Development tools"
        echo "- Desktop environment"
        echo "- Multimedia packages"
        echo "- Security tools"
        echo "- Gaming packages"
        echo ""
        echo "## Key Shortcuts"
        echo "- Super+Space: Application menu"
        echo "- Alt+F1: Alternative menu access"
        echo "- Ctrl+Alt+L: Lock screen"
        echo "- Super+Arrow Keys: Window management"
        echo ""
        echo "## Next Steps"
        echo "1. Reboot the system"
        echo "2. Test all functionality"
        echo "3. Customise themes and settings"
        echo "4. Install additional software as needed"
    } > "$report_file"
    
    log_success "Installation report generated: $report_file"
}

# Display completion message
display_completion() {
    log_success "🎉 Archcraft system installation completed successfully!"
    echo ""
    echo "📋 Installation Summary:"
    echo "  ✅ Packages installed and configured"
    echo "  ✅ Services enabled and started"
    echo "  ✅ Configuration files applied"
    echo "  ✅ System fixes applied"
    echo "  ✅ Openbox configured"
    echo ""
    echo "🔧 Key Shortcuts:"
    echo "  🚀 Super+Space: Application menu"
    echo "  📱 Alt+F1: Alternative menu access"
    echo "  🔒 Ctrl+Alt+L: Lock screen"
    echo "  🪟 Super+Arrow Keys: Window management"
    echo ""
    echo "📖 For more information, check the installation report in your home directory."
    echo ""
    log_warning "⚠️  Please reboot the system to ensure all changes take effect."
    echo ""
    echo "🔄 To reboot now, run: sudo reboot"
}

# Cleanup temporary files
cleanup() {
    log_step "Cleaning up temporary files..."
    
    # Remove temporary files
    sudo rm -rf /tmp/archcraft-install-*
    
    # Clean package cache
    clean_package_cache
    
    log_success "Cleanup completed"
}
