import Foundation
import CoreGraphics

public struct Display {
    public let id: CGDirectDisplayID
    public let name: String
    public let isExternal: Bool
}

public class DisplayEnumerator {
    public static func getDisplays() -> [Display] {
        var displayCount: UInt32 = 0
        var activeDisplays = [CGDirectDisplayID](repeating: 0, count: 16)
        
        let result = CGGetOnlineDisplayList(16, &activeDisplays, &displayCount)
        
        guard result == .success else {
            print("Failed to get display list")
            return []
        }
        
        var displays: [Display] = []
        for i in 0..<Int(displayCount) {
            let id = activeDisplays[i]
            let isBuiltin = CGDisplayIsBuiltin(id) != 0
            // Simple name generation, real implementation would use IOKit to get model name
            let name = isBuiltin ? "Built-in Display" : "External Display \(i)"
            
            displays.append(Display(id: id, name: name, isExternal: !isBuiltin))
        }
        
        return displays
    }
}
