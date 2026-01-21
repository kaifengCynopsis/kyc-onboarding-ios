# KycOnboardingSDK iOS 集成指南

> 版本: 0.1.0-beta.2
> 更新日期: 2026-01-21

---

## 目录

1. [系统要求](#系统要求)
2. [安装方式](#安装方式)
3. [权限配置](#权限配置)
4. [快速开始](#快速开始)
5. [统一 KYC 入口](#统一-kyc-入口)
6. [配置选项](#配置选项)
7. [API 参考](#api-参考)
8. [SwiftUI 集成](#swiftui-集成)
9. [UIKit 集成](#uikit-集成)
10. [常见问题](#常见问题)

---

## 系统要求

| 要求 | 最低版本 |
|------|----------|
| iOS | 14.0+ |
| Xcode | 15.2+ |
| Swift | 5.9+ |

---

## 安装方式

### 方式一：Swift Package Manager（推荐）

#### 通过 Xcode 添加

1. 打开 Xcode 项目
2. **File → Add Package Dependencies...**
3. 输入仓库 URL：
   ```
   https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
   ```
4. 选择版本：`0.1.0-beta.2`
5. 选择 `KycOnboardingSDK` 添加到目标

#### 通过 Package.swift 添加

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v14)
    ],
    dependencies: [
        .package(
            url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios.git",
            from: "0.1.0-beta.2"
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "KycOnboardingSDK", package: "kyc-onboarding-ios")
            ]
        )
    ]
)
```

### 方式二：手动 XCFramework 集成

1. 从 [GitHub Releases](https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases) 下载 `KycOnboardingSDK.xcframework.zip`

2. 解压并将 `KycOnboardingSDK.xcframework` 拖入 Xcode 项目

3. 在 **Target → General → Frameworks, Libraries, and Embedded Content** 设置为 **Embed & Sign**

4. 通过 SPM 添加必需依赖：
   - `aws-amplify/amplify-swift` (2.42.1)
   - `pmd30011991/amplify-ui-swift-liveness` (1.0.1)
   - `Veriff/veriff-ios-spm` (7.0.0+)

---

## 权限配置

在 `Info.plist` 添加必要权限描述：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 相机权限（用于身份验证和文档拍摄）-->
    <key>NSCameraUsageDescription</key>
    <string>需要相机权限用于身份验证和文档拍摄</string>

    <!-- 麦克风权限（活体检测可能需要）-->
    <key>NSMicrophoneUsageDescription</key>
    <string>需要麦克风权限用于语音验证</string>

    <!-- 相册权限（用于文档上传）-->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>需要相册权限用于上传文档照片</string>

    <!-- 如果支持 Face ID -->
    <key>NSFaceIDUsageDescription</key>
    <string>需要 Face ID 用于安全验证</string>
</dict>
</plist>
```

---

## 快速开始

### 1. 导入 SDK

```swift
import KycOnboardingSDK
```

### 2. 配置 SDK

```swift
let config = KycSDKConfig(
    apiBaseURL: URL(string: "https://api1.artemisdev.cynopsis.co")!,
    crmBaseURL: URL(string: "https://crm-dev.cynopsis.co")!,
    clientId: "your-client-id",
    clientSecret: "your-client-secret",
    domainId: "your-domain-id",
    environment: .development,  // 或 .production
    language: .english,
    enableLogging: true,
    livenessRegion: "ap-northeast-1"
)

// 配置 SDK（全局单例）
KycOnboarding.configure(config)
```

### 3. 启动统一 KYC 流程

```swift
// 创建验证视图（统一入口）
Task {
    do {
        let entryView = try await KycOnboarding.shared.createVerificationView(
            userId: "user-unique-id",
            onComplete: { result in
                switch result {
                case .completed(let customerId, let customerType):
                    print("KYC 完成! Customer ID: \(customerId ?? 0), Type: \(customerType.rawValue)")
                case .cancelled:
                    print("用户取消")
                case .pendingReview:
                    print("等待审核")
                case .error(let message):
                    print("错误: \(message)")
                }
            }
        )

        // 呈现 KycEntryView（统一入口视图）
        // entryView 是 KycEntryView 类型

    } catch {
        print("初始化失败: \(error)")
    }
}
```

---

## 统一 KYC 入口

### KycEntryView - 统一入口视图

`KycEntryView` 是 SDK 的**统一入口**，自动处理：

1. **Welcome 欢迎页面** - 显示隐私政策并获取用户同意
2. **客户类型选择** - 用户选择"个人"或"企业"
3. **自动路由** - 根据选择进入对应流程：
   - **个人 KYC** → 文档选择 → 文档上传 → OCR 审核 → 活体检测 → 手机验证 → 完成
   - **企业 KYC** → 公司信息 → 关联方管理 → 文档上传 → 表单填写 → 审核提交

### 使用示例

```swift
import SwiftUI
import KycOnboardingSDK

struct ContentView: View {
    @State private var showKycFlow = false
    @State private var kycEntryView: KycEntryView?
    @State private var isLoading = false
    @State private var resultMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Button("开始 KYC 验证") {
                startKycFlow()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            if isLoading {
                ProgressView("初始化中...")
            }

            if !resultMessage.isEmpty {
                Text(resultMessage)
                    .foregroundColor(.secondary)
            }
        }
        .fullScreenCover(isPresented: $showKycFlow) {
            if let entryView = kycEntryView {
                entryView
            }
        }
        .onAppear {
            configureSDK()
        }
    }

    private func configureSDK() {
        let config = KycSDKConfig(
            apiBaseURL: URL(string: "https://api1.artemisdev.cynopsis.co")!,
            crmBaseURL: URL(string: "https://crm-dev.cynopsis.co")!,
            clientId: "your-client-id",
            clientSecret: "your-client-secret",
            domainId: "your-domain-id",
            environment: .development,
            language: .english,
            enableLogging: true,
            livenessRegion: "ap-northeast-1"
        )

        KycOnboarding.reset()
        KycOnboarding.configure(config)
    }

    private func startKycFlow() {
        isLoading = true

        Task { @MainActor in
            do {
                let entryView = try await KycOnboarding.shared.createVerificationView(
                    userId: "user-\(UUID().uuidString.prefix(8))",
                    onComplete: { [self] result in
                        showKycFlow = false

                        switch result {
                        case .completed(let customerId, let customerType):
                            resultMessage = "✅ KYC 完成! ID: \(customerId ?? 0), 类型: \(customerType.rawValue)"
                        case .cancelled:
                            resultMessage = "❌ 用户取消"
                        case .pendingReview:
                            resultMessage = "⏳ 等待审核"
                        case .error(let message):
                            resultMessage = "⚠️ 错误: \(message)"
                        }
                    }
                )

                self.kycEntryView = entryView
                self.isLoading = false
                self.showKycFlow = true

            } catch {
                isLoading = false
                resultMessage = "初始化失败: \(error.localizedDescription)"
            }
        }
    }
}
```

### 直接使用 KycEntryView（高级用法）

如果您已经有 SDK 实例和会话信息，可以直接使用 `KycEntryView`：

```swift
import SwiftUI
import KycOnboardingSDK

struct DirectKycView: View {
    let sdk: KycOnboarding
    let session: DigitalOnboardingSession? // 可选，用于恢复会话

    var body: some View {
        KycEntryView(
            sdk: sdk,
            session: session,
            onComplete: { result in
                switch result {
                case .completed(let customerId, let customerType):
                    print("完成: \(customerId ?? 0), \(customerType)")
                case .cancelled:
                    print("取消")
                case .pendingReview:
                    print("待审核")
                case .error(let message):
                    print("错误: \(message)")
                }
            }
        )
    }
}
```

---

## 配置选项

### KycSDKConfig

| 参数 | 类型 | 必需 | 默认值 | 说明 |
|------|------|------|--------|------|
| `apiBaseURL` | URL | ✅ | - | Artemis API 基础 URL |
| `crmBaseURL` | URL | ✅ | - | CRM 系统基础 URL |
| `clientId` | String | ✅ | - | 客户端 ID |
| `clientSecret` | String | ✅ | - | 客户端密钥 |
| `domainId` | String | ✅ | - | 域 ID |
| `environment` | Environment | ❌ | .development | 环境配置 |
| `language` | Language | ❌ | .english | 界面语言 |
| `enableLogging` | Bool | ❌ | false | 是否启用日志 |
| `livenessRegion` | String | ❌ | "ap-northeast-1" | AWS 活体检测区域 |

### Environment

```swift
public enum Environment {
    case development  // 开发环境
    case staging      // 测试环境
    case production   // 生产环境
}
```

### Language (支持 13 种语言，目前英语词条完整)

```swift
public enum Language: String, CaseIterable {
    case english = "en" // 当前支持的语音
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    case thai = "th"
    case vietnamese = "vi"
    case indonesian = "id"
    case malay = "ms"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case portuguese = "pt"
}
```

---

## API 参考

### KycOnboarding

```swift
public final class KycOnboarding {

    /// 全局单例
    public static var shared: KycOnboarding

    /// 配置 SDK（必须在使用前调用）
    public static func configure(_ config: KycSDKConfig)

    /// 重置 SDK 状态
    public static func reset()

    /// 创建统一验证视图（推荐入口）
    /// - Parameters:
    ///   - userId: 用户唯一标识
    ///   - onComplete: 完成回调
    /// - Returns: KycEntryView 实例
    public func createVerificationView(
        userId: String,
        onComplete: @escaping (KycCompletionResult) -> Void
    ) async throws -> KycEntryView

    /// 获取当前 SDK 版本
    public var version: String { get }

    /// 当前客户 ID
    public var currentCustomerId: Int? { get }
}
```

### KycCompletionResult

```swift
public enum KycCompletionResult {
    case completed(customerId: Int?, customerType: CustomerType)
    case cancelled
    case pendingReview
    case error(message: String)
}
```

### CustomerType

```swift
public enum CustomerType: String {
    case individual = "INDIVIDUAL"  // 个人客户
    case corporate = "CORPORATE"    // 企业客户
}
```

---

## SwiftUI 集成

### 完整示例

```swift
import SwiftUI
import KycOnboardingSDK

@main
struct MyApp: App {
    init() {
        // 在应用启动时配置 SDK
        let config = KycSDKConfig(
            apiBaseURL: URL(string: "https://api1.artemisdev.cynopsis.co")!,
            crmBaseURL: URL(string: "https://crm-dev.cynopsis.co")!,
            clientId: "your-client-id",
            clientSecret: "your-client-secret",
            domainId: "your-domain-id",
            environment: .development,
            language: .english,
            enableLogging: true,
            livenessRegion: "ap-northeast-1"
        )
        KycOnboarding.configure(config)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @State private var showKyc = false
    @State private var kycView: KycEntryView?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("我的应用")
                    .font(.largeTitle)

                Button("开始身份验证") {
                    startVerification()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("首页")
        }
        .fullScreenCover(isPresented: $showKyc) {
            if let view = kycView {
                view
            }
        }
    }

    private func startVerification() {
        Task { @MainActor in
            do {
                kycView = try await KycOnboarding.shared.createVerificationView(
                    userId: "user-123",
                    onComplete: { result in
                        showKyc = false
                        handleResult(result)
                    }
                )
                showKyc = true
            } catch {
                print("Error: \(error)")
            }
        }
    }

    private func handleResult(_ result: KycCompletionResult) {
        switch result {
        case .completed(let id, let type):
            print("验证完成: \(id ?? 0), \(type)")
        case .cancelled:
            print("用户取消")
        case .pendingReview:
            print("等待审核")
        case .error(let msg):
            print("错误: \(msg)")
        }
    }
}
```

---

## UIKit 集成

### 基本用法

```swift
import UIKit
import SwiftUI
import KycOnboardingSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureSDK()
    }

    private func configureSDK() {
        let config = KycSDKConfig(
            apiBaseURL: URL(string: "https://api1.artemisdev.cynopsis.co")!,
            crmBaseURL: URL(string: "https://crm-dev.cynopsis.co")!,
            clientId: "your-client-id",
            clientSecret: "your-client-secret",
            domainId: "your-domain-id",
            environment: .development,
            language: .english,
            enableLogging: true,
            livenessRegion: "ap-northeast-1"
        )
        KycOnboarding.configure(config)
    }

    private func setupUI() {
        let button = UIButton(type: .system)
        button.setTitle("开始 KYC 验证", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(startKycTapped), for: .touchUpInside)

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func startKycTapped() {
        Task { @MainActor in
            do {
                let entryView = try await KycOnboarding.shared.createVerificationView(
                    userId: "user-\(UUID().uuidString.prefix(8))",
                    onComplete: { [weak self] result in
                        self?.dismiss(animated: true)
                        self?.handleResult(result)
                    }
                )

                // 将 SwiftUI View 包装为 UIHostingController
                let hostingController = UIHostingController(rootView: entryView)
                hostingController.modalPresentationStyle = .fullScreen
                present(hostingController, animated: true)

            } catch {
                showAlert(title: "错误", message: error.localizedDescription)
            }
        }
    }

    private func handleResult(_ result: KycCompletionResult) {
        switch result {
        case .completed(let id, let type):
            showAlert(title: "成功", message: "验证完成! ID: \(id ?? 0), 类型: \(type.rawValue)")
        case .cancelled:
            showAlert(title: "取消", message: "用户取消了验证")
        case .pendingReview:
            showAlert(title: "待审核", message: "您的申请正在审核中")
        case .error(let message):
            showAlert(title: "错误", message: message)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
```

---

## 常见问题

### Q1: 如何处理权限请求？

SDK 会在需要时自动请求权限。如果您想提前检查/请求权限：

```swift
import AVFoundation
import Photos

func checkPermissions() async -> Bool {
    // 检查相机权限
    let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    if cameraStatus == .notDetermined {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        if !granted { return false }
    } else if cameraStatus != .authorized {
        return false
    }

    // 检查相册权限
    let photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    if photoStatus == .notDetermined {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        if status != .authorized && status != .limited { return false }
    } else if photoStatus != .authorized && photoStatus != .limited {
        return false
    }

    return true
}
```


### Q2: 如何处理网络错误？

```swift
KycOnboarding.shared.createVerificationView(
    userId: "user-123",
    onComplete: { result in
        switch result {
        case .error(let message):
            if message.contains("network") || message.contains("connection") {
                // 网络错误，提示用户检查网络
                showNetworkErrorAlert()
            } else {
                // 其他错误
                showGenericErrorAlert(message)
            }
        default:
            break
        }
    }
)
```

### Q3: 如何恢复之前的会话？

如果用户中途退出，可以通过 `session` 参数恢复：

```swift
// 如果有之前的会话
let previousSession: DigitalOnboardingSession = // 从存储中获取

KycEntryView(
    sdk: KycOnboarding.shared,
    session: previousSession,  // 传入之前的会话
    onComplete: { result in
        // ...
    }
)
```

### Q4: 支持哪些 iOS 版本？

- **最低支持**: iOS 14.0
- **推荐版本**: iOS 16.0+
- **活体检测**: 需要 TrueDepth 相机 (iPhone X 及以上)

---

## 📞 支持

- **Email:** support@cynopsis.com
- **Issues:** https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues
- **文档:** https://docs.cynopsis.com

---

**© 2026 Cynopsis Solutions. All rights reserved.**
