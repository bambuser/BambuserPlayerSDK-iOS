// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "BambuserPlayerSDK",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "BambuserPlayerSDK",
            targets: ["BambuserPlayerSDK", "BambuserPlayerBundle"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.0.0"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "BambuserPlayerSDK",
            path: "Sources/BambuserPlayerSDK.xcframework"
        ),
        .target(
            name: "BambuserPlayerBundle",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ],
            resources: [
                .process("Resources/Localization/LocalizedStrings-English.json"),
            ]
        ),
    ]
)
