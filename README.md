# KycOnboardingSDK - Binary Distribution

[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

Cynopsis KYC Onboarding SDK - Pre-built XCFramework binary with automatic dependency resolution through Swift Package Manager.

## 🚀 Quick Start

### Swift Package Manager (Recommended)

Add the package to your Xcode project:

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter the repository URL:
   ```
   https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
   ```
4. Select version: `0.1.0-beta.1-binary`
5. Click **Add Package**

All dependencies (Amplify, Veriff, FaceLiveness) will be automatically installed.

### Manual Integration

Download the XCFramework:
- [KycOnboardingSDK.xcframework.zip](https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases/download/0.1.0-beta.1/KycOnboardingSDK.xcframework.zip)
- **Checksum:** `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54`

⚠️ **Note:** Manual integration requires adding all dependencies separately:
- AWS Amplify Swift 2.42.1
- AWS FaceLiveness 1.0.1
- Veriff SDK 7.x

SPM integration is **strongly recommended** for automatic dependency management.

## 📋 Requirements

- **iOS:** 14.0+
- **Xcode:** 15.x
- **Swift:** 5.9

⚠️ **Important:** Due to `BUILD_LIBRARY_FOR_DISTRIBUTION=NO` limitation (Amplify SDK constraint), you must use **Xcode 15.x / Swift 5.9** - the same version used to build this XCFramework.

## 📦 What's Included

This package provides:

- **KycOnboardingSDK.xcframework** - Pre-built binary framework
- **Automatic dependency resolution** for:
  - AWS Amplify Swift (2.42.1)
  - AWS FaceLiveness (1.0.1)
  - Veriff SDK (7.x)

## 🔧 Usage

### Basic Integration

```swift
import KycOnboardingSDK

// Configure SDK
let config = KycSDKConfig(
    apiBaseURL: "https://your-api.com",
    clientId: "your-client-id",
    environment: .production
)

// Initialize
let kyc = KycOnboarding(config: config)

// Start verification flow
try await kyc.startVerification()
```

### Flutter iOS Integration

1. Open your Flutter project's iOS workspace:
   ```bash
   cd your_flutter_project/ios
   open Runner.xcworkspace
   ```

2. In Xcode, select **Runner** project → **Runner** target
3. Go to **General** → **Frameworks, Libraries, and Embedded Content**
4. Click **+** → **Add Package Dependency**
5. Enter: `https://github.com/kaifengCynopsis/kyc-onboarding-ios.git`
6. Select version: `0.1.0-beta.1-binary`

Now your Flutter plugin can use the SDK:

```swift
// In your Flutter plugin's Swift code
import KycOnboardingSDK

class KycOnboardingPlugin: NSObject, FlutterPlugin {
    // SDK is now available!
    let kyc = KycOnboarding(config: config)
}
```

## 📚 Documentation

- **API Reference:** [Documentation Link]
- **Integration Guide:** [Guide Link]
- **Migration Guide:** [Migration Link]
- **Source Code Repository:** https://github.com/kaifengCynopsis/kyc-onboarding-ios

## 🔐 License

Proprietary - © 2024 Cynopsis Solutions. All rights reserved.

This binary distribution is provided for licensed customers only. Unauthorized distribution or use is prohibited.

## 🆘 Support

- **Issues:** https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues
- **Email:** support@cynopsis.com
- **Documentation:** [Docs Link]

## 🔄 Version History

### 0.1.0-beta.1 (2024-12-11)

- Initial binary distribution release
- Pre-built XCFramework with SPM support
- Automatic dependency resolution
- iOS 14.0+ support

**Checksum:** `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54`

## ⚠️ Known Limitations

1. **Swift Version Dependency:**
   - Built with Swift 5.9 / Xcode 15.x
   - Requires same version in consuming projects
   - Due to Amplify SDK's `BUILD_LIBRARY_FOR_DISTRIBUTION=NO` constraint

2. **Binary Size:**
   - ~21 MB (compressed)
   - ~60 MB (unpacked)
   - Dependencies add additional ~100 MB

## 🔮 Roadmap

- [ ] Enable `BUILD_LIBRARY_FOR_DISTRIBUTION` (pending Amplify SDK support)
- [ ] Reduce binary size through optimization
- [ ] Add CocoaPods distribution option
- [ ] Support older Swift versions

## 🤝 Contributing

This is a binary distribution repository. For source code contributions, please visit:
https://github.com/kaifengCynopsis/kyc-onboarding-ios

---

**Maintained by:** Cynopsis Solutions
**Last Updated:** 2024-12-11
