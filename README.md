# disdim

Tiny macOS menu bar app to **sleep all displays** or **toggle external monitors on/off** — without unplugging any cables.

> _“Leave the cable, kill the glow.”_

---

## Features

- 💤 **Sleep all displays** with one click  
  - Uses `pmset displaysleepnow` under the hood
- 🎛 **Per-external-display ON/OFF (planned)**  
  - Control external monitors via DDC/CI (VCP `0xD6`)  
- 🧲 **Lives in the menu bar**
  - No dock icon, no clutter
- ⌨️ **(Planned)** global keyboard shortcuts:
  - `⌥⌘D` – Sleep all displays  
  - `⌥⌘E` – Toggle external displays
- 🪫 **Safe on laptops**
  - Doesn’t override system sleep settings or lid behavior

---

## How it works

### Display sleep

disdim calls the built-in macOS command:

```bash
pmset displaysleepnow
````

This tells macOS to **turn off all connected displays** (internal + external).
Moving the mouse or pressing a key wakes them back up.

### External display ON/OFF (planned)

For external-only control, disdim uses **DDC/CI**:

* Enumerates external displays
* Sends **VCP code `0xD6`**:

  * `0x01` → power on
  * `0x04` → power off / standby

Not all monitors / adapters support DDC/CI — when they don’t, disdim falls back to regular display sleep.

---

## Requirements

* macOS 13+ (Ventura) or newer
* External monitor connected via:

  * USB-C / DisplayPort / HDMI
  * Direct or via a DDC-compatible adapter
* For DDC/CI features:

  * Monitor must have DDC/CI enabled in its settings

---

## Installation

1. Clone the repo:

```bash
git clone https://github.com/makalin/disdim.git
cd disdim
```

2. Build the project:

```bash
# Build the App Bundle (disdim.app)
./bundle.sh

# Or build binaries manually
swift build -c release
```

3. Run the app:

```bash
open disdim.app
```

The app will appear in the menu bar.

---

## Usage

### Menu bar

Click the **disdim** icon in the menu bar to:
* **Sleep Displays**: Immediately sleep all displays.
* **External Displays**: Toggle external monitors On/Off (DDC/CI).
* **Quit disdim**: Exit the application.

### Global Shortcuts

* **⌥⌘D** (Option+Command+D): Sleep all displays.
* **⌥⌘E** (Option+Command+E): Turn OFF external displays.

### CLI (disdimc)

You can use the command-line tool to control displays from the terminal:

```bash
# Sleep all displays
.build/release/disdimc sleep

# List connected displays
.build/release/disdimc list

# Turn off external display at index 0
.build/release/disdimc off 0

# Turn on external display at index 0
.build/release/disdimc on 0
```

---

## Permissions & Notes

* `pmset displaysleepnow` may require Full Disk Access / Automation depending on how you call it
* For DDC/CI:

  * Some adapters (cheap USB hubs, some docks) **block** DDC
  * Some TVs ignore power commands
* disdim does **not**:

  * Patch kernel extensions
  * Override clamshell / lid sleep behavior
  * Disable system sleep

---

## Roadmap

* [x] Per-display DDC/CI power control
* [x] Automatic detection of DDC-capable monitors
* [x] Customizable global shortcuts (Hardcoded to Opt+Cmd+D/E for now)
* [ ] Per-app rules (e.g. “don’t sleep while in full screen”)
* [ ] Signed & notarized universal binary releases

---

## Contributing

PRs and issues are welcome:

* Support for more adapters / monitors
* Better DDC detection and error reporting
* Menu bar UX improvements

---

## License

MIT License – see `LICENSE` file for details.
