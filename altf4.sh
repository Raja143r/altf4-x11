#!/bin/bash
# Windows-style Alt+F4 for X11
# Close focused window if any visible application window exists; otherwise show shutdown

# Check required commands
for cmd in xdotool wmctrl xprop gnome-session-quit; do
    command -v $cmd >/dev/null 2>&1 || { echo "$cmd not found!"; exit 1; }
done

# Get focused window
focused_window=$(xdotool getwindowfocus 2>/dev/null)

# Count visible normal windows
visible_window_count=0
for win in $(wmctrl -l | awk '{print $1}'); do
    # Check window type
    win_type=$(xprop -id "$win" _NET_WM_WINDOW_TYPE 2>/dev/null)
    if [[ "$win_type" != *"_NET_WM_WINDOW_TYPE_NORMAL"* ]]; then
        continue  # skip panels, docks, desktop
    fi

    # Check if window is minimized
    state=$(xprop -id "$win" _NET_WM_STATE 2>/dev/null)
    if [[ "$state" != *"_NET_WM_STATE_HIDDEN"* ]]; then
        ((visible_window_count++))
    fi
done

if [ "$visible_window_count" -gt 0 ]; then
    # Close focused window
    if [ -n "$focused_window" ]; then
        xdotool windowclose "$focused_window"
    fi
else
    # No normal windows visible → show shutdown menu
    gnome-session-quit --power-off
fi

