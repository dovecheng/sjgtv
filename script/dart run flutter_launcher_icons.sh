#!/bin/bash
# 生成各平台应用启动图标（基于 assets/icon/icon.png）

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.." || exit
dart run flutter_launcher_icons
