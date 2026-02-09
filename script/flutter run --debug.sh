#!/bin/bash
# 以脚本所在目录为基准，避免在不同工作目录下执行导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit
flutter run --debug
