#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""使用 Appium 测试完整的播放页面进入流程"""

import time
import subprocess
from appium import webdriver
from appium.options.common.base import AppiumOptions
from appium_flutter_finder.flutter_finder import FlutterFinder

# 配置
DEVICE_ID = "192.168.3.158:5555"
APK_PATH = "/data/home/dove/projects/sjgtv/build/app/outputs/flutter-apk/app-debug.apk"
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

def adb_keycode(keycode):
    """发送按键事件"""
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "input", "keyevent", str(keycode)
    ], check=True, capture_output=True)

def main():
    print("=" * 60)
    print("Appium 播放页面测试")
    print("=" * 60)
    
    print("\n正在连接 Appium 服务...")
    options = AppiumOptions()
    options.set_capability("platformName", "Android")
    options.set_capability("deviceName", DEVICE_ID)
    options.set_capability("app", APK_PATH)
    options.set_capability("automationName", "Flutter")
    options.set_capability("noReset", True)
    options.set_capability("fullReset", False)

    try:
        driver = webdriver.Remote(APPIUM_SERVER, options=options)
        print(f"✅ Appium 连接成功，Session ID: {driver.session_id}")
    except Exception as e:
        print(f"❌ Appium 连接失败: {e}")
        return

    finder = FlutterFinder()

    try:
        # 等待应用启动
        time.sleep(3)
        print("\n" + "="*60)
        print("步骤 1: 应用启动")
        print("="*60)
        take_screenshot("appium_step1_start")
        
        # 获取 Render Tree 查找可用的 ValueKey
        print("\n" + "="*60)
        print("步骤 2: 分析页面元素")
        print("="*60)
        try:
            render_tree = driver.execute_script("flutter:getRenderTree")
            with open("/data/home/dove/projects/sjgtv/screenshots/render_tree_appium.txt", "w", encoding="utf-8") as f:
                f.write(render_tree)
            print("✅ 已保存 Render Tree 到 render_tree_appium.txt")
            
            # 查找所有 ValueKey
            import re
            value_keys = re.findall(r'ValueKey\(["\']([^"\']+)["\']\)', render_tree)
            print(f"\n找到 {len(value_keys)} 个 ValueKey:")
            for i, key in enumerate(value_keys[:30]):  # 只显示前 30 个
                print(f"  {i+1:2d}. {key}")
        except Exception as e:
            print(f"获取 Render Tree 失败: {e}")

        # 步骤 3: 使用 Appium 点击 Hero 区域
        print("\n" + "="*60)
        print("步骤 3: 点击 Hero 区域")
        print("="*60)
        
        try:
            hero_key = finder.by_value_key("hero_1")
            driver.execute_script("flutter:clickElement", hero_key)
            print("✅ 通过 ValueKey 'hero_1' 点击成功")
        except Exception as e:
            print(f"✗ 通过 ValueKey 失败: {e}")
        
        time.sleep(3)
        take_screenshot("appium_step3_hero_clicked")

        # 步骤 4: 等待搜索结果
        print("\n" + "="*60)
        print("步骤 4: 等待搜索结果")
        print("="*60)
        time.sleep(3)
        take_screenshot("appium_step4_search_results")

        # 步骤 5: 点击搜索结果进入详情页
        print("\n" + "="*60)
        print("步骤 5: 点击搜索结果")
        print("="*60)
        
        try:
            # 尝试点击第一个搜索结果
            result_key = finder.by_value_key("search_result_0")
            driver.execute_script("flutter:clickElement", result_key)
            print("✅ 点击搜索结果成功")
        except Exception as e:
            print(f"✗ 点击搜索结果失败: {e}")
        
        time.sleep(3)
        take_screenshot("appium_step5_detail_page")

        # 步骤 6: 在详情页向下滚动查找播放按钮
        print("\n" + "="*60)
        print("步骤 6: 查找播放按钮")
        print("="*60)
        
        # 先向下滚动几次
        for i in range(3):
            adb_keycode(20)  # KEYCODE_DPAD_DOWN
            time.sleep(0.5)
        
        time.sleep(1)
        take_screenshot("appium_step6_after_scroll")

        # 检查当前页面
        print("\n" + "="*60)
        print("步骤 7: 验证结果")
        print("="*60)
        
        try:
            # 获取当前 Render Tree
            current_tree = driver.execute_script("flutter:getRenderTree")
            
            # 检查是否在播放器页面
            if "FullScreenPlayer" in current_tree:
                print("✅ 成功进入播放器页面！")
            elif "MovieDetail" in current_tree:
                print("⚠️ 仍在详情页")
                # 检查是否有"正片"按钮
                if "正片" in current_tree or "播放" in current_tree:
                    print("✓ 详情页有播放按钮")
                    # 尝试点击
                    try:
                        adb_keycode(66)  # Enter 键
                        time.sleep(2)
                        take_screenshot("appium_step7_after_play_click")
                        print("✅ 点击播放按钮")
                    except Exception as e:
                        print(f"✗ 点击播放按钮失败: {e}")
                else:
                    print("✗ 详情页没有播放按钮（该电影可能没有播放地址）")
            elif "搜索结果" in current_tree:
                print("⚠️ 仍在搜索结果页")
            else:
                print("❓ 无法确定当前页面")
                
        except Exception as e:
            print(f"检查页面状态失败: {e}")

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