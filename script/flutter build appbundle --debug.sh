#!/bin/bash
# 生成安卓 AAB（debug）

# 以脚本所在目录为基准，避免在 Code Runner 中工作目录不同导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit
flutter build appbundle --debug --verbose
