import Foundation
import DisdimCore

let args = CommandLine.arguments

if args.count < 2 {
    print("Usage: disdimc <command> [args]")
    print("Commands:")
    print("  sleep       Sleep all displays")
    print("  on <index>  Turn on external display")
    print("  off <index> Turn off external display")
    print("  list        List connected displays")
    exit(1)
}

let command = args[1]

switch command {
case "sleep":
    DisplayControl.sleepDisplays()
case "on":
    guard args.count > 2, let index = Int(args[2]) else {
        print("Usage: disdimc on <index>")
        exit(1)
    }
    let displays = DisplayEnumerator.getDisplays().filter { $0.isExternal }
    if index < displays.count {
        _ = DDC.setPower(for: displays[index].id, state: .on)
        print("Turned ON display \(index)")
    } else {
        print("External display index \(index) out of range. Found \(displays.count) external displays.")
    }

case "off":
    guard args.count > 2, let index = Int(args[2]) else {
        print("Usage: disdimc off <index>")
        exit(1)
    }
    let displays = DisplayEnumerator.getDisplays().filter { $0.isExternal }
    if index < displays.count {
        _ = DDC.setPower(for: displays[index].id, state: .off)
        print("Turned OFF display \(index)")
    } else {
        print("External display index \(index) out of range. Found \(displays.count) external displays.")
    }
    
case "list":
    let displays = DisplayEnumerator.getDisplays()
    for (i, display) in displays.enumerated() {
        print("\(i): \(display.name) (ID: \(display.id)) [\(display.isExternal ? "External" : "Internal")]")
    }
    
default:
    print("Unknown command: \(command)")
    exit(1)
}
