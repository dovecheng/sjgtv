#!/usr/bin/env python3
"""
测试播放页面访问
"""

from appium import webdriver
from appium.options.common.base import AppiumOptions
import subprocess
import time

# 设备配置
DEVICE_ID = "192.168.3.158:5555"
APK_PATH = "/data/home/dove/projects/sjgtv/build/app/outputs/flutter-apk/app-debug.apk"

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

def adb_keycode(keycode):
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", str(keycode)
    ], check=True)

options = AppiumOptions()
options.set_capability("platformName", "Android")
options.set_capability("deviceName", DEVICE_ID)
options.set_capability("app", APK_PATH)
options.set_capability("automationName", "Flutter")
options.set_capability("noReset", True)
options.set_capability("fullReset", False)

try:
    print("正在连接 Appium 服务...")
    driver = webdriver.Remote("http://localhost:4723", options=options)
    print("连接成功！")

    time.sleep(3)

    # 返回首页
    print("\n返回首页...")
    adb_keycode(4)
    time.sleep(1)

    # 截图首页
    print("\n截图首页...")
    adb_screenshot("player_test_home.png")
    print("✓ 首页截图已保存")

    # 点击 Hero 区域的第一部电影
    print("\n点击 Hero 电影...")
    try:
        from appium_flutter_finder.flutter_finder import FlutterFinder
        finder = FlutterFinder().by_value_key("hero_")
        driver.execute_script("flutter:clickElement", finder)
        print("✓ 成功点击 Hero 电影")
    except Exception as e:
        print(f"✗ 点击 Hero 电影失败: {e}")

    time.sleep(2)

    # 截图电影详情页
    print("\n截图电影详情页...")
    adb_screenshot("player_test_detail.png")
    print("✓ 电影详情页截图已保存")

    # 检查是否有选集列表并尝试点击
    print("\n检查是否有选集...")
    try:
        # 尝试点击页面中央区域（可能是选集）
        adb_keycode(23)  # 方向下键，焦点可能移到选集列表
        time.sleep(1)
        
        # 截图检查焦点位置
        adb_screenshot("player_test_focus.png")
        print("✓ 焦点状态截图已保存")
        
        # 尝试按 Enter 进入播放
        adb_keycode(66)
        time.sleep(2)
        
        # 截图播放器页面
        print("\n截图播放器页面...")
        adb_screenshot("player_test_player.png")
        print("✓ 播放器页面截图已保存")
    except Exception as e:
        print(f"✗ 进入播放器失败: {e}")

    driver.quit()
    print("\n测试完成！")

except Exception as e:
    print(f"\n错误: {e}")
    import traceback
    traceback.print_exc()