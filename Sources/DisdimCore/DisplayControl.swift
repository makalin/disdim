import Foundation

public struct DisplayControl {
    public static func sleepDisplays() {
        let task = Process()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["displaysleepnow"]
        
        do {
            try task.run()
        } catch {
            // print("Failed to sleep displays: \(error)")
        }
    }
}
