// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: ["Common"]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
    ]
)
