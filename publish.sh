#!/bin/bash

# KycOnboardingSDK 二进制分发 - 自动发布脚本
# 此脚本将：
# 1. 提交所有文件到 Git
# 2. 推送到 GitHub
# 3. 创建 GitHub Release
# 4. 上传 XCFramework.zip 到 Release

set -e

echo "🚀 KycOnboardingSDK 二进制分发 - 自动发布"
echo "========================================"
echo ""

# 检查当前目录
if [ ! -f "Package.swift" ]; then
    echo "❌ 错误: 请在 kyc-onboarding-ios-binary 目录中运行此脚本"
    exit 1
fi

# 检查 XCFramework 文件
if [ ! -f "KycOnboardingSDK.xcframework.zip" ]; then
    echo "❌ 错误: 找不到 KycOnboardingSDK.xcframework.zip"
    exit 1
fi

# 配置
REPO="kaifengCynopsis/kyc-onboarding-ios"
VERSION="0.1.0-beta.1-binary"
RELEASE_TAG="0.1.0-beta.1"
CHECKSUM="e19c59cfe4aa5f12399d0fa4f3560b6ad9f32ea05878280b47aaa088f8975b54"

echo "📋 发布配置"
echo "仓库: $REPO"
echo "SPM 标签: $VERSION"
echo "Release 标签: $RELEASE_TAG"
echo "Checksum: $CHECKSUM"
echo ""

# 步骤 1: 添加文件到 Git
echo "📝 步骤 1: 添加文件到 Git..."
git add Package.swift
git add README.md
git add QUICK_START.md
git add LICENSE
git add .gitignore
git add Sources/KycOnboardingSDKDependencies/Dependencies.swift

echo "✅ 文件已添加"
echo ""

# 步骤 2: 创建提交
echo "💾 步骤 2: 创建提交..."
git commit -m "Update binary distribution with new XCFramework

- Updated Package.swift with new checksum
- Updated README.md with new checksum
- XCFramework checksum: $CHECKSUM
- File size: 22MB
- Built with Xcode 15.x / Swift 5.9
" || echo "没有需要提交的更改"

echo "✅ 提交已创建"
echo ""

# 步骤 3: 删除旧标签（如果存在）
echo "🏷️  步骤 3: 管理 Git 标签..."
if git tag -l | grep -q "^$VERSION$"; then
    echo "删除旧标签: $VERSION"
    git tag -d "$VERSION"
fi

# 创建新标签
git tag -a "$VERSION" -m "Release $VERSION

Binary distribution for KycOnboardingSDK

Features:
- Pre-built XCFramework from GitHub Release
- Automatic dependency resolution via SPM
- Support for iOS 14.0+
- Swift 5.9 / Xcode 15.x requirement

Integration:
Add to Xcode via File → Add Package Dependencies
Repository: https://github.com/$REPO.git
Version: $VERSION

Checksum: $CHECKSUM
"

echo "✅ 标签已创建: $VERSION"
echo ""

# 步骤 4: 推送到 GitHub
echo "📤 步骤 4: 推送到 GitHub..."
echo ""
echo "⚠️  需要认证！"
echo ""
echo "请选择认证方式:"
echo "1. Personal Access Token"
echo "2. SSH Key"
echo "3. GitHub CLI (gh)"
echo ""
read -p "请选择 (1/2/3): " auth_choice

case $auth_choice in
    1)
        echo ""
        read -p "请输入 GitHub Personal Access Token: " TOKEN
        echo ""
        echo "推送 main 分支..."
        git push https://$TOKEN@github.com/$REPO.git main
        echo ""
        echo "推送标签..."
        git push https://$TOKEN@github.com/$REPO.git $VERSION
        ;;
    2)
        echo ""
        echo "推送 main 分支..."
        git push git@github.com:$REPO.git main
        echo ""
        echo "推送标签..."
        git push git@github.com:$REPO.git $VERSION
        ;;
    3)
        echo ""
        echo "推送 main 分支..."
        gh repo set-default $REPO
        git push origin main
        echo ""
        echo "推送标签..."
        git push origin $VERSION
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo "✅ 推送完成"
echo ""

# 步骤 5: 创建 GitHub Release
echo "📦 步骤 5: 创建 GitHub Release..."
echo ""

# 检查是否安装了 gh
if ! command -v gh &> /dev/null; then
    echo "❌ 错误: 未安装 GitHub CLI (gh)"
    echo ""
    echo "请选择:"
    echo "1. 安装 GitHub CLI: brew install gh"
    echo "2. 手动创建 Release:"
    echo "   访问: https://github.com/$REPO/releases/new"
    echo "   Tag: $RELEASE_TAG"
    echo "   上传: KycOnboardingSDK.xcframework.zip"
    exit 1
fi

# 检查 Release 是否已存在
if gh release view $RELEASE_TAG --repo $REPO &> /dev/null; then
    echo "⚠️  Release $RELEASE_TAG 已存在"
    echo ""
    read -p "是否删除并重新创建? (y/n): " recreate
    if [ "$recreate" = "y" ]; then
        echo "删除旧 Release..."
        gh release delete $RELEASE_TAG --repo $REPO --yes
    else
        echo "跳过 Release 创建"
        echo ""
        echo "手动上传 XCFramework:"
        echo "gh release upload $RELEASE_TAG KycOnboardingSDK.xcframework.zip --repo $REPO"
        exit 0
    fi
fi

# 创建 Release 并上传文件
echo "创建 Release 并上传 XCFramework..."
gh release create $RELEASE_TAG \
  KycOnboardingSDK.xcframework.zip \
  --repo $REPO \
  --title "KycOnboardingSDK v$RELEASE_TAG - Binary Distribution" \
  --notes "## KycOnboardingSDK Binary Distribution

### 📦 Installation

#### Swift Package Manager (Recommended)

\`\`\`
Xcode → File → Add Package Dependencies
Repository: https://github.com/$REPO.git
Version: $VERSION
\`\`\`

All dependencies (Amplify, Veriff, FaceLiveness) will be automatically installed.

#### Manual Download

Download: [KycOnboardingSDK.xcframework.zip](https://github.com/$REPO/releases/download/$RELEASE_TAG/KycOnboardingSDK.xcframework.zip)

**Checksum:** \`$CHECKSUM\`

### 📋 Requirements

- iOS 14.0+
- Xcode 15.x
- Swift 5.9

### 🔧 Dependencies (Auto-installed)

- AWS Amplify Swift 2.42.1
- AWS FaceLiveness 1.0.1
- Veriff SDK 7.x

### ⚠️ Known Limitations

- Built with Swift 5.9 / Xcode 15.x
- Requires same version in consuming projects
- Due to Amplify SDK's \`BUILD_LIBRARY_FOR_DISTRIBUTION=NO\` constraint

### 📚 Documentation

- [README](https://github.com/$REPO/blob/$VERSION/README.md)
- [Quick Start Guide](https://github.com/$REPO/blob/$VERSION/QUICK_START.md)
"

echo ""
echo "✅ Release 创建完成"
echo ""

# 完成
echo "🎉 发布完成！"
echo "========================================"
echo ""
echo "📊 发布信息"
echo "仓库: https://github.com/$REPO"
echo "SPM 标签: $VERSION"
echo "Release: https://github.com/$REPO/releases/tag/$RELEASE_TAG"
echo ""
echo "🧪 下一步: 在 Flutter 项目中测试"
echo "1. cd /path/to/flutter/project/ios"
echo "2. open Runner.xcworkspace"
echo "3. Add Package Dependency: https://github.com/$REPO.git"
echo "4. Select version: $VERSION"
echo ""
