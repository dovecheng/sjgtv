#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""测试 Hero 区域点击和搜索参数传递"""

import time
from appium import webdriver
from appium.options.common.base import AppiumOptions
from appium_flutter_finder.flutter_finder import FlutterFinder

# 配置
DEVICE_ID = "192.168.3.158:5555"
APK_PATH = "/data/home/dove/projects/sjgtv/build/app/outputs/flutter-apk/app-debug.apk"
APPIUM_SERVER = "http://localhost:4723"

print("正在连接 Appium 服务...")

# Appium 配置
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
    exit(1)

finder = FlutterFinder()

try:
    # 等待应用启动
    time.sleep(5)
    print("\n步骤 1: 获取页面元素信息")
    try:
        render_tree = driver.execute_script("flutter:getRenderTree")
        # 保存完整 Render Tree 到文件
        with open("/data/home/dove/projects/sjgtv/screenshots/render_tree.txt", "w", encoding="utf-8") as f:
            f.write(render_tree)
        print("✅ 已保存完整 Render Tree 到 render_tree.txt")

        # 搜索 ValueKey
        if "ValueKey" in render_tree:
            print("\n找到的 ValueKey:")
            import re
            value_keys = re.findall(r'ValueKey\(["\']([^"\']+)["\']\)', render_tree)
            for key in value_keys[:20]:  # 只显示前 20 个
                print(f"  - {key}")
        else:
            print("\n未找到 ValueKey")

    except Exception as e:
        print(f"获取 Render Tree 失败: {e}")

    print("\n步骤 2: 使用 ValueKey 点击 Hero 区域")

    methods_tried = []

    # 先尝试通过文本找到元素，然后获取其父容器的信息
    try:
        hero_element = finder.by_text("你行！你上！")
        print(f"✓ 通过文本找到 Hero 区域元素")

        # 尝试获取元素的祖先信息来找到 Hero Section
        try:
            ancestor = finder.ancestor(
                of=hero_element,
                matching=finder.by_type("HeroSection")
            )
            print(f"✓ 找到 HeroSection")
            driver.execute_script("flutter:clickElement", ancestor)
            print("✅ 通过 HeroSection ValueKey 点击成功")
            methods_tried.append("HeroSection ValueKey点击成功")
        except Exception as e:
            print(f"✗ HeroSection ValueKey 失败: {e}")
            methods_tried.append(f"HeroSection ValueKey失败: {e}")

            # 备用：尝试通过 ValueKey 直接查找
            try:
                hero_key = finder.by_value_key("hero_1")
                print(f"✓ 通过 ValueKey 'hero_1' 找到元素")
                driver.execute_script("flutter:clickElement", hero_key)
                print("✅ 通过 ValueKey 'hero_1' 点击成功")
                methods_tried.append("ValueKey(hero_1)点击成功")
            except Exception as e2:
                print(f"✗ ValueKey 'hero_1' 失败: {e2}")
                methods_tried.append(f"ValueKey('hero_1'失败: {e2}")

    except Exception as e:
        print(f"✗ 通过文本查找失败: {e}")
        methods_tried.append(f"文本查找失败: {e}")

    print(f"\n尝试的方法: {methods_tried}")

    time.sleep(3)

    # 使用 ADB 截图
    import subprocess
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "screencap", "-p", "/sdcard/hero_click_result.png"
    ], check=True, capture_output=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "pull", "/sdcard/hero_click_result.png",
        "/data/home/dove/projects/sjgtv/screenshots/"
    ], check=True, capture_output=True)
    subprocess.run([
        "adb", "-s", DEVICE_ID, "shell", "rm", "/sdcard/hero_click_result.png"
    ], check=True, capture_output=True)
    print("✅ 已保存截图: hero_click_result.png")

    # 检查当前页面
    current_package = driver.current_package
    print(f"当前应用包名: {current_package}")

except Exception as e:
    print(f"❌ 测试失败: {e}")
finally:
    driver.quit()
    print("\n测试结束")