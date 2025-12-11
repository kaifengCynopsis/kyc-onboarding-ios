// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KycOnboardingSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "KycOnboardingSDK",
            targets: ["KycOnboardingSDK"]
        )
    ],
    dependencies: [
        // AWS Amplify UI for Face Liveness
        // ⚠️ 用户需要单独添加这些依赖到他们的项目中
        .package(url: "https://github.com/pmd30011991/amplify-ui-swift-liveness", exact: "1.0.1"),
        .package(url: "https://github.com/aws-amplify/amplify-swift", exact: "2.42.1"),
        .package(url: "https://github.com/Veriff/veriff-ios-spm/", from: "7.0.0"),
    ],
    targets: [
        // 二进制目标 - SDK 核心代码（已编译）
        .binaryTarget(
            name: "KycOnboardingSDK",
            url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases/download/0.1.0-beta.1/KycOnboardingSDK.xcframework.zip",
            checksum: "ac8319a24e2da3242a6a6d1e11098cd6c00876a6a2f5881be2efd5551339730b"
        )
    ]
)
