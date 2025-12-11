# KYC Onboarding iOS SDK

[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

Official iOS SDK for Cynopsis KYC (Know Your Customer) onboarding solution.

⚠️ **This is a BINARY distribution** - SDK source code is not included.

## Features

- ✅ Complete KYC onboarding workflow
- 🔐 Multi-factor authentication (password, OTP, client credentials)
- 📄 Document upload with OCR support
- 🎭 AWS Rekognition liveness detection
- 📊 Real-time progress tracking
- 🌍 13-language localization
- 🔒 Secure token management (iOS Keychain)
- 📱 Native SwiftUI components

## Requirements

- iOS 14.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios.git", from: "0.1.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/kaifengCynopsis/kyc-onboarding-ios.git`
3. Select version: `0.1.0-beta.1`

## Dependencies

⚠️ **Important**: This SDK requires the following dependencies which will be automatically resolved by SPM:

- **AWS Amplify Swift** 2.42.1 (exact)
- **AWS Amplify UI Liveness** 1.0.1 (exact)
- **Veriff iOS SDK** 7.0.0+

These dependencies will be downloaded as **source code** when you integrate the SDK.

## Quick Start

```swift
import KycOnboardingSDK

// Initialize SDK
let config = KYCConfig(
    baseURL: "https://api1.artemisdev.cynopsis.co",
    clientId: "your-client-id",
    clientSecret: "your-client-secret"
)

let sdk = KYCSDK(configuration: config)

// Start KYC flow
sdk.startKYCFlow { result in
    switch result {
    case .success(let status):
        print("KYC completed: \(status)")
    case .failure(let error):
        print("KYC failed: \(error)")
    }
}
```

## Supported Languages

- English, Chinese (Simplified/Traditional)
- Japanese, Korean
- Spanish, French, German, Italian
- Turkish, Thai, Vietnamese, Mongolian

## Documentation

- [Integration Guide](https://docs.cynopsis.com/ios-sdk)
- [API Reference](https://docs.cynopsis.com/ios-sdk/api)
- [Migration Guide](https://docs.cynopsis.com/ios-sdk/migration)

## Support

- 📧 Email: support@cynopsis.com
- 📚 Documentation: https://docs.cynopsis.com
- 🐛 Issues: https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues

## License

Proprietary - Copyright © 2025 Cynopsis Solutions. All rights reserved.

See [LICENSE](LICENSE) for details.
