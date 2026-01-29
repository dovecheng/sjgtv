#!/bin/bash
# macOS 构建依赖

# 以脚本所在目录为基准，避免在 Code Runner 中工作目录不同导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/../macos" || exit
pod install || (rm -f Podfile.lock && pod install --repo-update)
