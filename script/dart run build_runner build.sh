#!/bin/bash
# 第三方插件生成代码

# 以脚本所在目录为基准，避免在 Code Runner 中工作目录不同导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/../base" || exit
echo "cd: $(pwd)"
dart run build_runner build || dart run build_runner build --delete-conflicting-outputs
