#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""完整的播放页面测试流程"""

import time
import subprocess

# 配置
DEVICE_ID = "192.168.3.158:5555"

def adb_keycode(keycode):
    """发送按键事件"""
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", str(keycode)
    ], check=True, capture_output=True)

def adb_tap(x, y):
    """点击屏幕坐标"""
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "tap", str(x), str(y)
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
    print("完整播放页面测试")
    print("=" * 60)
    
    print("\n步骤 1: 首页")
    take_screenshot("complete_1_home")
    
    print("\n步骤 2: 点击 Hero 区域")
    adb_tap(960, 300)
    print("✅ 点击 Hero 区域")
    time.sleep(3)
    take_screenshot("complete_2_after_hero_click")
    
    print("\n步骤 3: 等待搜索结果")
    time.sleep(2)
    take_screenshot("complete_3_search_result")
    
    print("\n步骤 4: 点击第一个搜索结果")
    adb_tap(960, 500)
    print("✅ 点击搜索结果")
    time.sleep(3)
    take_screenshot("complete_4_detail_page")
    
    print("\n步骤 5: 向下滚动到'正片'按钮")
    # 根据截图分析，"正片"按钮在页面底部
    for i in range(5):
        adb_keycode(20)  # KEYCODE_DPAD_DOWN
        time.sleep(0.3)
    
    time.sleep(1)
    take_screenshot("complete_5_after_scroll")
    
    print("\n步骤 6: 尝试多种方式点击'正片'按钮")
    
    # 方式 1: 直接点击按钮位置（基于截图估算）
    print("  尝试 1: 直接点击'正片'按钮位置")
    adb_tap(960, 900)
    time.sleep(2)
    take_screenshot("complete_6_after_tap_1")
    
    # 检查是否进入播放器
    result = subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "dumpsys", "window"
    ], capture_output=True, text=True)
    
    if "播放" in result.stdout or "player" in result.stdout.lower():
        print("✅ 成功进入播放器页面！")
        take_screenshot("complete_7_player_success")
        return
    
    # 方式 2: 向下键移动到按钮，然后 Enter
    print("  尝试 2: 向下键 + Enter")
    adb_keycode(20)  # KEYCODE_DPAD_DOWN
    time.sleep(0.5)
    adb_keycode(66)  # Enter
    time.sleep(2)
    take_screenshot("complete_7_after_enter")
    
    # 再次检查
    result = subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "dumpsys", "window"
    ], capture_output=True, text=True)
    
    if "播放" in result.stdout or "player" in result.stdout.lower():
        print("✅ 成功进入播放器页面！")
        take_screenshot("complete_8_player_success")
        return
    
    print("\n步骤 7: 最终验证")
    take_screenshot("complete_final_state")
    
    print("\n" + "="*60)
    print("测试完成")
    print("="*60)
    print("\n提示：如果未能进入播放器，可能是因为：")
    print("  1. 该电影没有有效的播放地址")
    print("  2. 需要其他类型的点击操作")
    print("  3. 需要先选择其他电影")

if __name__ == "__main__":
    main()