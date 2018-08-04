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
        .package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git", from: "3.1.2"),
    ],
    targets: [
        .target(
            name: "PerfectQiniu",
            dependencies: ["PerfectCURL", "PerfectCrypto"]),
        .testTarget(
            name: "PerfectQiniuTests",
            dependencies: ["PerfectQiniu"]),
    ]
)
