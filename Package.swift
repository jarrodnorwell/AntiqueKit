// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AntiqueKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "AntiqueKit", targets: ["AntiqueKit"]),
        .library(name: "ColourKit", targets: ["ColourKit"]),
        .library(name: "OnboardingKit", targets: ["OnboardingKit"]),
        .library(name: "SettingsKit", targets: ["SettingsKit"])
    ],
    targets: [
        .target(name: "AntiqueKit", dependencies: ["ColourKit", "OnboardingKit", "SettingsKit"]),
        .target(name: "ColourKit"),
        .target(name: "OnboardingKit", dependencies: ["ColourKit"]),
        .target(name: "SettingsKit")
    ]
)
