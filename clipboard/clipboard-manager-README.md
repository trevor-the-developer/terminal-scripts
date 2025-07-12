# Clipboard Manager for Archcraft/Openbox + Polybar

## Overview
A custom clipboard manager that integrates seamlessly with your Archcraft Openbox setup and Polybar.

## Features
- **Clipboard History**: Stores up to 50 clipboard entries
- **Polybar Integration**: Shows clipboard count in your taskbar
- **Rofi Interface**: Beautiful menu for selecting clipboard items
- **Keyboard Shortcut**: Quick access with `Super+V`
- **Mouse Control**: Click Polybar module to open, right-click to clear
- **Auto-start**: Automatically starts with your desktop session

## Setup and Installation

1. **Install Required Tools**
   - Ensure you have `xclip` and `rofi` installed.
   - If not, install them using your package manager (e.g., `yay -S xclip rofi`).

2. **Set Up Clipboard Manager Script**
   - Save the script `clipboard-manager.sh` in `~/.config/openbox/themes/default/polybar/scripts/`

3. **Make Script Executable**
   - Run `chmod +x ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh`

4. **Systemd User Service**
   - Create a service file at `~/.config/systemd/user/clipboard-manager.service`
   - Add the following content:
     ```ini
     [Unit]
     Description=Clipboard Manager
     After=graphical-session.target

     [Service]
     Type=simple
     ExecStart=/home/trevor/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor
     Restart=always
     RestartSec=1
     Environment=DISPLAY=:0

     [Install]
     WantedBy=default.target
     ```

5. **Polybar Configuration**
   - Add the 'clipboard' module in `~/.config/openbox/themes/default/polybar/modules.ini`
   - Add `clipboard` to the `modules-right` section in `~/.config/openbox/themes/default/polybar/config.ini`

6. **Openbox Autostart**
   - Ensure the clipboard monitor starts at launch
   - Add the following to your autostart file:
     ```bash
     ## Start Clipboard Manager
     killall -9 clipboard-manager.sh 2>/dev/null || true
     nohup ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor > /dev/null 2>&1 &
     ```

7. **Add Keyboard Shortcut**
   - Open `~/.config/openbox/rc.xml`
   - Insert the following lines where other keybindings are defined:
     ```xml
     <!-- Clipboard Manager -->
     <keybind key="W-v">
       <action name="Execute">
         <command>~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh show</command>
       </action>
     </keybind>
     ```

8. **Restart Openbox and Polybar**
   - Reload Openbox: `openbox --reconfigure`
   - Restart Polybar using your launch script.


## Usage

### Keyboard Shortcuts
- **Super+V**: Open clipboard history menu
- Use arrow keys to navigate, Enter to select

### Polybar Module
- **Left Click**: Open clipboard history menu
- **Right Click**: Clear clipboard history
- **Display**: Shows 📋 icon with number of stored items

### Command Line
```bash
# Show clipboard history menu
~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh show

# Check status (used by Polybar)
~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh status

# Clear history
~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh clear

# Start monitoring (auto-started with session)
~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor
```

## Configuration

### Settings in the script:
- **MAX_ENTRIES**: 50 (maximum clipboard items to store)
- **ENTRY_MAX_LENGTH**: 100 (truncate long entries for display)
- **Update Interval**: 1 second (clipboard monitoring frequency)
- **Polybar Update**: 5 seconds (how often Polybar updates the count)

### Storage Location
Clipboard history is stored in: `~/.local/share/clipboard/history`

## How It Works

1. **Monitor**: Background process monitors clipboard changes
2. **Store**: New clipboard content is added to history file
3. **Display**: Polybar shows current count of stored items
4. **Access**: Rofi menu provides easy selection interface
5. **Paste**: Selected item is copied back to clipboard

## Troubleshooting

### Clipboard manager not starting automatically
```bash
# Check if the process is running
ps aux | grep clipboard-manager

# Manually start if needed
nohup ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor > /dev/null 2>&1 &
```

### Polybar not showing clipboard module
- Make sure Polybar has been restarted after configuration changes
- Check that the module is added to the modules-right in config.ini

### Rofi menu not appearing
- Ensure rofi is installed: `which rofi`
- Test rofi directly: `echo -e "test1\ntest2\ntest3" | rofi -dmenu`
- If you get theme errors, the script uses rofi's default theme (no custom theme required)

### Keyboard shortcut not working
- Restart Openbox: `Ctrl+Shift+R`
- Or reconfigure: `openbox --reconfigure`

### Backlight/Brightness Errors in Multi-Monitor Setup
If you're seeing errors like:
```
error: module/backlight: Could not get data (err: XCB_NAME (15))
error: Disabling module "backlight" (reason: Not supported for "DP3-1")
```

This happens because Polybar tries to control backlight on external monitors, which don't support software brightness control.

**Solution 1: Restrict backlight to laptop screen only**
Add `output = eDP1` to your backlight module in `modules.ini`:
```ini
[module/backlight]
type = internal/xbacklight
card = intel_backlight
output = eDP1  ; Only show on laptop screen
```

**Solution 2: Use custom brightness script**
Create a custom brightness control script that only works with the laptop screen:
```bash
# Create the script
touch ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh
chmod +x ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh
```

Then replace the backlight module with a custom script module:
```ini
[module/brightness-custom]
type = custom/script
exec = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh get
interval = 5
click-left = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set up
click-right = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set down
scroll-up = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set up
scroll-down = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set down
```

## Customization

### Change Keyboard Shortcut
Edit `~/.config/openbox/rc.xml` and find the clipboard keybind:
```xml
<keybind key="W-v">
```
Change "W-v" to your preferred combination (W=Super, A=Alt, C=Ctrl, S=Shift)

### Change Polybar Position
Edit `~/.config/openbox/themes/default/polybar/config.ini` and modify the modules-right line to move the clipboard module to a different position.

### Change Maximum Entries
Edit the script and modify the MAX_ENTRIES variable at the top.

## Similar to CopyQ
This clipboard manager provides similar functionality to CopyQ:
- ✅ Clipboard history storage
- ✅ Quick access menu
- ✅ Keyboard shortcuts
- ✅ Integration with system taskbar
- ✅ Search/filter in menu (via rofi)
- ✅ Persistent storage across sessions

Enjoy your new clipboard manager! 📋
