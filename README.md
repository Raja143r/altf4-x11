# Alt+F4 for X11

A Linux script that mimics **Windows-style Alt+F4** behavior on X11 desktops:

- Closes the currently focused application window if any normal windows are visible.
- Shows the GNOME shutdown menu if all normal windows are minimized or closed.

---

## Features

- Works on most Linux distributions running X11 and GNOME.
- Automatically detects minimized windows.
- Lightweight Bash script using `xdotool`, `wmctrl`, and `xprop`.
- Open-source and free to use, modify, and redistribute (with credit).

---

## Requirements

Make sure the following commands are installed on your system:

- `bash`
- `xdotool`
- `wmctrl`
- `xprop`
- `gnome-session-quit`

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/altf4-x11.git
cd altf4-x11
```
2. Make the script executable:
```bash
chmod +x altf4.sh
```

## Usage

Run the script directly:
```bash
./altf4.sh
```
Or bind it to a key combination (e.g., Alt+F4) in your desktop environment’s keyboard settings.

# License & Credit

This script is licensed under the MIT License. You are free to use, modify, and redistribute it as long as the original copyright notice and license are preserved, crediting the original author:
```text
Copyright (c) 2025 Maharaja
