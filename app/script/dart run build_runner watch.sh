#!/bin/bash
# 第三方插件持续观察生成代码

# 以脚本所在目录为基准，避免在不同工作目录下执行导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit
dart run build_runner watch || dart run build_runner watch --delete-conflicting-outputs
