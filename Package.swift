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
            url: "https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.5.3-release.xcframework.zip",
            checksum: "61140519547e7967d4fbd6c6c61cec64adc4196ddb439f293117a00a5a96090d"
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