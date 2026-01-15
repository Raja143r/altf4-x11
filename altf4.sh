#!/bin/bash
# Windows-style Alt+F4 for ALL X11 desktops
# Close focused window if any visible normal window exists
# Otherwise show a logout / shutdown dialog

set -e

# ---- Requirements check ----
for cmd in wmctrl xprop xdotool; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing dependency: $cmd"
        exit 1
    }
done

# ---- Count visible normal windows ----
visible_window_count=0

while read -r win; do
    # Check window type
    type=$(xprop -id "$win" _NET_WM_WINDOW_TYPE 2>/dev/null || true)
    [[ "$type" != *"_NET_WM_WINDOW_TYPE_NORMAL"* ]] && continue

    # Check window state (skip minimized/hidden)
    state=$(xprop -id "$win" _NET_WM_STATE 2>/dev/null || true)
    [[ "$state" == *"_NET_WM_STATE_HIDDEN"* ]] && continue

    ((visible_window_count++))
done < <(wmctrl -l | awk '{print $1}')

# ---- Get focused window ----
focused_window=$(xdotool getwindowfocus 2>/dev/null || true)

# ---- Action ----
if [[ "$visible_window_count" -gt 0 && -n "$focused_window" ]]; then
    # Close focused window
    xdotool windowclose "$focused_window"
else
    # No visible windows → show logout / shutdown
    if command -v gnome-session-quit >/dev/null 2>&1; then
        gnome-session-quit --power-off
    elif command -v xfce4-session-logout >/dev/null 2>&1; then
        xfce4-session-logout
    elif command -v lxqt-leave >/dev/null 2>&1; then
        lxqt-leave
    elif command -v qdbus >/dev/null 2>&1; then
        # KDE fallback
        qdbus org.kde.ksmserver /KSMServer logout 0 1 0
    else
        # Last-resort fallback
        xmessage "No active windows.\nUse your desktop's logout menu."
    fi
fi
