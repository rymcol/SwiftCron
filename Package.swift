// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftCron",
    products: [
        .library(name: "SwiftCron", targets: ["SwiftCron"])
    ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-Thread.git", .upToNextMinor(from: "3.0.2")),
        ],
    targets: [
        .target(name: "SwiftCron", dependencies: ["PerfectThread"]),
        .testTarget(name: "SwiftCronTests", dependencies: ["PerfectThread"], path: "./Tests/Swift-CronTests")
    ]
)

