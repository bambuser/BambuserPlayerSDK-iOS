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
            url: "https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.5.1-release.xcframework.zip",
            checksum: "14a6d7b35bba774b4220cf70204f2fd58545510f3ee8d528da39ecb6709662a1"
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