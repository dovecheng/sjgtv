#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""使用 Appium Flutter Driver 测试播放页面（正确方式）"""

import time
import subprocess
from appium import webdriver
from appium.options.common.base import AppiumOptions

# 配置
DEVICE_ID = "192.168.3.158:5555"
APPIUM_SERVER = "http://localhost:4723"

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
    print("Appium Flutter Driver 测试")
    print("=" * 60)
    
    print("\n⚠️  重要提示：")
    print("Appium Flutter Driver 需要先启动应用才能连接")
    print("请先运行: flutter run -d 192.168.3.158:5555")
    print("或者使用 flutter drive 启动")
    
    response = input("\n应用是否已启动？(y/n): ")
    if response.lower() != 'y':
        print("\n正在启动应用...")
        # 使用 flutter run 启动应用（会自动启用 Observatory）
        subprocess.Popen([
            "flutter", "run", "-d", DEVICE_ID, "--disable-service-auth-codes"
        ], cwd="/data/home/dove/projects/sjgtv")
        print("等待应用启动（10秒）...")
        time.sleep(10)
    
    print("\n正在连接 Appium 服务...")
    options = AppiumOptions()
    options.set_capability("platformName", "Android")
    options.set_capability("deviceName", DEVICE_ID)
    options.set_capability("automationName", "Flutter")
    options.set_capability("noReset", True)
    options.set_capability("fullReset", False)
    # 不指定 app 路径，让 Appium 连接到已运行的应用

    try:
        driver = webdriver.Remote(APPIUM_SERVER, options=options)
        print(f"✅ Appium 连接成功，Session ID: {driver.session_id}")
    except Exception as e:
        print(f"❌ Appium 连接失败: {e}")
        print("\n可能的原因：")
        print("1. 应用未启动或已崩溃")
        print("2. Dart Observatory 未启用")
        print("3. Appium Flutter Driver 配置错误")
        return

    try:
        # 等待连接稳定
        time.sleep(2)
        
        print("\n步骤 1: 获取 Render Tree")
        try:
            render_tree = driver.execute_script("flutter:getRenderTree")
            with open("/data/home/dove/projects/sjgtv/screenshots/appium_render_tree.txt", "w", encoding="utf-8") as f:
                f.write(render_tree)
            print("✅ Render Tree 已保存")
        except Exception as e:
            print(f"✗ 获取 Render Tree 失败: {e}")
        
        print("\n步骤 2: 使用 Flutter Driver 点击 Hero 区域")
        try:
            # 方式 1: 通过 ValueKey
            hero_element = driver.find_element("flutter key", "hero_1")
            hero_element.click()
            print("✅ 通过 ValueKey 'hero_1' 点击成功")
        except Exception as e:
            print(f"✗ ValueKey 方式失败: {e}")
            # 方式 2: 通过文本
            try:
                hero_text = driver.find_element("flutter text", "你行！你上！")
                hero_text.click()
                print("✅ 通过文本点击成功")
            except Exception as e2:
                print(f"✗ 文本方式也失败: {e2}")
        
        time.sleep(3)
        take_screenshot("appium_step1_hero_clicked")
        
        print("\n步骤 3: 点击搜索结果")
        try:
            result_element = driver.find_element("flutter key", "search_result_0")
            result_element.click()
            print("✅ 点击搜索结果成功")
        except Exception as e:
            print(f"✗ 点击搜索结果失败: {e}")
        
        time.sleep(3)
        take_screenshot("appium_step2_detail_page")
        
        print("\n步骤 4: 查找并点击播放按钮")
        try:
            # 尝试查找"正片"按钮
            play_button = driver.find_element("flutter text", "正片")
            play_button.click()
            print("✅ 点击播放按钮成功")
        except Exception as e:
            print(f"✗ 未找到'正片'按钮: {e}")
        
        time.sleep(3)
        take_screenshot("appium_step3_player_page")
        
        print("\n" + "="*60)
        print("测试完成")
        print("="*60)

    except Exception as e:
        print(f"❌ 测试失败: {e}")
        import traceback
        traceback.print_exc()
    finally:
        try:
            driver.quit()
            print("\n已断开 Appium 连接")
        except:
            pass

if __name__ == "__main__":
    main()