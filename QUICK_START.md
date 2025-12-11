# KycOnboardingSDK - 5分钟快速集成指南

## 🎯 适用场景

- **iOS 原生应用**: 通过 Xcode 直接集成
- **Flutter iOS 插件**: 在 `ios/` 目录中集成

## 📦 集成步骤

### 方式 1: Xcode UI（推荐）

1. **打开 Xcode 项目**
   ```bash
   # iOS 原生项目
   open YourApp.xcodeproj

   # Flutter 项目
   cd your_flutter_project/ios
   open Runner.xcworkspace
   ```

2. **添加包依赖**
   - `File` → `Add Package Dependencies...`
   - 输入仓库 URL:
     ```
     https://github.com/kaifengCynopsis/kyc-onboarding-ios-binary.git
     ```
   - 选择版本: `0.1.0-beta.1-binary`
   - 点击 `Add Package`

3. **等待依赖解析**
   Xcode 会自动下载并安装:
   - ✅ KycOnboardingSDK.xcframework (~60MB)
   - ✅ AWS Amplify Swift 2.42.1
   - ✅ AWS FaceLiveness 1.0.1
   - ✅ Veriff SDK 7.x

4. **开始使用**
   ```swift
   import KycOnboardingSDK

   // 配置 SDK
   let config = KycSDKConfig(
       apiBaseURL: "https://your-api.com",
       clientId: "your-client-id",
       environment: .production
   )

   // 初始化
   let kyc = KycOnboarding(config: config)

   // 启动验证流程
   try await kyc.startVerification()
   ```

### 方式 2: Package.swift

对于 Swift Package 项目:

```swift
dependencies: [
    .package(
        url: "https://github.com/kaifengCynopsis/kyc-onboarding-ios.git",
        exact: "0.1.0-beta.1-binary"
    )
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "KycOnboardingSDK", package: "kyc-onboarding-ios")
        ]
    )
]
```

## ✅ 验证集成

### 1. 检查依赖树

```bash
cd your_project
swift package show-dependencies
```

应该看到:
```
.
└── kyc-onboarding-ios
    ├── amplify-swift (2.42.1)
    ├── amplify-ui-swift-liveness (1.0.1)
    └── veriff-ios-spm (7.x.x)
```

### 2. 测试编译

```bash
# iOS 模拟器
xcodebuild -scheme YourScheme \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build

# 真机
xcodebuild -scheme YourScheme \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  clean build
```

### 3. 测试 import

在任意 Swift 文件中:

```swift
import KycOnboardingSDK
import Amplify
import FaceLiveness
import Veriff

// 所有模块都应该正常 import
```

## ⚠️ 系统要求

- **iOS**: 14.0+
- **Xcode**: 15.x
- **Swift**: 5.9

⚠️ **重要**: 由于 Amplify SDK 限制，必须使用 **Xcode 15.x / Swift 5.9** 编译。

## 🔧 常见问题

### Q1: "No such module 'KycOnboardingSDK'"

**解决方案**: 清除 SPM 缓存

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/org.swift.swiftpm/

# 重新解析包
xcodebuild -resolvePackageDependencies
```

### Q2: Swift version mismatch

**解决方案**: 确保使用 Xcode 15.x

```bash
# 检查当前 Xcode 版本
xcodebuild -version

# 切换到 Xcode 15
sudo xcode-select -s /Applications/Xcode15.app

# 验证 Swift 版本
swift --version  # 应显示 5.9.x
```

### Q3: Checksum verification failed

**原因**: XCFramework 文件损坏或版本不匹配

**解决方案**:
1. 删除 SPM 缓存（见 Q1）
2. 确认使用正确的版本号
3. 检查网络连接，确保能访问 GitHub Release

### Q4: Flutter 项目集成失败

**确认步骤**:
1. 使用 `Runner.xcworkspace` 而非 `.xcodeproj`
2. 在 `Runner` target（不是 `Runner` project）中添加包依赖
3. 确保 Flutter plugin 的 Swift 代码能正常 import

## 📚 完整文档

- **README**: [README.md](./README.md)
- **源码仓库**: https://github.com/kaifengCynopsis/kyc-onboarding-ios
- **问题反馈**: https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues

## 🆘 支持

- **Email**: support@cynopsis.com
- **技术支持**: [GitHub Issues](https://github.com/kaifengCynopsis/kyc-onboarding-ios/issues)

---

**最后更新**: 2024-12-11
