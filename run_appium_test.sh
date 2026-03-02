#!/bin/bash
# 完整的 Appium 测试流程

set -e

echo "========================================"
echo "Appium Flutter Driver 测试"
echo "========================================"

DEVICE_ID="192.168.3.158:5555"

# 1. 检查 Appium 服务
echo ""
echo "步骤 1: 检查 Appium 服务..."
if ! pgrep -f appium > /dev/null; then
    echo "❌ Appium 服务未运行"
    echo "请先运行: ./start_appium.sh"
    exit 1
fi
echo "✅ Appium 服务正在运行"

# 2. 检查并停止已运行的应用
echo ""
echo "步骤 2: 检查已运行的应用..."
adb -s $DEVICE_ID shell am force-stop com.sjg.tv || true
echo "✅ 已停止旧应用实例"

# 3. 使用 flutter run 启动应用（后台运行）
echo ""
echo "步骤 3: 启动应用..."
nohup flutter run -d $DEVICE_ID --disable-service-auth-codes > /data/home/dove/projects/sjgtv/flutter_run.log 2>&1 &
FLUTTER_PID=$!
echo "Flutter 进程 PID: $FLUTTER_PID"

# 等待应用启动并获取 Observatory URL
echo "等待应用启动（15秒）..."
sleep 15

# 检查应用是否成功启动
if ! adb -s $DEVICE_ID shell dumpsys window | grep -q "com.sjg.tv"; then
    echo "❌ 应用启动失败"
    tail -50 /data/home/dove/projects/sjgtv/flutter_run.log
    exit 1
fi

echo "✅ 应用已启动"

# 4. 运行 Appium 测试
echo ""
echo "步骤 4: 运行 Appium 测试..."
python3 /data/home/dove/projects/sjgtv/test_player_appium_real.py

# 5. 清理
echo ""
echo "步骤 5: 清理..."
kill $FLUTTER_PID 2>/dev/null || true
echo "✅ 已停止 Flutter 进程"

echo ""
echo "========================================"
echo "测试完成"
echo "========================================"