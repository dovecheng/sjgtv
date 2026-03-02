#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""使用 Appium Flutter Driver 测试（应用已启动）"""

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
    
    print("\n正在连接 Appium 服务...")
    options = AppiumOptions()
    options.set_capability("platformName", "Android")
    options.set_capability("deviceName", DEVICE_ID)
    options.set_capability("automationName", "Flutter")
    options.set_capability("noReset", True)
    options.set_capability("fullReset", False)

    try:
        driver = webdriver.Remote(APPIUM_SERVER, options=options)
        print(f"✅ Appium 连接成功，Session ID: {driver.session_id}")
    except Exception as e:
        print(f"❌ Appium 连接失败: {e}")
        return

    try:
        # 等待连接稳定
        time.sleep(2)
        
        print("\n步骤 1: 获取 Render Tree")
        try:
            render_tree = driver.execute_script("flutter:getRenderTree")
            print(f"✅ Render Tree 获取成功，长度: {len(render_tree)}")
            
            # 保存到文件
            with open("/data/home/dove/projects/sjgtv/screenshots/appium_working_render_tree.txt", "w", encoding="utf-8") as f:
                f.write(render_tree)
            
            # 查找 ValueKey
            import re
            value_keys = re.findall(r'ValueKey\(["\']([^"\']+)["\']\)', render_tree)
            print(f"\n找到 {len(value_keys)} 个 ValueKey:")
            for i, key in enumerate(value_keys[:20]):
                print(f"  {i+1:2d}. {key}")
        except Exception as e:
            print(f"✗ 获取 Render Tree 失败: {e}")
        
        print("\n步骤 2: 使用 Appium 点击 Hero 区域")
        take_screenshot("appium_working_1_home")
        
        try:
            # 使用 FlutterFinder 查找元素
            from appium_flutter_finder.flutter_finder import FlutterFinder
            finder = FlutterFinder()
            
            # 尝试通过 ValueKey 查找
            hero_key = finder.by_value_key("hero_1")
            driver.execute_script("flutter:clickElement", hero_key)
            print("✅ 通过 ValueKey 'hero_1' 点击成功")
        except Exception as e:
            print(f"✗ ValueKey 方式失败: {e}")
            # 尝试通过文本查找
            try:
                hero_text = finder.by_text("你行！你上！")
                driver.execute_script("flutter:clickElement", hero_text)
                print("✅ 通过文本点击成功")
            except Exception as e2:
                print(f"✗ 文本方式也失败: {e2}")
        
        time.sleep(3)
        take_screenshot("appium_working_2_after_hero_click")
        
        print("\n步骤 3: 点击搜索结果")
        try:
            from appium_flutter_finder.flutter_finder import FlutterFinder
            finder = FlutterFinder()
            result_key = finder.by_value_key("search_result_0")
            driver.execute_script("flutter:clickElement", result_key)
            print("✅ 点击搜索结果成功")
        except Exception as e:
            print(f"✗ 点击搜索结果失败: {e}")
        
        time.sleep(3)
        take_screenshot("appium_working_3_detail_page")
        
        print("\n步骤 4: 查找并点击播放按钮")
        try:
            from appium_flutter_finder.flutter_finder import FlutterFinder
            finder = FlutterFinder()
            play_button = finder.by_text("正片")
            driver.execute_script("flutter:clickElement", play_button)
            print("✅ 点击播放按钮成功")
        except Exception as e:
            print(f"✗ 未找到'正片'按钮: {e}")
        
        time.sleep(3)
        take_screenshot("appium_working_4_player_page")
        
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