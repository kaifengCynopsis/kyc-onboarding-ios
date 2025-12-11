# KycOnboardingSDK 二进制分发 - 发布说明

## 📦 目录内容

### 需要提交到 Git 的文件 (共 7 个)

1. **Package.swift** ⭐
   - SPM 清单文件
   - 包含 binaryTarget 配置
   - Checksum: `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54`

2. **README.md** ⭐
   - 完整的项目文档
   - 包含集成说明和系统要求

3. **QUICK_START.md** ⭐
   - 5分钟快速开始指南
   - 包含常见问题解决

4. **LICENSE** ⭐
   - 专有软件许可协议

5. **Sources/KycOnboardingSDKDependencies/Dependencies.swift** ⭐
   - SPM 依赖包装目标的占位符文件

6. **.gitignore**
   - Git 忽略规则

7. **发布说明.md** (本文件)
   - 发布流程说明

### 需要上传到 GitHub Release 的文件 (不提交到 Git)

8. **KycOnboardingSDK.xcframework.zip** 📦
   - 预构建的 XCFramework 二进制文件
   - 大小: 22 MB
   - Checksum: `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54`

### 辅助脚本 (可选提交)

9. **publish.sh** 🚀
   - 自动化发布脚本（推荐使用！）
   - 一键完成所有操作

10. **deploy.sh**
    - 备用部署脚本

11. **setup-github-auth.sh**
    - GitHub 认证设置辅助脚本

---

## 🚀 发布步骤

### 方式 1: 使用自动化脚本 (推荐) ⭐

只需运行一个命令：

```bash
cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary
./publish.sh
```

脚本会自动完成：
1. ✅ 添加所有文件到 Git
2. ✅ 创建提交
3. ✅ 创建/更新标签
4. ✅ 推送到 GitHub (支持 Token/SSH/CLI 三种认证方式)
5. ✅ 创建 GitHub Release
6. ✅ 上传 XCFramework.zip 到 Release

### 方式 2: 手动操作

如果你想手动控制每一步：

#### 步骤 1: 提交文件

```bash
cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary

# 添加文件
git add Package.swift README.md QUICK_START.md LICENSE .gitignore
git add Sources/KycOnboardingSDKDependencies/Dependencies.swift

# 创建提交
git commit -m "Update binary distribution with new XCFramework

- Updated Package.swift with checksum: e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54
- Updated README.md with installation instructions
- XCFramework size: 22MB
"
```

#### 步骤 2: 创建标签

```bash
# 删除旧标签（如果存在）
git tag -d 0.1.0-beta.1-binary

# 创建新标签
git tag -a 0.1.0-beta.1-binary -m "Binary distribution v0.1.0-beta.1"
```

#### 步骤 3: 推送到 GitHub

```bash
# 使用 Personal Access Token
git push https://YOUR_TOKEN@github.com/kaifengCynopsis/kyc-onboarding-ios.git main
git push https://YOUR_TOKEN@github.com/kaifengCynopsis/kyc-onboarding-ios.git 0.1.0-beta.1-binary

# 或使用 SSH
git push git@github.com:kaifengCynopsis/kyc-onboarding-ios.git main
git push git@github.com:kaifengCynopsis/kyc-onboarding-ios.git 0.1.0-beta.1-binary
```

#### 步骤 4: 创建 GitHub Release

```bash
# 使用 GitHub CLI
gh release create 0.1.0-beta.1 \
  KycOnboardingSDK.xcframework.zip \
  --repo kaifengCynopsis/kyc-onboarding-ios \
  --title "KycOnboardingSDK v0.1.0-beta.1" \
  --notes "Binary distribution with automatic SPM dependencies"

# 或手动上传
# 访问: https://github.com/kaifengCynopsis/kyc-onboarding-ios/releases/new
```

---

## 📊 发布后验证

### 1. 检查 GitHub 仓库

访问: https://github.com/kaifengCynopsis/kyc-onboarding-ios

确认:
- ✅ 主分支包含所有文件
- ✅ 标签 `0.1.0-beta.1-binary` 存在
- ✅ Release `0.1.0-beta.1` 存在并包含 XCFramework.zip

### 2. 测试 SPM 集成

在任意 iOS 项目中：

```
Xcode → File → Add Package Dependencies
Repository: https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
Version: 0.1.0-beta.1-binary
```

应该能看到自动解析以下依赖：
- ✅ KycOnboardingSDK (binary)
- ✅ AWS Amplify Swift 2.42.1
- ✅ AWS FaceLiveness 1.0.1
- ✅ Veriff SDK 7.x

### 3. 测试 Flutter iOS 集成

```bash
cd /path/to/flutter/project/ios
open Runner.xcworkspace

# 在 Xcode 中为 Runner target 添加包依赖
```

---

## 🔑 重要信息

| 项目 | 值 |
|------|-----|
| **GitHub 仓库** | https://github.com/kaifengCynopsis/kyc-onboarding-ios |
| **SPM 标签** | `0.1.0-beta.1-binary` |
| **Release 标签** | `0.1.0-beta.1` |
| **Checksum** | `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54` |
| **文件大小** | 22 MB |
| **Swift 版本** | 5.9 |
| **Xcode 版本** | 15.x |
| **iOS 最低版本** | 14.0+ |

---

## ⚠️ 注意事项

1. **XCFramework.zip 不要提交到 Git**
   - 文件太大 (22 MB)
   - 只上传到 GitHub Release

2. **Checksum 必须匹配**
   - Package.swift 中的 checksum 必须与实际文件一致
   - 当前 checksum: `e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54`

3. **Swift 版本限制**
   - 由于 Amplify SDK 的 `BUILD_LIBRARY_FOR_DISTRIBUTION=NO` 限制
   - 用户必须使用 Xcode 15.x / Swift 5.9

4. **GitHub Release 必须先创建**
   - SPM 需要从 Release 下载 XCFramework
   - 确保 Release tag 和下载 URL 正确

---

## 🆘 故障排查

### 问题 1: Git 推送失败 (认证错误)

**解决方案**:
- 使用 Personal Access Token
- 或配置 SSH 密钥
- 或使用 GitHub CLI (gh)

详见: `./setup-github-auth.sh`

### 问题 2: gh 命令未找到

**解决方案**:

```bash
brew install gh
gh auth login
```

### 问题 3: Release 已存在

**解决方案**:

```bash
# 删除旧 Release
gh release delete 0.1.0-beta.1 --repo kaifengCynopsis/kyc-onboarding-ios --yes

# 重新运行 publish.sh
./publish.sh
```

---

**最后更新**: 2024-12-11
**维护者**: Cynopsis Solutions
