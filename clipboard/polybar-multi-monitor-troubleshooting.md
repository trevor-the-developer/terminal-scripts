# Polybar Multi-Monitor Troubleshooting Guide

## Overview
This guide covers common issues when using Polybar with multiple monitors, especially external displays connected to laptops.

## Common Multi-Monitor Issues

### 1. Backlight/Brightness Control Errors

**Problem:**
```
error: module/backlight: Could not get data (err: XCB_NAME (15))
error: Disabling module "backlight" (reason: Not supported for "DP3-1")
error: Disabling module "backlight" (reason: Not supported for "DP3-2-1")
```

**Cause:**
Polybar launches on all connected monitors, but external monitors don't support software brightness control through X11/XCB.

**Solutions:**

#### Solution 1: Restrict Modules to Specific Outputs
Add `output = eDP1` (or your laptop screen identifier) to brightness-related modules:

```ini
[module/backlight]
type = internal/xbacklight
card = intel_backlight
output = eDP1  ; Only show on laptop screen
; ... rest of configuration

[module/brightness]
type = internal/backlight
card = ${system.sys_graphics_card}
output = eDP1  ; Only show on laptop screen
; ... rest of configuration
```

#### Solution 2: Use Custom Script Module
Replace the internal backlight module with a custom script:

```bash
# Create brightness control script
cat > ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh << 'EOF'
#!/bin/bash

BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"

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

set_brightness() {
    case "$1" in
        "up") light -A 5 ;;
        "down") light -U 5 ;;
    esac
}

case "$1" in
    "get") get_brightness ;;
    "set") set_brightness "$2" ;;
    *) echo "Usage: $0 {get|set} [up|down]" ;;
esac
EOF

chmod +x ~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh
```

Then use this module configuration:
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

#### Solution 3: Monitor-Specific Configurations
Create different configurations for different monitors:

```bash
# Check your monitor setup
xrandr --listmonitors

# Example output:
# Monitors: 3
#  0: +eDP1 1920/340x1200/210+0+1920  eDP1
#  1: +DP3-1 1080/350x1920/190+1698+0  DP3-1
#  2: +DP3-2-1 1920/520x1080/290+2778+1129  DP3-2-1
```

### 2. Battery Module on External Monitors

**Problem:**
Battery module showing on external monitors where it's not relevant.

**Solution:**
Restrict battery module to laptop screen:
```ini
[module/battery]
type = internal/battery
output = eDP1  ; Only show on laptop screen
; ... rest of configuration
```

### 3. Different Modules for Different Monitors

**Problem:**
You want different modules on different monitors.

**Solution:**
Create monitor-specific configurations:

```bash
# Create monitor-specific config files
cp ~/.config/openbox/themes/default/polybar/config.ini ~/.config/openbox/themes/default/polybar/config-laptop.ini
cp ~/.config/openbox/themes/default/polybar/config.ini ~/.config/openbox/themes/default/polybar/config-external.ini
```

Edit each config with different module arrangements:

**Laptop config (config-laptop.ini):**
```ini
modules-right = volume dot backlight dot battery dot LD sysmenu RD dot-alt LD tray RD
```

**External monitor config (config-external.ini):**
```ini
modules-right = volume dot network dot LD sysmenu RD dot-alt LD tray RD
```

### 4. Clean Restart After Changes

**Problem:**
Modules not updating after configuration changes.

**Solution:**
```bash
# Remove module detection cache
rm -f ~/.config/openbox/themes/default/polybar/.module

# Kill all polybar instances
killall -q polybar

# Wait for processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Restart polybar
bash ~/.config/openbox/themes/launch-bar.sh
```

## Diagnostic Commands

### Check Monitor Setup
```bash
# List all monitors
xrandr --listmonitors

# Show current monitor configuration
xrandr --current

# Check which monitor is primary
xrandr --query | grep primary
```

### Check Backlight Devices
```bash
# List available backlight devices
ls -la /sys/class/backlight/

# Check if light command works
light

# Check if xbacklight works
xbacklight -get
```

### Check Polybar Processes
```bash
# List running polybar processes
ps aux | grep polybar

# Check which monitors have polybar
for mon in $(xrandr --listmonitors | grep -o '[^ ]*$' | tail -n +2); do
    echo "Monitor: $mon"
    MONITOR=$mon polybar --list-monitors
done
```

### Test Module Functionality
```bash
# Test brightness script
~/.config/openbox/themes/default/polybar/scripts/brightness-control.sh get

# Test clipboard manager
~/.config/openbox/themes/default/polybar/scripts/clipboard-manager.sh status
```

## Prevention Tips

1. **Always specify output for hardware-specific modules:**
   - Backlight/brightness: `output = eDP1`
   - Battery: `output = eDP1`
   - Laptop-specific sensors: `output = eDP1`

2. **Use custom scripts for problematic modules:**
   - More reliable across different setups
   - Better error handling
   - Easier to debug

3. **Test configurations before deployment:**
   ```bash
   # Test a single monitor first
   MONITOR=eDP1 polybar -q main -c ~/.config/openbox/themes/default/polybar/config.ini
   ```

4. **Keep backups of working configurations:**
   ```bash
   cp ~/.config/openbox/themes/default/polybar/modules.ini ~/.config/openbox/themes/default/polybar/modules.ini.backup
   ```

## Monitor Identification

### Find Your Monitor Names
```bash
# Method 1: xrandr
xrandr --listmonitors

# Method 2: Check what polybar sees
polybar --list-monitors

# Method 3: Check connected displays
xrandr | grep " connected"
```

Common monitor names:
- **Laptop screens:** `eDP1`, `eDP-1`, `LVDS1`, `LVDS-1`
- **External displays:** `DP1`, `DP-1`, `DP3-1`, `HDMI1`, `HDMI-1`, `VGA1`
- **USB-C/Thunderbolt:** `DP3-2-1`, `DP2-1`

## Conclusion

Most multi-monitor Polybar issues stem from modules trying to access hardware that doesn't exist on external monitors. The key is to:

1. Identify which modules are hardware-specific
2. Restrict them to the appropriate output (usually the laptop screen)
3. Use custom scripts for better compatibility
4. Test thoroughly after changes

This approach ensures a clean, error-free Polybar experience across all your monitors.
