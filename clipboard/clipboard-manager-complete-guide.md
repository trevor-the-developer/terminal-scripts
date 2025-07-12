# Complete Clipboard Manager Setup for Archcraft Linux (Openbox + Polybar)

## Overview
A complete guide to set up a custom clipboard manager that integrates seamlessly with Archcraft Linux using Openbox window manager and Polybar. This provides functionality similar to CopyQ but perfectly integrated with your existing setup.

## Features
- **Clipboard History**: Stores up to 50 clipboard entries
- **Polybar Integration**: Shows clipboard count in your taskbar
- **Rofi Interface**: Beautiful menu for selecting clipboard items
- **Keyboard Shortcut**: Quick access with `Super+V`
- **Mouse Control**: Click Polybar module to open, right-click to clear
- **Auto-start**: Automatically starts with your desktop session
- **Cross-application**: Works with terminals, GUI apps, browsers, etc.

## Prerequisites
- Archcraft Linux with Openbox and Polybar
- `xclip` and `rofi` installed (usually pre-installed on Archcraft)

## Complete Installation Guide

### 1. Install Required Dependencies (if not already installed)
```bash
# Check if tools are available
which xclip rofi

# Install if missing (usually pre-installed on Archcraft)
yay -S xclip rofi
```

### 2. Create the Clipboard Manager Script

Create the main script file:
```bash
# Create the script file
touch ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh
chmod +x ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh
```

Copy the following script content into `~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh`:

```bash
#!/bin/bash

# Clipboard Manager for Polybar
# Monitors clipboard and maintains history

CLIPBOARD_DIR="$HOME/.local/share/clipboard"
CLIPBOARD_HISTORY="$CLIPBOARD_DIR/history"
MAX_ENTRIES=50
ENTRY_MAX_LENGTH=100

# Create clipboard directory if it doesn't exist
mkdir -p "$CLIPBOARD_DIR"

# Function to add entry to clipboard history
add_to_history() {
    local content="$1"
    
    # Skip if content is empty or too short
    if [[ -z "$content" || ${#content} -lt 2 ]]; then
        return
    fi
    
    # Truncate long entries for display
    local display_content
    if [[ ${#content} -gt $ENTRY_MAX_LENGTH ]]; then
        display_content="${content:0:$ENTRY_MAX_LENGTH}..."
    else
        display_content="$content"
    fi
    
    # Remove existing entry if it exists (to avoid duplicates)
    if [[ -f "$CLIPBOARD_HISTORY" ]]; then
        grep -Fxv "$display_content" "$CLIPBOARD_HISTORY" > "${CLIPBOARD_HISTORY}.tmp" || true
        mv "${CLIPBOARD_HISTORY}.tmp" "$CLIPBOARD_HISTORY"
    fi
    
    # Add new entry at the top
    echo "$display_content" > "${CLIPBOARD_HISTORY}.tmp"
    if [[ -f "$CLIPBOARD_HISTORY" ]]; then
        cat "$CLIPBOARD_HISTORY" >> "${CLIPBOARD_HISTORY}.tmp"
    fi
    mv "${CLIPBOARD_HISTORY}.tmp" "$CLIPBOARD_HISTORY"
    
    # Keep only MAX_ENTRIES
    if [[ -f "$CLIPBOARD_HISTORY" ]]; then
        head -n $MAX_ENTRIES "$CLIPBOARD_HISTORY" > "${CLIPBOARD_HISTORY}.tmp"
        mv "${CLIPBOARD_HISTORY}.tmp" "$CLIPBOARD_HISTORY"
    fi
}

# Function to monitor clipboard
monitor_clipboard() {
    local previous_content=""
    
    while true; do
        # Get current clipboard content
        current_content=$(xclip -o -selection clipboard 2>/dev/null || echo "")
        
        # Check if content changed
        if [[ "$current_content" != "$previous_content" && -n "$current_content" ]]; then
            add_to_history "$current_content"
            previous_content="$current_content"
        fi
        
        sleep 1
    done
}

# Function to show clipboard menu
show_menu() {
    if [[ ! -f "$CLIPBOARD_HISTORY" ]]; then
        echo "No clipboard history"
        return
    fi
    
    # Show rofi menu with clipboard history
    local selected_entry
    selected_entry=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -i -p "Clipboard History")
    
    if [[ -n "$selected_entry" ]]; then
        # Remove the "..." if it was truncated
        if [[ "$selected_entry" == *"..." ]]; then
            # Need to find the full content from history
            local full_content
            full_content=$(grep -A1 -B1 "^${selected_entry%...}" "$CLIPBOARD_HISTORY" | head -1)
            echo "$full_content" | xclip -selection clipboard
        else
            echo "$selected_entry" | xclip -selection clipboard
        fi
    fi
}

# Function to clear clipboard history
clear_history() {
    rm -f "$CLIPBOARD_HISTORY"
    echo "Clipboard history cleared"
}

# Function to get clipboard status for polybar
get_status() {
    if [[ -f "$CLIPBOARD_HISTORY" ]]; then
        local count=$(wc -l < "$CLIPBOARD_HISTORY")
        if [[ $count -gt 0 ]]; then
            echo "📋 $count"
        else
            echo "📋 0"
        fi
    else
        echo "📋 0"
    fi
}

# Handle command line arguments
case "$1" in
    "monitor")
        monitor_clipboard
        ;;
    "show")
        show_menu
        ;;
    "clear")
        clear_history
        ;;
    "status")
        get_status
        ;;
    *)
        echo "Usage: $0 {monitor|show|clear|status}"
        echo "  monitor - Start clipboard monitoring daemon"
        echo "  show    - Show clipboard history menu"
        echo "  clear   - Clear clipboard history"
        echo "  status  - Show clipboard status for polybar"
        ;;
esac
```

### 3. Add Polybar Module

Edit `~/.config/openbox/themes/default/polybar/modules.ini` and add the clipboard module (add this before the last comment section):

```ini
[module/clipboard]
type = custom/script
exec = ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh status
interval = 5
format = <label>
format-background = ${color.BACKGROUND}
format-padding = 1
label = %output%
click-left = ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh show &
click-right = ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh clear &
```

### 4. Add Module to Polybar Configuration

Edit `~/.config/openbox/themes/default/polybar/config.ini` and find the `modules-right` line:

**Before:**
```ini
modules-right = volume dot backlight dot bluetooth dot network dot LD battery RD dot LD sysmenu RD dot-alt LD tray RD
```

**After:**
```ini
modules-right = volume dot backlight dot bluetooth dot network dot clipboard dot LD battery RD dot LD sysmenu RD dot-alt LD tray RD
```

### 5. Add Keyboard Shortcut

Edit `~/.config/openbox/rc.xml` and find the section with other keybindings (around the Rofi section). Add:

```xml
    <!-- Clipboard Manager -->
    <keybind key="W-v">
      <action name="Execute">
        <command>~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh show</command>
      </action>
    </keybind>
```

### 6. Auto-start Configuration

Edit `~/.config/openbox/autostart` and add at the end:

```bash
## Start Clipboard Manager
killall -9 clipboard-manager.sh 2>/dev/null || true
nohup ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor > /dev/null 2>&1 &
```

### 7. Optional: Create Systemd User Service

Create `~/.config/systemd/user/clipboard-manager.service`:

```ini
[Unit]
Description=Clipboard Manager
After=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor
Restart=always
RestartSec=1
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
```

Enable the service:
```bash
systemctl --user enable clipboard-manager.service
```

### 8. Apply Changes

Restart Openbox and Polybar:
```bash
# Reload Openbox configuration
openbox --reconfigure

# Restart Polybar (using Archcraft's script)
bash ~/.config/openbox/themes/launch-bar.sh
```

## Usage Guide

### Keyboard Shortcuts
- **Super+V**: Open clipboard history menu
- **Arrow Keys**: Navigate through history
- **Enter**: Select and copy item to clipboard
- **Escape**: Close menu

### Polybar Module
- **Left Click**: Open clipboard history menu
- **Right Click**: Clear clipboard history
- **Display**: Shows 📋 icon with number of stored items

### Command Line Usage
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

## Configuration Options

### Script Settings
Edit the script to modify these variables:
- **MAX_ENTRIES**: 50 (maximum clipboard items to store)
- **ENTRY_MAX_LENGTH**: 100 (truncate long entries for display)
- **Update Interval**: 1 second (clipboard monitoring frequency)
- **Polybar Update**: 5 seconds (how often Polybar updates the count)

### Storage Location
Clipboard history is stored in: `~/.local/share/clipboard/history`

### Customizing Keyboard Shortcut
Change `W-v` in the rc.xml to your preferred combination:
- `W` = Super/Windows key
- `A` = Alt key  
- `C` = Ctrl key
- `S` = Shift key

## How It Works

1. **Monitor**: Background process monitors clipboard changes every second
2. **Store**: New clipboard content is added to history file (avoiding duplicates)
3. **Display**: Polybar shows current count of stored items with 📋 icon
4. **Access**: Rofi menu provides searchable interface for selecting items
5. **Paste**: Selected item is copied back to clipboard for pasting

## Troubleshooting

### Clipboard manager not starting
```bash
# Check if process is running
ps aux | grep clipboard-manager

# Check logs
journalctl --user -u clipboard-manager.service

# Manually start
nohup ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh monitor > /dev/null 2>&1 &
```

### Polybar not showing clipboard module
- Restart Polybar: `bash ~/.config/openbox/themes/launch-bar.sh`
- Check module is added to `modules-right` in config.ini
- Verify script permissions: `ls -la ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh`

### Rofi menu not appearing
```bash
# Test rofi directly
echo -e "test1\ntest2\ntest3" | rofi -dmenu

# If you get theme errors, check if theme file exists
ls ~/.config/rofi/themes/default.rasi
```

### Rofi theme errors ("failed to open theme" error)
If you get an error like `failed to open theme: ~/.config/rofi/themes/default.rasi no such file or directory`:

**Solution**: The script has been updated to use rofi's default theme instead of a custom theme.

1. **Verify the fix is applied**: Check that line 119 in the script looks like:
   ```bash
   selected_entry=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -i -p "Clipboard History")
   ```
   
2. **If the old version is still present**, update it:
   ```bash
   # Edit the script
   nano ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh
   
   # Change line 119 from:
   # selected_entry=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -i -p "Clipboard History" -theme ~/.config/rofi/themes/default.rasi)
   # To:
   # selected_entry=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -i -p "Clipboard History")
   ```

3. **Test the fix**:
   ```bash
   ~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh show
   ```

### Keyboard shortcut not working
```bash
# Reload Openbox configuration
openbox --reconfigure

# Or restart session with Ctrl+Shift+R
```

### Backlight/Brightness Errors in Multi-Monitor Setup
If you're using multiple monitors and seeing errors like:
```
error: module/backlight: Could not get data (err: XCB_NAME (15))
error: Disabling module "backlight" (reason: Not supported for "DP3-1")
error: Disabling module "backlight" (reason: Not supported for "DP3-2-1")
```

This happens because Polybar launches on all monitors, but external monitors don't support software brightness control.

**Solution 1: Restrict backlight to laptop screen only**
Edit `~/.config/openbox/themes/default/polybar/modules.ini` and add `output = eDP1` to your backlight modules:

```ini
[module/backlight]
type = internal/xbacklight
card = intel_backlight
output = eDP1  ; Only show on laptop screen (eDP1)
; ... rest of configuration

[module/brightness]
type = internal/backlight
card = ${system.sys_graphics_card}
output = eDP1  ; Only show on laptop screen (eDP1)
; ... rest of configuration
```

**Solution 2: Use custom brightness script** (Alternative approach)
Create a custom brightness control script:

```bash
# Create the script
cat > ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh << 'EOF'
#!/bin/bash

# Custom brightness control script for Polybar
# Works only on laptop screen, avoids external monitor errors

BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"

# Function to get brightness percentage
get_brightness() {
    if [[ -f "$BACKLIGHT_PATH/brightness" && -f "$BACKLIGHT_PATH/max_brightness" ]]; then
        local current=$(cat "$BACKLIGHT_PATH/brightness")
        local max=$(cat "$BACKLIGHT_PATH/max_brightness")
        local percentage=$((current * 100 / max))
        echo "☀ ${percentage}%"
    else
        echo "☀ N/A"
    fi
}

# Function to set brightness
set_brightness() {
    local action="$1"
    case "$action" in
        "up")
            light -A 5
            ;;
        "down")
            light -U 5
            ;;
        *)
            echo "Usage: $0 set {up|down}"
            ;;
    esac
}

# Handle command line arguments
case "$1" in
    "get")
        get_brightness
        ;;
    "set")
        set_brightness "$2"
        ;;
    *)
        echo "Usage: $0 {get|set} [up|down]"
        ;;
esac
EOF

# Make it executable
chmod +x ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh
```

Then replace your backlight module with:
```ini
[module/brightness-custom]
type = custom/script
exec = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh get
interval = 5
format = <label>
format-background = ${color.BACKGROUND}
format-padding = 1
label = %output%
click-left = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set up
click-right = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set down
scroll-up = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set up
scroll-down = ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh set down
```

**Solution 3: Clean restart after changes**
After making changes, clean restart the module detection:
```bash
# Remove the module detection cache
rm -f ~/.config/openbox/themes/default/polybar/.module

# Restart Polybar
bash ~/.config/openbox/themes/launch-bar.sh
```

## Advanced Customization

### Change Polybar Position
Modify the `modules-right` line in config.ini to move clipboard module:
```ini
# Move to left side
modules-left = LD menu RD dot-alt LD openbox RD dot cpu dot memory dot filesystem dot clipboard

# Move to center
modules-center = LD date RD dot-alt LD spotify RD sep spotify-song dot clipboard
```

### Custom Rofi Theme
Create or modify `~/.config/rofi/themes/clipboard.rasi` and update the script to use it:
```bash
selected_entry=$(cat "$CLIPBOARD_HISTORY" | rofi -dmenu -i -p "Clipboard History" -theme ~/.config/rofi/themes/clipboard.rasi)
```

### Integration with Other Tools
The clipboard manager can be integrated with:
- **Dunst notifications**: Add notification when items are copied
- **Custom scripts**: Trigger actions when certain content is copied
- **Backup**: Sync clipboard history across machines

## Comparison with CopyQ

This clipboard manager provides similar functionality to CopyQ:
- ✅ Clipboard history storage (50 items vs CopyQ's unlimited)
- ✅ Quick access menu with search/filter capability
- ✅ Keyboard shortcuts for quick access
- ✅ System tray/taskbar integration
- ✅ Persistent storage across sessions
- ✅ Works with all applications (terminal, GUI, browser)
- ✅ Lightweight and fast
- ✅ Native integration with Archcraft/Openbox/Polybar

## Credits

This clipboard manager was created specifically for Archcraft Linux users who want CopyQ-like functionality with perfect integration into their existing Openbox + Polybar setup.

---

**Enjoy your new clipboard manager! 📋**

*Feel free to share this guide with other Archcraft users or adapt it for other Linux distributions using Openbox and Polybar.*
