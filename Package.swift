// swift-tools-version: 5.9
import PackageDescription

/// Binary distribution package for KycOnboardingSDK
/// This package provides pre-built XCFramework binaries with automatic dependency resolution
///
/// Repository: https://github.com/kaifengCynopsis/kyc-onboarding-ios
/// Binary Source: https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases
///
/// Usage:
/// 1. Xcode → File → Add Package Dependencies
/// 2. Enter: https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
/// 3. Select version tag: 0.1.0-beta.1-binary
/// 4. Add to your target
///
/// Requirements:
/// - iOS 14.0+
/// - Xcode 15.x
/// - Swift 5.9

let package = Package(
    name: "KycOnboardingSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "KycOnboardingSDK",
            targets: ["KycOnboardingSDK", "KycOnboardingSDKDependencies"]
        )
    ],
    dependencies: [
        // AWS Amplify UI for Face Liveness
        .package(
            url: "https://github.com/pmd30011991/amplify-ui-swift-liveness",
            exact: "1.0.1"
        ),
        // AWS Amplify Core SDK
        .package(
            url: "https://github.com/aws-amplify/amplify-swift",
            exact: "2.42.1"
        ),
        // Veriff SDK for identity verification
        .package(
            url: "https://github.com/Veriff/veriff-ios-spm/",
            from: "7.0.0"
        )
    ],
    targets: [
        // Pre-built XCFramework binary from GitHub Release
        .binaryTarget(
            name: "KycOnboardingSDK",
            url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases/download/0.1.0-beta.1/KycOnboardingSDK.xcframework.zip",
            checksum: "ac8319a24e2da3242a6a6d1e11098cd6c00876a6a2f5881be2efd5551339730b"
        ),

        // Dependency wrapper target
        .target(
            name: "KycOnboardingSDKDependencies",
            dependencies: [
                .product(name: "FaceLiveness", package: "amplify-ui-swift-liveness"),
                .product(name: "Amplify", package: "amplify-swift"),
                .product(name: "AWSPluginsCore", package: "amplify-swift"),
                .product(name: "Veriff", package: "veriff-ios-spm")
            ],
            path: "Sources/KycOnboardingSDKDependencies"
        )
    ]
)
