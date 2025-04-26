// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserPersistence",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UserPersistence",
            targets: ["UserPersistence"]),
    ],
    targets: [
        .target(
            name: "UserPersistence"),
        .testTarget(
            name: "UserPersistenceTests",
            dependencies: ["UserPersistence"]),
    ]
)
