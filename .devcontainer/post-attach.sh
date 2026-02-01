#!/bin/bash
set -e

# 获取当前项目目录名
PROJECT_DIR="/workspaces/$(basename "$(dirname "$(dirname "$(realpath "$0")")")")"
echo "检测项目目录"
echo "项目路径: $PROJECT_DIR"

# 设置目录权限
echo "设置目录权限"
# 移除 sudo 命令，因为容器内通常不需要
chown -R ${USER}:${USER} /home/${USER}/.cache/ 2>/dev/null || true
chown -R ${USER}:${USER} "$PROJECT_DIR" 2>/dev/null || true
echo "目录权限设置完成"

# Ensure correct JAVA_HOME is set
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "JAVA_HOME set to: $JAVA_HOME"

# Run flutter pub get for each Flutter project
echo "Running flutter pub get for all Flutter projects..."

# Check if we're in a Flutter project directory
if [ -f "pubspec.yaml" ]; then
    echo "Running flutter pub get in current directory..."
    flutter pub get
else
    # Run flutter pub get for each Flutter project in subdirectories
    for dir in base essence purtato; do
        if [ -d "$dir" ] && [ -f "$dir/pubspec.yaml" ]; then
            echo "Running flutter pub get in $dir..."
            cd "$dir"
            flutter pub get
            cd ..
        fi
    done
fi

echo "Flutter pub get completed for all projects."
