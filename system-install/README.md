# Archcraft System Installation Suite

A modular and comprehensive system installation and configuration suite for Archcraft Linux.

## 📁 Directory Structure

```
system-install/
├── README.md                    # This documentation
├── system_audit.md             # Complete system audit and documentation
├── install_system.sh           # Main orchestrator script
├── config/                     # Configuration files
│   ├── packages.conf           # Package groups and lists
│   ├── services.conf           # System and user services
│   ├── zshrc                   # Zsh shell configuration
│   ├── gitconfig              # Git configuration
│   └── openbox-autostart      # Openbox autostart template
└── lib/                        # Function libraries
    ├── logging.sh              # Logging and output utilities
    ├── config.sh               # Configuration management
    ├── packages.sh             # Package installation
    ├── services.sh             # Service management
    ├── fixes.sh                # System fixes and optimisations
    └── finalise.sh             # Finalisation and cleanup
```

## 🚀 Quick Start

### Basic Installation
```bash
cd ~/Support/system-install
chmod +x install_system.sh
./install_system.sh
```

### Custom Installation
1. Edit configuration files in `config/` directory
2. Run the installer: `./install_system.sh`

## 📋 Configuration Files

### `config/packages.conf`
Defines package groups for installation:
- `BASE_PACKAGES`: Core system packages
- `DEV_TOOLS`: Development tools
- `ARCHCRAFT_DE`: Desktop environment
- `MULTIMEDIA`: Media applications
- `GAMING`: Gaming packages
- And more...

### `config/services.conf`
Defines system services:
- `SYSTEM_SERVICES`: System-level services
- `USER_SERVICES`: User-level services
- `START_NOW_SERVICES`: Services to start immediately

### `config/zshrc`
Zsh shell configuration with:
- Archcraft theme
- Useful aliases
- Environment variables
- Oh My Zsh setup

### `config/gitconfig`
Git configuration template with:
- User information
- Default settings
- Editor preferences

### `config/openbox-autostart`
Openbox autostart configuration with:
- Essential services
- Desktop environment setup
- Compositor and panel configuration

## 🔧 Library Functions

### `lib/logging.sh`
- Colored logging functions
- Progress indicators
- Debug output

### `lib/config.sh`
- Configuration loading
- Validation functions
- File application

### `lib/packages.sh`
- Package group installation
- AUR package management
- Progress tracking

### `lib/services.sh`
- Service enablement
- Status checking
- Service reports

### `lib/fixes.sh`
- Archcraft-specific fixes
- System optimisations
- Firewall configuration
- Openbox setup

### `lib/finalise.sh`
- System finalisation
- Report generation
- Cleanup procedures

## 🛠️ Usage Examples

### Install specific package groups
```bash
# Edit config/packages.conf to customise package selection
./install_system.sh
```

### Run only configuration application
```bash
# Source individual libraries for specific tasks
source lib/config.sh
apply_configurations
```

### Check service status
```bash
source lib/services.sh
service_status_report
```

## 🔍 Features

- **Modular Architecture**: Separate concerns into focused libraries
- **Comprehensive Logging**: Colored output and progress tracking
- **Error Handling**: Robust error checking and recovery
- **Configuration Management**: Centralised configuration files
- **System Optimisation**: Performance tweaks and fixes
- **Automated Reporting**: Installation reports and system info
- **Archcraft Integration**: Specific fixes for Archcraft issues

## 📊 Installation Process

1. **Pre-installation Checks**: Validate environment and requirements
2. **Configuration Loading**: Load and validate all configurations
3. **Package Installation**: Install packages by category with progress
4. **Service Configuration**: Enable and start system services
5. **User Configuration**: Apply user-specific settings
6. **System Fixes**: Apply Archcraft-specific fixes and optimisations
7. **Finalisation**: Update system components and cleanup
8. **Reporting**: Generate installation report and display summary

## 🎯 Key Benefits

- **Maintainability**: Modular design makes updates easy
- **Customisation**: Easy to modify configurations without touching code
- **Reliability**: Comprehensive error handling and validation
- **Documentation**: Self-documenting code with clear structure
- **Reusability**: Library functions can be used independently
- **Scalability**: Easy to add new features and configurations

## 🔧 Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure script is not run as root
2. **Missing Dependencies**: Check pre-installation requirements
3. **Network Issues**: Verify internet connection for package downloads
4. **Configuration Errors**: Validate configuration file syntax

### Debug Mode
Enable debug logging by setting:
```bash
export DEBUG=1
./install_system.sh
```

## 📝 Contributing

To extend the system:
1. Add new configuration files to `config/`
2. Create new library functions in `lib/`
3. Update the orchestrator script to use new functions
4. Document changes in this README

## 🔄 Maintenance

- Regularly update package lists in `config/packages.conf`
- Review and update service configurations
- Test installation script after major system updates
- Update documentation as needed

## 📞 Support

For issues or questions:
1. Check the installation report generated in home directory
2. Review system logs for errors
3. Consult the system audit documentation
4. Test individual library functions for debugging
