#!/bin/bash

# GitHub 认证设置助手
# 此脚本帮助你配置 GitHub 认证以推送代码

set -e

echo "🔐 GitHub 认证设置助手"
echo "===================="
echo ""
echo "GitHub 不再支持密码认证，你需要选择以下认证方式之一："
echo ""
echo "1. 使用 Personal Access Token (PAT) - 快速简单 ⭐推荐"
echo "2. 使用 SSH 密钥 - 长期使用更安全"
echo "3. 使用 GitHub CLI (gh) - 最简单的方式"
echo ""
read -p "请选择 (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "📝 方案 1: Personal Access Token"
        echo "================================"
        echo ""
        echo "步骤 1: 创建 Token"
        echo "  1. 访问: https://github.com/settings/tokens"
        echo "  2. 点击 'Generate new token' → 'Generate new token (classic)'"
        echo "  3. 配置:"
        echo "     - Note: kyc-onboarding-ios binary distribution"
        echo "     - Expiration: 90 days"
        echo "     - Select scopes: ✅ repo"
        echo "  4. 生成并复制 Token"
        echo ""
        read -p "已创建 Token？按回车继续..."
        echo ""
        echo "步骤 2: 配置 Git 凭据"
        cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary
        git config credential.helper store
        echo ""
        echo "✅ 凭据管理器已配置"
        echo ""
        echo "步骤 3: 推送到 GitHub"
        echo "执行 'git push origin main' 时:"
        echo "  Username: kaifengCynopsis"
        echo "  Password: [粘贴你的 Token]"
        echo ""
        echo "Token 会被安全保存，下次无需重新输入"
        ;;

    2)
        echo ""
        echo "🔑 方案 2: SSH 密钥"
        echo "=================="
        echo ""
        echo "步骤 1: 生成 SSH 密钥"
        read -p "按回车生成新的 SSH 密钥..."
        ssh-keygen -t ed25519 -C "kaifengCynopsis@github.com" -f ~/.ssh/id_ed25519
        echo ""
        echo "✅ SSH 密钥已生成"
        echo ""

        echo "步骤 2: 启动 SSH Agent"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        echo "✅ SSH 密钥已添加到 Agent"
        echo ""

        echo "步骤 3: 复制公钥到 GitHub"
        pbcopy < ~/.ssh/id_ed25519.pub
        echo "✅ 公钥已复制到剪贴板"
        echo ""
        echo "现在请:"
        echo "  1. 访问: https://github.com/settings/keys"
        echo "  2. 点击 'New SSH key'"
        echo "  3. Title: KYC Onboarding iOS Binary"
        echo "  4. Key: 粘贴 (已在剪贴板中)"
        echo "  5. 点击 'Add SSH key'"
        echo ""
        read -p "已添加公钥到 GitHub？按回车继续..."

        echo ""
        echo "步骤 4: 修改 Git 远程 URL 为 SSH"
        cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary
        git remote set-url origin git@github.com:kaifengCynopsis/kyc-onboarding-ios.git
        echo "✅ 远程 URL 已更新为 SSH"
        echo ""
        echo "现在可以直接推送:"
        echo "  git push origin main"
        echo "  git push origin 0.1.0-beta.1-binary"
        ;;

    3)
        echo ""
        echo "🚀 方案 3: GitHub CLI"
        echo "===================="
        echo ""

        # 检查是否安装了 gh
        if command -v gh &> /dev/null; then
            echo "✅ GitHub CLI 已安装"
        else
            echo "📦 安装 GitHub CLI..."
            if command -v brew &> /dev/null; then
                brew install gh
            else
                echo "❌ 未找到 Homebrew，请手动安装:"
                echo "   访问: https://cli.github.com/"
                exit 1
            fi
        fi

        echo ""
        echo "步骤 1: 登录 GitHub"
        gh auth login

        echo ""
        echo "步骤 2: 配置 Git 使用 GitHub CLI"
        gh auth setup-git

        echo ""
        echo "✅ GitHub CLI 已配置完成"
        echo ""
        echo "现在可以直接推送:"
        echo "  cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary"
        echo "  git push origin main"
        echo "  git push origin 0.1.0-beta.1-binary"
        ;;

    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "🎉 设置完成！"
echo ""
echo "📤 下一步: 推送到 GitHub"
echo "========================"
echo ""
echo "cd /Users/jackliang/Documents/GitHub/kyc-onboarding-ios-binary"
echo "git push origin main"
echo "git push origin 0.1.0-beta.1-binary"
echo ""
