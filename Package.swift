// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PerfectQiniu",
    products: [
        .library(
            name: "PerfectQiniu",
            targets: ["PerfectQiniu"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", from: "3.0.6"),
    ],
    targets: [
        .target(
            name: "PerfectQiniu",
            dependencies: ["PerfectCURL"]),
        .testTarget(
            name: "PerfectQiniuTests",
            dependencies: ["PerfectQiniu"]),
    ]
)
