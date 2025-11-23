import Cocoa
import Carbon

class HotKeyManager {
    static let shared = HotKeyManager()
    
    private var hotKeyRefs: [EventHotKeyRef] = []
    private var handlers: [Int: () -> Void] = [:]
    private var currentId: Int = 1
    
    private init() {
        installEventHandler()
    }
    
    func register(keyCode: Int, modifiers: Int, handler: @escaping () -> Void) {
        let id = currentId
        currentId += 1
        
        var hotKeyRef: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: OSType(0x44444D4D), id: UInt32(id)) // 'DDMM'
        
        let status = RegisterEventHotKey(UInt32(keyCode), UInt32(modifiers), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        if status == noErr, let ref = hotKeyRef {
            hotKeyRefs.append(ref)
            handlers[id] = handler
            // print("Registered hotkey ID \(id)")
        } else {
            // print("Failed to register hotkey: \(status)")
        }
    }
    
    private func installEventHandler() {
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        InstallEventHandler(GetApplicationEventTarget(), { (handler, event, userData) -> OSStatus in
            var hotKeyID = EventHotKeyID()
            GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)
            
            if let manager = userData?.assumingMemoryBound(to: HotKeyManager.self).pointee {
                manager.handleHotKey(id: Int(hotKeyID.id))
            } else {
                // Fallback if userData is not set correctly, though we pass self below
                HotKeyManager.shared.handleHotKey(id: Int(hotKeyID.id))
            }
            
            return noErr
        }, 1, &eventSpec, nil, nil)
    }
    
    private func handleHotKey(id: Int) {
        handlers[id]?()
    }
}
