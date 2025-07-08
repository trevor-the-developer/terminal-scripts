#!/bin/bash

# Service Management Library
# Handles systemd service configuration

# Configure system services
configure_services() {
    log_step "Configuring system services..."
    
    # Enable system services
    log_info "Enabling system services..."
    for service in "${SYSTEM_SERVICES[@]}"; do
        log_info "Enabling service: $service"
        if sudo systemctl enable "$service"; then
            log_success "Enabled: $service"
        else
            log_warning "Failed to enable: $service"
        fi
    done
    
    # Start services immediately
    log_info "Starting services..."
    for service in "${START_NOW_SERVICES[@]}"; do
        log_info "Starting service: $service"
        if sudo systemctl start "$service"; then
            log_success "Started: $service"
        else
            log_warning "Failed to start: $service"
        fi
    done
    
    # Enable user services
    log_info "Enabling user services..."
    for service in "${USER_SERVICES[@]}"; do
        log_info "Enabling user service: $service"
        if systemctl --user enable "$service"; then
            log_success "Enabled user service: $service"
        else
            log_warning "Failed to enable user service: $service"
        fi
    done
    
    log_success "Service configuration completed"
}

# Check service status
check_service_status() {
    local service=$1
    local service_type=${2:-"system"}
    
    if [[ "$service_type" == "user" ]]; then
        systemctl --user is-active "$service" >/dev/null 2>&1
    else
        systemctl is-active "$service" >/dev/null 2>&1
    fi
}

# Display service status report
service_status_report() {
    log_step "Service Status Report"
    
    echo "System Services:"
    for service in "${SYSTEM_SERVICES[@]}"; do
        if check_service_status "$service"; then
            log_success "$service: Active"
        else
            log_warning "$service: Inactive"
        fi
    done
    
    echo ""
    echo "User Services:"
    for service in "${USER_SERVICES[@]}"; do
        if check_service_status "$service" "user"; then
            log_success "$service: Active"
        else
            log_warning "$service: Inactive"
        fi
    done
}
