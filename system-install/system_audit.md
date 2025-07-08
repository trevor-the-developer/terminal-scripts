# Archcraft System Audit - Trevor's System

**Date:** 2025-07-08  
**Total Packages:** 1,454 (490 explicitly installed)  
**Distribution:** Archcraft  
**Kernel:** Linux 6.15.5.arch1-1  
**Shell:** zsh 5.9  

## Package Categories

### Core System Packages (Base & Development)
- **Base System:** base, base-devel, linux, linux-firmware, grub, systemd
- **Development Tools:** gcc, make, autoconf, automake, bison, flex, fakeroot, patch, pkgconf
- **Compression:** 7zip, bzip2, gzip, lz4, lzip, lzop, xz, zstd, zip, unzip, unrar
- **File Systems:** btrfs-progs, e2fsprogs, exfatprogs, f2fs-tools, jfsutils, ntfs-3g, xfsprogs
- **Hardware Support:** intel-ucode, nvidia (575.64.03-2), nvidia-utils, nvidia-settings, nvidia-prime
- **Firmware:** sof-firmware, linux-firmware-marvell, wireless-regdb, broadcom-wl

### Archcraft-Specific Packages
**Desktop Environment Components:**
- archcraft-bspwm, archcraft-openbox, archcraft-openbox-themes
- archcraft-about, archcraft-help, archcraft-scripts, archcraft-funscripts
- archcraft-sddm-theme, archcraft-plymouth-theme, archcraft-grub-theme

**Themes & Customization:**
- **GTK Themes:** adapta, arc, blade, catppuccin, cyberpunk, dracula, everforest, fluent, gruvbox, hack, kanagawa, material, nordic, orchis, sweet, tokyonight, windows
- **Icon Themes:** arc, beautyline, breeze, candy, colloid, fluent, nordic, numix, papirus, qogir, tela, vimix, win11, zafiro
- **Cursor Themes:** bibata, breezex, colloid, fluent, future, layan, material, nordic, qogir, sweet, vimix, windows

**Fonts & Resources:**
- archcraft-fonts, archcraft-backgrounds, archcraft-artworks, archcraft-dunst-icons

### System Services & Networking
- **Network:** NetworkManager, networkmanager-dmenu-git, wireless_tools, bluez, bluez-utils, blueman
- **VPN:** networkmanager-openvpn, networkmanager-pptp, networkmanager-strongswan, proton-vpn-gtk-app
- **Security:** apparmor, ufw, gufw, polkit, xfce-polkit
- **Power Management:** tlp, tlp-rdw, powertop, acpi, cpupower
- **Audio:** pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse, pavucontrol, pulsemixer, wireplumber

### Desktop Environment & Window Management
- **Window Managers:** bspwm (via archcraft-bspwm), openbox (via archcraft-openbox)
- **Compositors:** picom
- **Bars:** polybar
- **Launchers:** rofi-lbonn-wayland-git, jgmenu
- **Notifications:** dunst
- **Wallpaper:** nitrogen, betterlockscreen
- **Screen Lock:** i3lock-color, betterlockscreen

### Terminal & Shell
- **Terminals:** alacritty, kitty, terminator, xfce4-terminal
- **Shell:** zsh, archcraft-omz (Oh My Zsh)
- **Terminal Tools:** tmux, screen, htop, btop, tree, ncdu, micro, vim, archcraft-vim

### Development Tools
- **Version Control:** git, gitg, gitkraken, meld
- **IDEs/Editors:** visual-studio-code-bin, rider, geany, geany-plugins, pulsar-bin
- **Languages:** nodejs, dotnet-runtime, dotnet-sdk, asdf-vm
- **Databases:** dbeaver
- **API Testing:** postman-bin, insomnia, httpie

### Multimedia & Graphics
- **Image Viewers:** sxiv, shotwell, deepin-image-viewer, viewnior
- **Video:** ffmpeg, mplayer, vlc (likely via deps)
- **Audio:** mpd, mpc, ncmpcpp, calf, lsp-plugins-lv2, mda.lv2, zam-plugins-lv2
- **Graphics:** maim, slop, simplescreenrecorder, xcolor, pastel
- **Document Viewers:** atril, libreoffice-fresh

### File Management & Archives
- **File Managers:** thunar, thunar-archive-plugin, thunar-volman, ranger, archcraft-ranger
- **Archive Tools:** xarchiver, unarchiver, fsarchiver, clonezilla, partclone

### System Monitoring & Utilities
- **System Info:** neofetch (archcraft-neofetch), inxi, lsb-release, dmidecode
- **Monitoring:** iftop, iotop, nethogs, tcpdump, nmap
- **Disk Tools:** gparted, hdparm, smartmontools, ncdu
- **Network Tools:** bind, ndisc6, traceroute, iw, iwd

### Gaming & Entertainment
- **Games:** lutris, steam (likely via deps), wine, wine-gecko, wine-mono, winetricks
- **Containers:** portproton
- **Music:** spotify, archcraft-music
- **Communication:** discord, zapzap

### Web Browsers
- brave-bin, firefox, google-chrome

### System Maintenance
- **Package Management:** yay, downgrade, reflector
- **Backup:** timeshift, rsync, trash-cli
- **Cleaning:** archcraft-hooks, archcraft-hooks-extra, archcraft-hooks-grub

## AUR Packages (16 total)
- asdf-vm, brave-bin, gitkraken, google-chrome, insomnia, portproton
- postman-bin, pulsar-bin, rider, spotify, visual-studio-code-bin, zapzap
- yay-debug, asdf-vm-debug, insomnia-debug, pulsar-bin-debug

## Enabled System Services
- **Display:** sddm-plymouth.service
- **Network:** NetworkManager.service, systemd-resolved.service, wpa_supplicant.service
- **Security:** apparmor.service, ufw.service
- **Hardware:** bluetooth.service, ModemManager.service
- **Printing:** cups.service
- **Containerization:** docker.service
- **Power:** tlp.service
- **System:** systemd-timesyncd.service, getty@.service
- **Cloud:** cloud-init services (for VM compatibility)

## Custom Repositories
- **archcraft:** Archcraft-specific packages
- **warpdotdev:** Warp terminal repository
- **core, extra, multilib:** Standard Arch repositories

## Hardware-Specific Notes
- **Graphics:** NVIDIA drivers (575.64.03-2) with Intel integrated graphics fallback
- **Audio:** PipeWire-based audio stack
- **Network:** NetworkManager with various VPN plugin support
- **Bluetooth:** Full Bluetooth stack with GUI management
- **Printing:** CUPS with various driver support

## System Configuration Highlights
- **Desktop:** BSPWM/Openbox window managers with extensive theming
- **Security:** AppArmor, UFW firewall, Polkit authentication
- **Development:** Full .NET and Node.js development environment
- **Virtualization:** Docker with NVIDIA container support
- **Power Management:** TLP for laptop power optimization
- **Boot:** Plymouth splash screen with custom theme

## Recent Issues Resolved (2025-07-08)

### Issue 1: PGP Key Verification Failure
**Problem:** warpdotdev repository signature verification failed
**Solution:** 
```bash
sudo pacman-key --recv-keys 19A1E427461B1795F73F629631F4254AFE49E02E
sudo pacman-key --lsign-key 19A1E427461B1795F73F629631F4254AFE49E02E
```

### Issue 2: Super Key Menu Not Working
**Problem:** Super key (Windows key) not opening application menu
**Root Cause:** 
1. Missing xcb-imdkit library dependency for rofi
2. No Super key binding in Openbox configuration

**Solution:**
```bash
# Install missing dependency
sudo pacman -S xcb-imdkit

# Added Super key binding to ~/.config/openbox/rc.xml:
<keybind key="Super_L">
  <action name="Execute">
    <command>rofi-launcher</command>
  </action>
</keybind>

# Install additional menu launcher
sudo pacman -S jgmenu
```

### Issue 3: Screen Lock Not Accessible
**Problem:** Unable to lock workstation from menu
**Solution:** 
- Confirmed betterlockscreen working: `betterlockscreen --lock`
- Existing keybind: Ctrl+Alt+L

### Issue 4: Super+Arrow Keys Not Working
**Problem:** Super+arrow key combinations for window management not working
**Root Cause:** `ksuperkey` processes intercepting Super key presses and converting them to Alt+F1

**Solution:**
```bash
# Kill running ksuperkey processes
killall ksuperkey

# Disable ksuperkey in ~/.config/openbox/autostart
# Comment out these lines:
#ksuperkey -e 'Super_L=Alt_L|F1' &
#ksuperkey -e 'Super_R=Alt_L|F1' &
```

**About ksuperkey:**
- Purpose: Converts Super key to Alt+F1 for menu access
- Conflict: Interferes with Super+arrow window management
- Solution: Disabled to restore normal Super key functionality

### Current Working Keybinds:
- **Super+Space:** Application menu (rofi-launcher)
- **Alt+F1:** Alternative menu access
- **Ctrl+Alt+L:** Lock screen (betterlockscreen)
- **Super+Arrow Keys:** Window management (snap, maximize, center)
  - Super+Left/Right: Snap to screen halves
  - Super+Up: Maximize window
  - Super+Down: Center window (60% width, 80% height)

## System Configuration Snapshot

This section documents the complete system configuration for replication purposes.

### **Shell Configuration**
- **Shell:** zsh with Oh My Zsh
- **Theme:** archcraft
- **Plugins:** git
- **Key Aliases:**
  - `zshconfig="geany ~/.zshrc"`
  - `ohmyzsh="thunar ~/.oh-my-zsh"`
  - `l='ls -lh'`, `ll='ls -lah'`, `la='ls -A'`
  - `gcl='git clone --depth 1'`, `gi='git init'`, `ga='git add'`, `gc='git commit -m'`
- **Environment Variables:**
  - `NVIDIA_VISIBLE_DEVICES=all`
  - `DOTNET_ROOT=$HOME/.dotnet`
  - `BROWSER=google-chrome`
  - `PATH` includes: `$HOME/.asdf/shims`, `$HOME/.dotnet/tools`

### **Openbox Window Manager**
- **Current Theme:** default
- **Panel:** Polybar
- **Compositor:** picom
- **Notification System:** dunst
- **Key Modifications:**
  - Disabled ksuperkey to prevent Super key conflicts
  - Modified W-space to launch rofi-launcher
  - Super+Arrow keys for window management

### **System Services (Enabled)**
- **User Services:** wireplumber, xdg-user-dirs-update, pipewire-pulse
- **System Services:** apparmor, avahi-daemon, bluetooth, cups, docker, NetworkManager, systemd-resolved, systemd-timesyncd, tlp, ufw
- **Display Manager:** sddm-plymouth

### **Development Environment**
- **Git Configuration:**
  - User: Trevor
  - Email: trevordeveloper28@gmail.com
- **Runtime Managers:** asdf-vm for Node.js
- **Development Tools:** .NET SDK, Node.js, Docker
- **IDEs:** VS Code, Rider, Geany

### **Security Configuration**
- **Firewall:** UFW enabled with rate limiting
- **AppArmor:** Enabled for additional security
- **Polkit:** xfce-polkit for authentication

### **Hardware Configuration**
- **Graphics:** NVIDIA drivers with Intel fallback
- **Audio:** PipeWire-based stack
- **Power Management:** TLP for laptops
- **Bluetooth:** Full stack with blueman GUI

### **X11 Configuration Files**
- **Keyboard:** `/etc/X11/xorg.conf.d/00-keyboard.conf`
- **Touchpad:** `/etc/X11/xorg.conf.d/02-touchpad-ttc.conf`
- **Screen Layout:** Custom multi-monitor setup with rotation

### **Theme and Appearance**
- **GTK Themes:** Multiple Archcraft themes available
- **Icon Themes:** Various icon sets (arc, papirus, etc.)
- **Cursor Themes:** Multiple cursor options
- **Wallpaper Manager:** nitrogen
- **Lock Screen:** betterlockscreen

### **Custom Scripts and Automation**
- **Redshift:** Custom red light filter script
- **Openbox Autostart:** Customized startup sequence
- **Theme Switching:** Automated theme management
- **Bar Management:** Polybar/Tint2 switching system

## System Installation Suite

This system now includes a comprehensive, modular installation suite located in `~/Support/system-install/`.

### **Directory Structure**
```
system-install/
├── README.md                    # Complete documentation
├── system_audit.md             # This file
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
    ├── fixes.sh                # System fixes and optimizations
    └── finalize.sh             # Finalization and cleanup
```

### **Installation Suite Features**
- **Modular Architecture:** Separate libraries for different functions
- **Configuration Management:** Centralized config files for easy customization
- **Comprehensive Logging:** Colored output and progress tracking
- **Error Handling:** Robust error checking and recovery
- **Automated Reporting:** Installation reports and system information
- **Archcraft Integration:** Specific fixes for known Archcraft issues

### **Usage**
```bash
cd ~/Support/system-install
./install_system.sh
```

### **Key Components**
- **Orchestrator Script:** `install_system.sh` - Main coordination script
- **Package Configuration:** `config/packages.conf` - Organized package groups
- **Service Configuration:** `config/services.conf` - System service definitions
- **User Configurations:** Template files for shell, git, and desktop setup
- **Function Libraries:** Modular bash libraries for specific tasks

### **Replication Process**
1. **Pre-installation Checks:** Validate environment and requirements
2. **Configuration Loading:** Load and validate all configurations
3. **Package Installation:** Install packages by category with progress
4. **Service Configuration:** Enable and start system services
5. **User Configuration:** Apply user-specific settings
6. **System Fixes:** Apply Archcraft-specific fixes and optimizations
7. **Finalization:** Update system components and cleanup
8. **Reporting:** Generate installation report and display summary
