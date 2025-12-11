#!/bin/bash

# KycOnboardingSDK Binary Distribution - GitHub 部署脚本
# 此脚本用于将二进制分发包推送到 GitHub

set -e

echo "🚀 准备推送 KycOnboardingSDK 二进制分发包到 GitHub"
echo ""

# 检查当前目录
if [ ! -f "Package.swift" ]; then
    echo "❌ 错误: 请在 kyc-onboarding-ios-binary 目录中运行此脚本"
    exit 1
fi

# 初始化 git 仓库（如果还没有）
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git remote add origin https://github.com/kaifengCynopsis/kyc-onboarding-ios.git
fi

# 创建 .gitignore
echo "📝 创建 .gitignore..."
cat > .gitignore << 'EOF'
# Xcode
.DS_Store
build/
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
*.xccheckout
*.moved-aside
DerivedData
*.hmap
*.ipa
*.xcuserstate

# Swift Package Manager
.swiftpm/
.build/
Packages/
Package.resolved

# CocoaPods
Pods/
*.podspec

# Backup files
*.backup
*~
EOF

# 添加所有文件
echo "📁 添加文件到 Git..."
git add .
git add .gitignore

# 创建提交
echo "💾 创建提交..."
git commit -m "Initial binary distribution release

- Pre-built XCFramework with SPM support
- Automatic dependency resolution (Amplify, Veriff, FaceLiveness)
- iOS 14.0+ support
- Checksum: ac8319a24e2da3242a6a6d1e11098cd6c00876a6a2f5881be2efd5551339730b
"

# 创建标签
VERSION="0.1.0-beta.1-binary"
echo "🏷️  创建版本标签: $VERSION"
git tag -a "$VERSION" -m "Release $VERSION

Binary distribution for KycOnboardingSDK

Features:
- Pre-built XCFramework from GitHub Release
- Automatic dependency resolution via SPM
- Support for iOS 14.0+
- Swift 5.9 / Xcode 15.x requirement

Integration:
Add to Xcode via File → Add Package Dependencies
Repository: https://github.com/kaifengCynopsis/kyc-onboarding-ios-binary.git
Version: $VERSION
"

echo ""
echo "✅ 本地准备完成！"
echo ""
echo "📤 下一步操作："
echo ""
echo "1. 推送到 GitHub 仓库:"
echo "   git push origin main"
echo "   git push origin $VERSION"
echo ""
echo "2. 在 GitHub 上验证:"
echo "   https://github.com/kaifengCynopsis/kyc-onboarding-ios"
echo "   检查 binary 分支和 $VERSION 标签"
echo ""
echo "3. 测试 SPM 集成:"
echo "   Xcode → Add Package Dependency"
echo "   输入: https://github.com/kaifengCynopsis/kyc-onboarding-ios.git"
echo "   选择标签: $VERSION"
echo ""
