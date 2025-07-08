#!/bin/bash

# Archcraft System Automated Install Script

# Update system and install base packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base base-devel linux linux-firmware grub systemd

# Install development tools
sudo pacman -S --noconfirm gcc make autoconf automake bison flex fakeroot patch pkgconf

# Install essential system management utilities
sudo pacman -S --noconfirm 7zip bzip2 gzip lz4 lzip lzop xz zstd zip unzip unrar
sudo pacman -S --noconfirm btrfs-progs e2fsprogs exfatprogs f2fs-tools jfsutils ntfs-3g xfsprogs

# Graphics and firmware
sudo pacman -S --noconfirm intel-ucode nvidia nvidia-utils nvidia-settings nvidia-prime
sudo pacman -S --noconfirm sof-firmware linux-firmware-marvell wireless-regdb broadcom-wl

# Archcraft-specific setup
sudo pacman -S --noconfirm archcraft-bspwm archcraft-openbox archcraft-openbox-themes
sudo pacman -S --noconfirm archcraft-about archcraft-help archcraft-scripts archcraft-funscripts
sudo pacman -S --noconfirm archcraft-sddm-theme archcraft-plymouth-theme archcraft-grub-theme

# Install themes and customization
sudo pacman -S --noconfirm archcraft-gtk-theme-adapta archcraft-gtk-theme-arc archcraft-gtk-theme-blade
sudo pacman -S --noconfirm archcraft-gtk-theme-catppuccin archcraft-gtk-theme-cyberpunk archcraft-gtk-theme-dracula
sudo pacman -S --noconfirm archcraft-gtk-theme-everforest archcraft-gtk-theme-fluent archcraft-gtk-theme-gruvbox
sudo pacman -S --noconfirm archcraft-gtk-theme-hack archcraft-gtk-theme-kanagawa archcraft-gtk-theme-material
sudo pacman -S --noconfirm archcraft-gtk-theme-nordic archcraft-gtk-theme-orchis archcraft-gtk-theme-sweet
sudo pacman -S --noconfirm archcraft-gtk-theme-tokyonight archcraft-gtk-theme-windows

# Install fonts and resources
sudo pacman -S --noconfirm archcraft-fonts archcraft-backgrounds archcraft-artworks archcraft-dunst-icons

# System services & networking
sudo pacman -S --noconfirm NetworkManager networkmanager-dmenu-git wireless_tools bluez bluez-utils blueman
sudo pacman -S --noconfirm networkmanager-openvpn networkmanager-pptp networkmanager-strongswan proton-vpn-gtk-app
sudo pacman -S --noconfirm apparmor ufw gufw polkit xfce-polkit
sudo pacman -S --noconfirm tlp tlp-rdw powertop acpi cpupower
sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-jack pipewire-pulse pavucontrol pulsemixer wireplumber

# Desktop environment setup
sudo pacman -S --noconfirm bspwm openbox picom polybar rofi-lbonn-wayland-git
sudo pacman -S --noconfirm dunst nitrogen betterlockscreen i3lock-color

# Install menu launchers and dependencies
sudo pacman -S --noconfirm jgmenu xcb-imdkit

# Terminals and shell
sudo pacman -S --noconfirm alacritty kitty terminator xfce4-terminal
sudo pacman -S --noconfirm zsh archcraft-omz tmux screen htop btop tree ncdu micro vim archcraft-vim

# Development tools
sudo pacman -S --noconfirm git gitg gitkraken meld visual-studio-code-bin rider geany geany-plugins pulsar-bin
sudo pacman -S --noconfirm nodejs dotnet-runtime dotnet-sdk asdf-vm dbeaver postman-bin insomnia httpie

# Multimedia, Graphics, and Document viewers
sudo pacman -S --noconfirm sxiv shotwell deepin-image-viewer viewnior ffmpeg mplayer vlc
sudo pacman -S --noconfirm mpd mpc ncmpcpp calf lsp-plugins-lv2 mda.lv2 zam-plugins-lv2 maim slop simplescreenrecorder xcolor pastel
sudo pacman -S --noconfirm atril libreoffice-fresh

# File management
sudo pacman -S --noconfirm thunar thunar-archive-plugin thunar-volman ranger archcraft-ranger
sudo pacman -S --noconfirm xarchiver unarchiver fsarchiver clonezilla partclone

# System monitoring and utilities
sudo pacman -S --noconfirm neofetch inxi lsb-release dmidecode iotop iftop nethogs tcpdump nmap gparted hdparm smartmontools

# Gaming and entertainment
sudo pacman -S --noconfirm lutris wine winetricks spotify archcraft-music discord zapzap

# Web browsers
sudo pacman -S --noconfirm brave-bin firefox google-chrome

# System maintenance
sudo pacman -S --noconfirm yay downgrade reflector timeshift rsync trash-cli

# Additional AUR packages
yay -S --noconfirm portproton

# Enable necessary services
sudo systemctl enable --now NetworkManager avahi-daemon bluetooth apparmor ufw docker tlp cups
sudo systemctl enable --now sddm-plymouth wpa_supplicant systemd-resolved

# Finalize setup
sudo reflector --country 'United States' --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Fix common Archcraft issues
echo "Applying common Archcraft fixes..."

# Import and trust warpdotdev PGP key if needed
sudo pacman-key --recv-keys 19A1E427461B1795F73F629631F4254AFE49E02E
sudo pacman-key --lsign-key 19A1E427461B1795F73F629631F4254AFE49E02E

# Update icon caches to prevent warnings
echo "Updating icon caches..."
sudo gtk-update-icon-cache -f /usr/share/icons/hicolor/
gtk-update-icon-cache -f ~/.local/share/icons/ 2>/dev/null || true
gtk-update-icon-cache -f ~/.icons/ 2>/dev/null || true

# Initialize jgmenu cache
echo "Initializing jgmenu..."
jgmenu_run init --icon-size=22 >/dev/null 2>&1 || true

# Ensure openbox configuration includes Super key binding
echo "Checking Openbox Super key configuration..."
if ! grep -q 'key="Super_L"' ~/.config/openbox/rc.xml 2>/dev/null; then
    echo "Note: Manual addition of Super key binding to ~/.config/openbox/rc.xml may be needed"
    echo "Add the following keybind section:"
    echo '<keybind key="Super_L">'
    echo '  <action name="Execute">'
    echo '    <command>rofi-launcher</command>'
    echo '  </action>'
    echo '</keybind>'
fi

# Notify completion
echo "System setup complete! Please verify everything and reboot if necessary."
echo "Key shortcuts:"
echo "  Super key or Alt+F1: Application menu"
echo "  Ctrl+Alt+L: Lock screen"
