// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platformer3D",
	platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "Platformer3D",
            type: .dynamic,
            targets: ["Platformer3D"]),
    ],
	dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", from: "0.42.0")
    ],
    targets: [
        .target(
            name: "Platformer3D",
			dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
                "SwiftGodot"
            ],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])]
        ),
        .testTarget(
            name: "Platformer3DTests",
            dependencies: ["Platformer3D"]),
    ]
)
