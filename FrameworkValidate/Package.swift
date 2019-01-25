// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FrameworkValidate",
    products: [
         .executable(name: "FrameworkValidate", targets: ["FrameworkValidate"]),
        ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/antitypical/Result.git",
                 from: "4.1.0"),
        ],
    targets: [
        .target(
            name: "FrameworkValidate",
            dependencies: ["Commandant", "Result"]),
//        .testTarget(
//            name: "FrameworkValidateTests",
//            dependencies: ["Commandant", "Result"]),
        ]
)

// platforms:[SupportedPlatform(platform: Platform(name: "macos", oldestSupportedVersion: "10.13"), version: PlatformVersion("10.13"))]
