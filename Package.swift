// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "BambuserPlayerSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BambuserPlayerSDK",
            targets: ["BambuserPlayerSDK", "BambuserPlayerBundle"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "BambuserPlayerSDK",
            url: "https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK.xcframework.zip",
            checksum: "9b3d96be00843f55e56289b12159f57e6068fde596614785ce7d310115b36071"
        ),
        .target(
            name: "BambuserPlayerBundle",
            resources: [
                .process("Resources/Localization/LocalizedStrings-English.json")
            ]
        )
    ]
)