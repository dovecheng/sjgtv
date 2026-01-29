#!/bin/bash
# 生成安卓 Apk 安装包（release）

# 以脚本所在目录为基准，避免在 Code Runner 中工作目录不同导致路径错误
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/.." || exit
flutter build apk --release --verbose || exit

buildDir="build/app/outputs/flutter-apk"
buildFilePath="$buildDir/app-release.apk"
name=$(basename "$(pwd)")
version=$(cat < pubspec.yaml | grep "version:" | sed "s/version: *//" | tr -d '\n\r')
date=$(date "+%Y-%m-%d_%H.%M")
renamedFilePath="$buildDir/${name}_v${version}_${date}.apk"

cp "$buildFilePath" "$renamedFilePath"
open "$buildDir" 2>/dev/null || explorer $(echo "$buildDir" | sed "s/\//\\\\/g") 2>/dev/null || xdg-open "$buildDir" 2>/dev/null

echo "build info: "
echo "name: '$name' version: '$version' date: '$date'"
echo "buildDir: file://$(pwd)/$buildDir"
echo "renamedFilePath: file://$(pwd)/$renamedFilePath"
