#!/bin/bash

# AHappyCoderDay 构建脚本
echo "🚀 开始构建 AHappyCoderDay..."

# 检查 Xcode 是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未找到 xcodebuild，请确保已安装 Xcode"
    exit 1
fi

# 清理构建目录
echo "🧹 清理构建缓存..."
xcodebuild clean -project AHappyCoderDay.xcodeproj -scheme AHappyCoderDay

# 构建项目
echo "🔨 构建项目..."
xcodebuild build -project AHappyCoderDay.xcodeproj -scheme AHappyCoderDay -destination "platform=macOS"

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
    echo "📱 可以在 Xcode 中运行应用了"
else
    echo "❌ 构建失败，请检查错误信息"
    exit 1
fi