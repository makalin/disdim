// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "disdim",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "disdim", targets: ["disdim"]),
        .executable(name: "disdimc", targets: ["disdimc"])
    ],
    targets: [
        .target(
            name: "DisdimCore",
            dependencies: []
        ),
        .executableTarget(
            name: "disdim",
            dependencies: ["DisdimCore"]
        ),
        .executableTarget(
            name: "disdimc",
            dependencies: ["DisdimCore"]
        )
    ]
)
