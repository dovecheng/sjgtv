#!/usr/bin/env python3
"""
Appium Flutter 自动化测试示例

用法：
1. 启动 Appium: appium --port 4723
2. 构建 APK: flutter build apk --debug
3. 运行测试: python3 test_appium.py
"""

from appium import webdriver
from appium.options.common.base import AppiumOptions
import subprocess
import time
import base64
import json

# 设备配置
DEVICE_ID = "192.168.3.158:5555"
APK_PATH = "/data/home/dove/projects/sjgtv/build/app/outputs/flutter-apk/app-debug.apk"

# ADB 截图函数
def adb_screenshot(filename):
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "screencap", "-p", f"/sdcard/{filename}"
    ], check=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "pull", f"/sdcard/{filename}",
        f"/data/home/dove/projects/sjgtv/screenshots/"
    ], check=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "rm", f"/sdcard/{filename}"
    ], check=True)

# ADB 按键函数
def adb_keycode(keycode):
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", str(keycode)
    ], check=True)

# Appium 配置
options = AppiumOptions()
options.set_capability("platformName", "Android")
options.set_capability("deviceName", DEVICE_ID)
options.set_capability("app", APK_PATH)
options.set_capability("automationName", "Flutter")
options.set_capability("noReset", True)  # 不重置应用状态
options.set_capability("fullReset", False)

try:
    # 连接 Appium 服务
    print("正在连接 Appium 服务...")
    driver = webdriver.Remote("http://localhost:4723", options=options)
    print("连接成功！")

    # 等待应用启动
    time.sleep(3)

    # 截图首页
    print("\n截图首页...")
    adb_screenshot("appium_home.png")
    print("✓ 首页截图已保存")

    # 测试 1: 点击搜索按钮（使用 Flutter Driver 命令）
    print("\n测试 1: 点击搜索按钮")
    try:
        from appium_flutter_finder.flutter_finder import FlutterFinder
        finder = FlutterFinder().by_value_key("app_bar_search")
        driver.execute_script("flutter:clickElement", finder)
        print("✓ 成功点击搜索按钮")
    except Exception as e:
        print(f"✗ 点击搜索按钮失败: {e}")

    time.sleep(2)

    # 输入搜索词并执行搜索
    print("\n输入搜索词...")
    try:
        # 使用 ADB 输入搜索词
        subprocess.run([
            "adb", "-s", DEVICE_ID, "shell", "input", "text", "你行！你上！"
        ], check=True)
        time.sleep(1)
        
        # 点击搜索按钮执行搜索
        subprocess.run([
            "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", "66"  # Enter 键
        ], check=True)
        print("✓ 搜索已执行")
    except Exception as e:
        print(f"✗ 搜索失败: {e}")

    time.sleep(3)  # 等待搜索结果加载

    # 截图搜索页
    print("\n截图搜索页...")
    adb_screenshot("appium_search.png")
    print("✓ 搜索页截图已保存")

    # 测试 2: 点击第一个搜索结果（跳转到详情页）
    print("\n测试 2: 点击第一个搜索结果")
    try:
        from appium_flutter_finder.flutter_finder import FlutterFinder
        # 使用通用的 search_result 前缀查找
        finder = FlutterFinder().by_value_key("search_result_")
        driver.execute_script("flutter:clickElement", finder)
        print("✓ 成功点击搜索结果")
    except Exception as e:
        print(f"✗ 点击搜索结果失败: {e}")

    time.sleep(2)

    # 截图电影详情页
    print("\n截图电影详情页...")
    adb_screenshot("appium_detail.png")
    print("✓ 电影详情页截图已保存")

    # 测试 3: 返回首页，点击数据源按钮
    print("\n测试 3: 点击数据源按钮")
    adb_keycode(4)  # 返回键
    time.sleep(1)
    try:
        from appium_flutter_finder.flutter_finder import FlutterFinder
        finder = FlutterFinder().by_value_key("app_bar_source")
        driver.execute_script("flutter:clickElement", finder)
        print("✓ 成功点击数据源按钮")
    except Exception as e:
        print(f"✗ 点击数据源按钮失败: {e}")

    time.sleep(1)

    # 截图数据源页
    print("\n截图数据源页...")
    adb_screenshot("appium_source.png")
    print("✓ 数据源页截图已保存")

    # 测试 4: 点击设置按钮
    print("\n测试 4: 点击设置按钮")
    adb_keycode(4)  # 返回键
    time.sleep(1)
    try:
        from appium_flutter_finder.flutter_finder import FlutterFinder
        finder = FlutterFinder().by_value_key("app_bar_settings")
        driver.execute_script("flutter:clickElement", finder)
        print("✓ 成功点击设置按钮")
    except Exception as e:
        print(f"✗ 点击设置按钮失败: {e}")

    time.sleep(1)

    # 截图设置/二维码页
    print("\n截图设置/二维码页...")
    adb_screenshot("appium_settings.png")
    print("✓ 设置/二维码页截图已保存")

    # 关闭连接
    driver.quit()
    print("\n测试完成！")

except Exception as e:
    print(f"\n错误: {e}")
    import traceback
    traceback.print_exc()