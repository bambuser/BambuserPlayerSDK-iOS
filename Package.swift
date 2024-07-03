// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "BambuserPlayerSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BambuserPlayerSDK",
            targets: ["BambuserPlayerSDK", "BambuserPlayerBundle"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "10.18.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "BambuserPlayerSDK",
            url: "https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.5.0-release.xcframework.zip",
            checksum: "fd48509aa9210625625ce81f22880fa2202491de45dc098508b37e0ec8dfdeab"
        ),
        .target(
            name: "BambuserPlayerBundle",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            resources: [
                .process("Resources/Localization/LocalizedStrings-English.json")
            ]
        )
    ]
)