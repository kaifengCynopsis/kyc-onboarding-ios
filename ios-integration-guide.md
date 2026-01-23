# KycOnboardingSDK iOS Integration Guide (V2)

> **Version**: 2.0
> **Last Updated**: 2026-01-23
> **Minimum iOS Version**: iOS 14.0+
> **Xcode**: 15.2+
> **Swift**: 5.9+

---

## Overview

KycOnboardingSDK provides a unified entry point for Know Your Customer (KYC) verification, supporting both **Individual** and **Corporate** flows. The SDK handles the entire verification process including:

- Welcome screen with privacy policy consent
- Customer type selection (Individual vs. Corporate)
- Document capture and OCR
- Liveness detection (AWS Amplify FaceLiveness)
- Phone/Email verification
- Corporate verification workflow

---

## Installation

### Option 1: XCFramework (Recommended for Production)

1. Download `KycOnboardingSDK.xcframework` from [GitHub Releases](https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases)

2. Drag `KycOnboardingSDK.xcframework` into your Xcode project

3. In **Target → General → Frameworks, Libraries, and Embedded Content**:
   - Set `KycOnboardingSDK.xcframework` to **Embed & Sign**

4. Add required SPM dependencies (the SDK requires these):
   - `amplify-ui-swift-liveness` (1.0.1+)
   - `amplify-swift` (2.42.1+)
   - `veriff-ios-spm` (7.0.0+)

### Option 2: Swift Package Manager

Add the package to your `Package.swift` or via Xcode:

```swift
dependencies: [
    .package(url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** and enter:
```
https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
```

---

## Required Permissions

Add the following to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for identity verification and document capture</string>

<key>NSMicrophoneUsageDescription</key>
<string>Microphone access may be required for voice verification</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is needed to upload identity documents</string>
```

---

## Quick Start

### Step 1: Import the SDK

```swift
import SwiftUI
import KycOnboardingSDK
```

### Step 2: Configure the SDK

```swift
let config = KycSDKConfig(
    apiBaseURL: "https://api1.artemisdev.cynopsis.co",
    crmBaseURL: "https://crm-dev.cynopsis.co",
    clientId: "your-client-id",
    clientSecret: "your-client-secret",
    domainId: "your-domain-id",
    environment: .development,    // .development, .uat, or .production
    language: .english,           // See supported languages below
    enableLogging: true,          // Enable debug logging
    livenessRegion: "ap-northeast-1"  // AWS region for liveness
)

KycOnboarding.configure(config)
```

### Step 3: Start KYC Verification

```swift
Task {
    do {
        let entryView = try await KycOnboarding.shared.createVerificationView(
            userId: "unique-user-id",
            onComplete: { result in
                switch result {
                case .completed(let customerId, let customerType):
                    print("KYC completed! Customer ID: \(customerId ?? 0), Type: \(customerType)")
                case .cancelled:
                    print("KYC cancelled by user")
                case .pendingReview:
                    print("KYC submitted, pending review")
                case .error(let message):
                    print("KYC error: \(message)")
                }
            }
        )

        // Present the view (e.g., using fullScreenCover)
        self.kycView = AnyView(entryView)
        self.showKycFlow = true

    } catch {
        print("Failed to initialize KYC: \(error)")
    }
}
```

---

## Complete SwiftUI Example

```swift
import SwiftUI
import KycOnboardingSDK

struct ContentView: View {
    @State private var showKycFlow = false
    @State private var kycView: AnyView?
    @State private var isLoading = false
    @State private var statusMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("KYC Demo")
                .font(.largeTitle)

            Button(action: startKyc) {
                HStack {
                    if isLoading {
                        ProgressView()
                    }
                    Text("Start KYC Verification")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isLoading)
            .padding(.horizontal)

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .fullScreenCover(isPresented: $showKycFlow) {
            if let view = kycView {
                view
            }
        }
    }

    private func startKyc() {
        isLoading = true

        // Configure SDK
        let config = KycSDKConfig(
            apiBaseURL: "https://api1.artemisdev.cynopsis.co",
            crmBaseURL: "https://crm-dev.cynopsis.co",
            clientId: "your-client-id",
            clientSecret: "your-client-secret",
            domainId: "your-domain-id",
            environment: .development,
            language: .english,
            enableLogging: true,
            livenessRegion: "ap-northeast-1"
        )

        KycOnboarding.reset()  // Reset any previous session
        KycOnboarding.configure(config)

        // Start verification
        Task { @MainActor in
            do {
                let entryView = try await KycOnboarding.shared.createVerificationView(
                    userId: "user_\(Int(Date().timeIntervalSince1970))",
                    onComplete: { result in
                        Task { @MainActor in
                            showKycFlow = false
                            isLoading = false

                            switch result {
                            case .completed(let customerId, let customerType):
                                statusMessage = "✅ Completed! ID: \(customerId ?? 0)"
                            case .cancelled:
                                statusMessage = "⚠️ Cancelled"
                            case .pendingReview:
                                statusMessage = "⏳ Pending Review"
                            case .error(let message):
                                statusMessage = "❌ Error: \(message)"
                            }
                        }
                    }
                )

                kycView = AnyView(entryView)
                isLoading = false
                showKycFlow = true

            } catch {
                isLoading = false
                statusMessage = "❌ Init failed: \(error.localizedDescription)"
            }
        }
    }
}
```

---

## Configuration Options

### KycSDKConfig Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `apiBaseURL` | `String` | ✅ | Digital Onboarding API base URL |
| `crmBaseURL` | `String` | ✅ | CRM/OAuth API base URL |
| `clientId` | `String` | ✅ | OAuth client ID |
| `clientSecret` | `String` | ✅ | OAuth client secret |
| `domainId` | `String` | ✅ | Your domain ID |
| `environment` | `Environment` | ✅ | `.development`, `.uat`, or `.production` |
| `language` | `Language` | ❌ | UI language (default: `.english`) |
| `enableLogging` | `Bool` | ❌ | Enable debug logs (default: `false`) |
| `livenessRegion` | `String` | ❌ | AWS region for liveness (default: `ap-northeast-1`) |

### Environment URLs

| Environment | API Base URL | CRM Base URL |
|-------------|--------------|--------------|
| Development | `https://api1.artemisdev.cynopsis.co` | `https://crm-dev.cynopsis.co` |
| UAT | `https://api1.artemisuat.cynopsis.co` | `https://crm-uat.cynopsis.co` |
| Production | `https://api1.cynopsis.co` | `https://crm.cynopsis.co` |

---

## Completion Results

The `onComplete` callback receives a `KycCompletionResult`:

```swift
enum KycCompletionResult {
    case completed(customerId: Int?, customerType: CustomerType)
    case cancelled
    case pendingReview
    case error(message: String)
}

enum CustomerType: String {
    case individual = "INDIVIDUAL"
    case corporate = "CORPORATE"
}
```

---

## Supported Languages （English 词条完整）

The SDK supports 13 languages:

| Code | Language |
|------|----------|
| `.english` | English |
| `.chineseSimplified` | 简体中文 |
| `.chineseTraditional` | 繁體中文 |
| `.japanese` | 日本語 |
| `.korean` | 한국어 |
| `.thai` | ไทย |
| `.vietnamese` | Tiếng Việt |
| `.indonesian` | Bahasa Indonesia |
| `.malay` | Bahasa Melayu |
| `.spanish` | Español |
| `.french` | Français |
| `.german` | Deutsch |
| `.mongolian` | Монгол |

---

## Session Management

### Reset Session

Before starting a new KYC flow, reset the previous session:

```swift
KycOnboarding.reset()
```

### Check Session Status

```swift
if KycOnboarding.shared.hasActiveSession {
    // Session exists, can resume
}
```

---

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| `tokenUnavailable` | OAuth authentication failed | Check clientId/clientSecret |
| `network` | Network connection issue | Check internet connection |
| `configurationMissing` | SDK not configured | Call `KycOnboarding.configure()` first |
| `cancelled` | User cancelled the flow | Handle gracefully in UI |

---

## Best Practices

1. **Always reset before starting a new flow**
   ```swift
   KycOnboarding.reset()
   KycOnboarding.configure(config)
   ```

2. **Use unique userId for each user**
   - The userId links the KYC session to your user
   - Use your internal user ID or generate a unique one

3. **Handle all completion cases**
   - Don't forget to handle `.cancelled` and `.pendingReview`

4. **Enable logging during development**
   ```swift
   enableLogging: true
   ```

5. **Test with different languages**
   - Ensure your UI handles different text lengths

---

## Migration from V1

If migrating from the old integration:

### Old Way (V1)
```swift
// ❌ Old - Don't use
let sdk = KycOnboarding.shared
sdk.initialize(credentials)
sdk.showEntryScreen()
```

### New Way (V2)
```swift
// ✅ New - Use this
KycOnboarding.configure(config)
let view = try await KycOnboarding.shared.createVerificationView(
    userId: "user-id",
    onComplete: { result in ... }
)
```

Key changes:
- Use `createVerificationView()` instead of manual initialization
- Configuration via `KycSDKConfig` struct
- Async/await API
- SwiftUI-first design

---

## Sample Project

A complete sample project is available at:
```
ios/Examples/SampleAppV2/
```

This demonstrates:
- SDK configuration
- Starting KYC flow
- Handling completion results
- UI integration patterns

---

## Support

- **Email**: support@cynopsis.com
- **GitHub Issues**: [kyc-onboarding-ios](https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues)
- **Documentation**: https://docs.cynopsis.com

---

## Changelog

### V2.0 (2026-01-23)
- New unified `createVerificationView()` API
- Async/await support
- Simplified configuration
- SwiftUI-first design
- XCFramework distribution support
