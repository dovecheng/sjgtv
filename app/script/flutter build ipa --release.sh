#!/bin/bash
# 生成苹果 IPA（release）

# 以脚本所在目录为基准，避免在 Code Runner 中工作目录不同导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit
flutter build ipa --release --verbose || exit

buildDir="build/ios"
ipaPath=$(find "$buildDir/ipa" -name "*.ipa" 2>/dev/null | head -1)
name=$(basename "$(pwd)")
version=$(cat < pubspec.yaml | grep "version:" | sed "s/version: *//" | tr -d '\n\r')
date=$(date "+%Y-%m-%d_%H.%M")
renamedFilePath="$buildDir/${name}_v${version}_${date}.ipa"

[ -n "$ipaPath" ] && cp "$ipaPath" "$renamedFilePath" && echo "renamed: $renamedFilePath"
open "$buildDir" 2>/dev/null || true
