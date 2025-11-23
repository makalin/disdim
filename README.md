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

> **Note:** For now, disdim is source-only. Binary releases are planned.

1. Clone the repo:

```bash
git clone https://github.com/makalin/disdim.git
cd disdim
```

2. Open in Xcode:

```bash
open disdim.xcodeproj
```

3. Set the signing team (if needed)
4. Build & run the **disdim** target

disdim will appear as an icon in the menu bar.

---

## Usage

### Menu bar

Click the **disdim** icon in the menu bar to open the menu:

* **Sleep Displays**
  → runs `pmset displaysleepnow`
* **External Displays → Off / On** (planned)
  → sends DDC/CI power commands to selected monitors
* **Preferences** (planned)

  * Configure shortcuts
  * Enable / disable DDC per display
* **Quit disdim**

### From Terminal (optional helper)

If you use the bundled tiny helper CLI:

```bash
disdimc sleep        # same as pmset displaysleepnow
disdimc off 1        # turn off external display #1 (DDC)
disdimc on 1         # turn on external display #1 (DDC)
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

* [ ] Per-display DDC/CI power control
* [ ] Automatic detection of DDC-capable monitors
* [ ] Customizable global shortcuts
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
