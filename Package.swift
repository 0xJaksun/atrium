// swift-tools-version: 6.0
import PackageDescription

let package: Package = Package(
    name: "atrium",
    platforms: [.macOS(.v14)],
    targets: [.executableTarget(name: "atrium")]
)
