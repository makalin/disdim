import Cocoa
import DisdimCore

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "moon.zzz.fill", accessibilityDescription: "Sleep Displays")
        }
        
        setupMenu()
        setupHotKeys()
    }
    
    func setupHotKeys() {
        // kVK_ANSI_D = 0x02
        // kVK_ANSI_E = 0x0E
        // cmdKey = 0x0100 (256), optionKey = 0x0800 (2048) -> 2304
        // Carbon modifiers are different: cmdKey = 256, optionKey = 2048.
        // wait, Carbon modifiers: cmdKey = 1 << 8 (256), optionKey = 1 << 11 (2048).
        
        // Sleep Displays: Opt + Cmd + D
        HotKeyManager.shared.register(keyCode: 0x02, modifiers: 256 + 2048) { [weak self] in
            self?.sleepDisplays()
        }
        
        // Toggle External: Opt + Cmd + E
        HotKeyManager.shared.register(keyCode: 0x0E, modifiers: 256 + 2048) { [weak self] in
            self?.toggleExternalDisplays()
        }
    }
    
    func toggleExternalDisplays() {
        let displays = DisplayEnumerator.getDisplays().filter { $0.isExternal }
        // Simple toggle: if any is ON, turn all OFF. If all OFF, turn all ON.
        // Actually, we can't easily read state without DDC read (which is slow/flaky).
        // Let's just toggle based on a local state or just turn OFF if we don't know.
        // For now, let's just turn OFF as a "panic" button, or maybe cycle?
        // Let's implement "Turn OFF" for now as it's safer.
        // Or better: Check if we have stored state? No.
        // Let's just send OFF.
        
        for display in displays {
             _ = DDC.setPower(for: display.id, state: .off)
        }
        // print("Toggled external displays OFF via shortcut")
    }
    
    func setupMenu() {
        let menu = NSMenu()
        
        let sleepItem = NSMenuItem(title: "Sleep Displays", action: #selector(sleepDisplays), keyEquivalent: "s")
        sleepItem.keyEquivalentModifierMask = [.command, .option]
        menu.addItem(sleepItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // External Displays
        let displays = DisplayEnumerator.getDisplays().filter { $0.isExternal }
        if !displays.isEmpty {
            menu.addItem(NSMenuItem(title: "External Displays", action: nil, keyEquivalent: ""))
            for display in displays {
                let displayItem = NSMenuItem(title: display.name, action: nil, keyEquivalent: "")
                let submenu = NSMenu()
                
                let onItem = NSMenuItem(title: "Turn On", action: #selector(turnOnDisplay(_:)), keyEquivalent: "")
                onItem.representedObject = display.id
                submenu.addItem(onItem)
                
                let offItem = NSMenuItem(title: "Turn Off", action: #selector(turnOffDisplay(_:)), keyEquivalent: "")
                offItem.representedObject = display.id
                submenu.addItem(offItem)
                
                displayItem.submenu = submenu
                menu.addItem(displayItem)
            }
            menu.addItem(NSMenuItem.separator())
        }
        
        menu.addItem(NSMenuItem(title: "Quit disdim", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func sleepDisplays() {
        DisplayControl.sleepDisplays()
    }
    
    @objc func turnOnDisplay(_ sender: NSMenuItem) {
        if let displayId = sender.representedObject as? CGDirectDisplayID {
            _ = DDC.setPower(for: displayId, state: .on)
        }
    }
    
    @objc func turnOffDisplay(_ sender: NSMenuItem) {
        if let displayId = sender.representedObject as? CGDirectDisplayID {
            _ = DDC.setPower(for: displayId, state: .off)
        }
    }
}
