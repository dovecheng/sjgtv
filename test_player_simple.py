#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""使用 ADB 和 Appium 结合测试播放页面进入流程"""

import time
import subprocess
from appium import webdriver
from appium.options.common.base import AppiumOptions

# 配置
DEVICE_ID = "192.168.3.158:5555"

def adb_keycode(keycode):
    """发送按键事件"""
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", str(keycode)
    ], check=True, capture_output=True)

def take_screenshot(name):
    """使用 ADB 截图"""
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "screencap", "-p", f"/sdcard/{name}.png"
    ], check=True, capture_output=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "pull", f"/sdcard/{name}.png",
        "/data/home/dove/projects/sjgtv/screenshots/"
    ], check=True, capture_output=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "rm", f"/sdcard/{name}.png"
    ], check=True, capture_output=True)
    print(f"✅ 已保存截图: {name}.png")

def main():
    print("=" * 60)
    print("ADB + Appium 播放页面测试")
    print("=" * 60)
    
    print("\n步骤 1: 应用启动")
    take_screenshot("final_test_1_home")
    
    print("\n步骤 2: 点击 Hero 区域")
    # 使用 ADB 点击 Hero 区域（假设在屏幕中间偏上位置）
    # 屏幕尺寸 1920x1080，Hero 区域大约在 y=300 左右
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "tap", "960", "300"
    ], check=True, capture_output=True)
    print("✅ 点击 Hero 区域")
    
    time.sleep(3)
    take_screenshot("final_test_2_after_click")
    
    print("\n步骤 3: 等待搜索结果")
    time.sleep(2)
    take_screenshot("final_test_3_search_result")
    
    print("\n步骤 4: 点击搜索结果（第一个）")
    # 点击第一个搜索结果卡片
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "tap", "960", "500"
    ], check=True, capture_output=True)
    print("✅ 点击搜索结果")
    
    time.sleep(3)
    take_screenshot("final_test_4_detail_page")
    
    print("\n步骤 5: 向下滚动查找播放按钮")
    # 向下滚动几次
    for i in range(3):
        adb_keycode(20)  # KEYCODE_DPAD_DOWN
        time.sleep(0.5)
    
    time.sleep(1)
    take_screenshot("final_test_5_after_scroll")
    
    print("\n步骤 6: 点击播放按钮（Enter 键）")
    adb_keycode(66)  # Enter 键
    print("✅ 点击播放按钮")
    
    time.sleep(3)
    take_screenshot("final_test_6_player_page")
    
    print("\n步骤 7: 验证结果")
    # 使用 ADB 检查当前页面
    result = subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "dumpsys", "window", "grep", "mCurrentFocus"
    ], capture_output=True, text=True)
    
    if "FullScreenPlayer" in result.stdout:
        print("✅ 成功进入播放器页面！")
    else:
        print(f"⚠️ 当前页面: {result.stdout}")
    
    print("\n" + "="*60)
    print("测试完成")
    print("="*60)

if __name__ == "__main__":
    main()