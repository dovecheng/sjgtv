# Appium Flutter 自动化测试指南

## 环境要求

- Node.js v24.13.0 ✓
- Python 3.12.3 ✓
- Appium 3.2.0 ✓
- Appium Flutter Driver ✓
- Appium-Python-Client 5.2.6 ✓
- Flutter integration_test ✓

## 已安装组件

```bash
# Appium Server
npm install -g appium
# Appium Flutter Driver
npm install -g appium-flutter-driver
# Python 客户端
pip3 install --break-system-packages Appium-Python-Client
```

## 使用步骤

### 1. 构建 APK

```bash
cd /data/home/dove/projects/sjgtv

# 方式 1: 标准构建（用于功能测试）
flutter build apk --debug

# 方式 2: 支持 Appium Flutter Driver 的构建（需要 Dart Observatory）
# 先安装应用并启动，然后获取 Observatory URL
flutter run -d 192.168.3.158:5555
```

### 2. 启动 Appium 服务

```bash
# 方式 1: 直接启动
appium --port 4723 --relaxed-security --use-drivers appium-flutter-driver

# 方式 2: 使用脚本
./start_appium.sh
```

### 3. 运行测试

```bash
python3 test_appium.py
```

## 已添加的 ValueKey

| Key 位置 | 用途 |
|---------|------|
| `app_bar_search` | 搜索按钮 |
| `app_bar_source` | 数据源管理按钮 |
| `app_bar_settings` | 设置按钮 |
| `search_result_{id}` | 搜索结果卡片 |
| `movie_card_{id}` | 电影卡片（首页网格） |
| `hero_{id}` | Hero 横幅推荐区域 |
| `youtube_movie_card_{id}` | YouTube TV 电影卡片 |
| `category_{name}` | 分类标签 |
| `history_{id}` | 观看历史项 |
| `history_delete` | 删除历史按钮 |

## Appium 查找方式

### 通过 Key
```python
driver.find_element("flutter key", "app_bar_search")
```

### 通过文本
```python
driver.find_element("flutter text", "搜索")
```

### 通过类型
```python
driver.find_element("flutter type", "IconButton")
```

## 常用操作

```python
# 点击
element.click()

# 输入文本
element.send_keys("搜索词")

# 截图
driver.save_screenshot("screenshot.png")

# 返回
driver.back()

# 关闭
driver.quit()
```

## 设备信息

- IP: 192.168.3.158
- 端口: 5555
- 包名: com.sjg.tv