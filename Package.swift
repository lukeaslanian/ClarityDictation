// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ClarityDictation",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .executable(
            name: "ClarityDictation",
            targets: ["ClarityDictation"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ClarityDictation",
            dependencies: [],
            path: "ClarityDictation",
            resources: [
                .process("Assets.xcassets")
            ])
    ]
)