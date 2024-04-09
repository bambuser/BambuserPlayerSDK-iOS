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
            url: "https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.4.1-release.xcframework.zip",
            checksum: "c0684af4c2ae161402b4e7cb92265e458fd444116ae54727541a03ef11a5f67f"
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