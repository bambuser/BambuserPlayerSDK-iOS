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
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.7.0")
    ],
    targets: [
        .binaryTarget(
            name: "BambuserPlayerSDK",
            path: "Sources/BambuserPlayerSDK.xcframework"),
        .target(
            name: "BambuserPlayerBundle",
            dependencies: [
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ]
        )
    ]
)
