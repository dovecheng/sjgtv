# 多平台适配方案（TV、手机、平板）

## 📋 需求概述

将当前的 Flutter TV 应用适配到手机和平板平台，支持：
- **TV**: 横屏全屏，遥控器导航
- **平板**: 横屏优先，支持竖屏，触摸+可选键盘/遥控器
- **手机**: 竖屏为主，支持横屏，纯触摸操作

## 🎯 核心目标

1. **设备检测**: 自动识别设备类型（TV、平板、手机）
2. **响应式布局**: 根据设备和屏幕方向调整 UI
3. **导航适配**: 支持多种输入方式（遥控器、触摸、键盘）
4. **性能优化**: 针对不同设备优化资源使用

## 🏗️ 技术方案

### 1. 设备检测策略

#### 1.1 设备类型判断

```dart
enum DeviceType {
  tv,        // 电视：遥控器导航，全屏
  tablet,    // 平板：触摸优先，可横竖屏
  phone,     // 手机：触摸，竖屏为主
}

enum ScreenOrientation {
  portrait,  // 竖屏
  landscape, // 横屏
}

class DeviceInfo {
  static DeviceType get deviceType {
    // 方案 1: 基于屏幕尺寸判断
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;
    
    // TV 特征：大尺寸 + 16:9 宽高比
    if (size.shortestSide >= 700 && aspectRatio >= 1.7) {
      return DeviceType.tv;
    }
    
    // 平板特征：中等尺寸（7-13 英寸）
    if (size.shortestSide >= 600) {
      return DeviceType.tablet;
    }
    
    // 手机
    return DeviceType.phone;
  }
  
  static ScreenOrientation get orientation {
    final size = MediaQuery.of(context).size;
    return size.width > size.height 
        ? ScreenOrientation.landscape 
        : ScreenOrientation.portrait;
  }
}
```

#### 1.2 平台特定检测

```dart
// 使用 package_info_plus 和 platform_detect
import 'package:platform_detect/platform_detect.dart';

class PlatformInfo {
  static bool get isAndroidTV {
    return Platform.isAndroid && 
           defaultTargetPlatform == TargetPlatform.android &&
           // 检查是否在电视设备上运行
           MediaQuery.of(context).size.shortestSide >= 700;
  }
  
  static bool get isWebTV {
    // Web TV 检测（如 Android TV Web 版）
    return Platform.isWeb && 
           MediaQuery.of(context).size.shortestSide >= 700;
  }
}
```

### 2. 响应式布局系统

#### 2.1 布局断点系统

```dart
class LayoutBreakpoints {
  // 手机竖屏
  static const double phonePortrait = 400;  // max width
  
  // 手机横屏 / 小平板竖屏
  static const double phoneLandscape = 700;
  
  // 平板横屏 / 小 TV
  static const double tabletPortrait = 900;
  
  // 平板横屏 / TV
  static const double tabletLandscape = 1200;
  
  // 大 TV
  static const double tv = 1920;
}

class ResponsiveLayout {
  static LayoutType getLayoutType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < LayoutBreakpoints.phonePortrait) {
      return LayoutType.phonePortrait;
    } else if (width < LayoutBreakpoints.phoneLandscape) {
      return LayoutType.phoneLandscape;
    } else if (width < LayoutBreakpoints.tabletPortrait) {
      return LayoutType.tabletPortrait;
    } else if (width < LayoutBreakpoints.tabletLandscape) {
      return LayoutType.tabletLandscape;
    } else {
      return LayoutType.tv;
    }
  }
}

enum LayoutType {
  phonePortrait,    // 手机竖屏
  phoneLandscape,   // 手机横屏
  tabletPortrait,   // 平板竖屏
  tabletLandscape,  // 平板横屏
  tv,               // TV
}
```

#### 2.2 响应式 Grid 系统

```dart
class ResponsiveGrid {
  static int getGridColumns(BuildContext context) {
    final layout = ResponsiveLayout.getLayoutType(context);
    
    switch (layout) {
      case LayoutType.phonePortrait:
        return 2;  // 2 列
      case LayoutType.phoneLandscape:
        return 3;  // 3 列
      case LayoutType.tabletPortrait:
        return 4;  // 4 列
      case LayoutType.tabletLandscape:
        return 5;  // 5 列
      case LayoutType.tv:
        return 6;  // 6 列
    }
  }
  
  static double getAspectRatio(BuildContext context) {
    final layout = ResponsiveLayout.getLayoutType(context);
    
    switch (layout) {
      case LayoutType.phonePortrait:
        return 2 / 3;  // 竖屏海报比例
      case LayoutType.phoneLandscape:
        return 16 / 9;
      case LayoutType.tabletPortrait:
        return 2 / 3;
      case LayoutType.tabletLandscape:
      case LayoutType.tv:
        return 16 / 9;
    }
  }
}
```

### 3. 导航系统适配

#### 3.1 输入方式检测

```dart
enum InputMethod {
  remote,    // 遥控器（TV）
  touch,     // 触摸（手机/平板）
  keyboard,  // 键盘（PC/平板）
  mouse,     // 鼠标（PC）
}

class InputDetector {
  static InputMethod detectInputMethod(BuildContext context) {
    // 检测平台
    if (Platform.isAndroidTV || Platform.isWebTV) {
      return InputMethod.remote;
    }
    
    // 检测是否有键盘/鼠标
    if (Platform.isAndroid || Platform.isIOS) {
      return InputMethod.touch;
    }
    
    return InputMethod.keyboard;
  }
  
  static bool shouldShowTVNavigation(BuildContext context) {
    return detectInputMethod(context) == InputMethod.remote;
  }
  
  static bool shouldShowBottomNavigation(BuildContext context) {
    return detectInputMethod(context) == InputMethod.touch;
  }
}
```

#### 3.2 响应式导航栏

```dart
class AdaptiveNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputMethod = InputDetector.detectInputMethod(context);
    
    if (inputMethod == InputMethod.remote) {
      // TV: 顶部导航（横向滚动）
      return _TVNavigationBar();
    } else {
      // 手机/平板: 底部导航栏
      return _BottomNavigationBar();
    }
  }
}

class _TVNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 分类标签
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
        BottomNavigationBarItem(icon: Icons.search), label: '搜索'),
        BottomNavigationBarItem(icon: Icons.favorite), label: '收藏'),
        BottomNavigationBarItem(icon: Icons.history), label: '历史'),
        BottomNavigationBarItem(icon: Icons.settings), label: '设置'),
      ],
    );
  }
}
```

### 4. 布局适配方案

#### 4.1 电影卡片适配

```dart
class AdaptiveMovieCard extends StatelessWidget {
  final MovieModel movie;
  
  @override
  Widget build(BuildContext context) {
    final layout = ResponsiveLayout.getLayoutType(context);
    final columns = ResponsiveGrid.getGridColumns(context);
    final aspectRatio = ResponsiveGrid.getAspectRatio(context);
    
    final cardWidth = (MediaQuery.of(context).size.width - padding) / columns;
    final cardHeight = cardWidth / aspectRatio;
    
    switch (layout) {
      case LayoutType.phonePortrait:
        return _PhonePortraitCard(movie, cardWidth, cardHeight);
      case LayoutType.phoneLandscape:
      case LayoutType.tabletLandscape:
      case LayoutType.tv:
        return _LandscapeCard(movie, cardWidth, cardHeight);
      case LayoutType.tabletPortrait:
        return _TabletPortraitCard(movie, cardWidth, cardHeight);
    }
  }
}
```

#### 4.2 页面布局适配

```dart
class AdaptiveHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = ResponsiveLayout.getLayoutType(context);
    
    switch (layout) {
      case LayoutType.tv:
        return _TVLayout();
      case LayoutType.tabletLandscape:
        return _TabletLandscapeLayout();
      case LayoutType.tabletPortrait:
        return _TabletPortraitLayout();
      case LayoutType.phoneLandscape:
        return _PhoneLandscapeLayout();
      case LayoutType.phonePortrait:
        return _PhonePortraitLayout();
    }
  }
}

// TV 布局：顶部导航 + Hero Banner + 横向滚动内容
Widget _TVLayout() {
  return Column(
    children: [
      _TVNavigationBar(),
      _HeroBanner(),
      Expanded(
        child: ListView(
          children: [
            _MovieRow(title: '热门'),
            _MovieRow(title: '最新'),
            _MovieRow(title: '经典'),
          ],
        ),
      ),
    ],
  );
}

// 手机竖屏布局：底部导航 + 可滚动内容
Widget _PhonePortraitLayout() {
  return Scaffold(
    bottomNavigationBar: _BottomNavigationBar(),
    body: ListView(
      children: [
        _HeroBanner(),
        _MovieGrid(title: '热门'),
        _MovieGrid(title: '最新'),
      ],
    ),
  );
}
```

### 5. 全屏处理

#### 5.1 设备全屏状态

```dart
class FullScreenManager {
  static bool shouldUseFullScreen(BuildContext context) {
    return InputDetector.detectInputMethod(context) == InputMethod.remote;
  }
  
  static Future<void> setFullScreen(bool enabled) async {
    if (Platform.isAndroid) {
      // Android 全屏
      await SystemChrome.setEnabledSystemUIMode(
        enabled 
            ? SystemUiMode.immersiveSticky 
            : SystemUiMode.edgeToEdge,
      );
    } else if (Platform.isIOS) {
      // iOS 全屏
      await SystemChrome.setEnabledSystemUIMode(
        enabled ? SystemUiMode.leanBack : SystemUiMode.edgeToEdge,
      );
    } else {
      // Web 全屏
      // 使用 HTML5 Fullscreen API
    }
  }
}
```

#### 5.2 应用启动时设置

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 等待设备信息
  await Future.delayed(Duration(milliseconds: 100));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTV = DeviceInfo.deviceType == DeviceType.tv;
        
        // TV 全屏
        if (isTV) {
          FullScreenManager.setFullScreen(true);
        }
        
        return MaterialApp(
          // ...
        );
      },
    );
  }
}
```

### 6. 焦点系统适配

#### 6.1 TV 焦点管理

```dart
class FocusManager {
  static bool shouldEnableFocus(BuildContext context) {
    return InputDetector.detectInputMethod(context) == InputMethod.remote;
  }
  
  static Widget wrapWithFocus({
    required Widget child,
    required VoidCallback onFocus,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final enableFocus = shouldEnableFocus(context);
        
        if (enableFocus) {
          return Focus(
            onKey: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.select) {
                onTap();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            onFocusChange: (hasFocus) {
              if (hasFocus) onFocus();
            },
            child: child,
          );
        } else {
          return GestureDetector(
            onTap: onTap,
            child: child,
          );
        }
      },
    );
  }
}
```

### 7. 安全区域处理

```dart
class SafeAreaWrapper extends StatelessWidget {
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final layout = ResponsiveLayout.getLayoutType(context);
    final isTV = layout == LayoutType.tv;
    
    if (isTV) {
      // TV: 全屏，无安全区域
      return child;
    } else {
      // 手机/平板: 需要安全区域
      return SafeArea(child: child);
    }
  }
}
```

## 📝 实施步骤

### 阶段 1: 基础设施搭建（第 1-2 天）

1. **创建设备检测模块**
   - `lib/core/platform/device_type.dart`
   - `lib/core/platform/screen_orientation.dart`
   - `lib/core/platform/input_method.dart`

2. **创建响应式布局系统**
   - `lib/core/responsive/layout_breakpoints.dart`
   - `lib/core/responsive/responsive_grid.dart`
   - `lib/core/responsive/responsive_layout.dart`

3. **创建导航适配器**
   - `lib/core/navigation/adaptive_navigation_bar.dart`
   - `lib/core/navigation/focus_manager.dart`

4. **创建全屏管理器**
   - `lib/core/platform/full_screen_manager.dart`

### 阶段 2: UI 组件适配（第 3-5 天）

1. **适配电影卡片**
   - 修改 `YouTubeTVMovieCard` 支持多种布局
   - 创建响应式卡片变体

2. **适配 Hero Banner**
   - 支持不同设备的 Banner 尺寸
   - 添加滑动指示器（触摸设备）

3. **适配导航栏**
   - TV: 顶部横向滚动导航
   - 手机/平板: 底部 Tab 导航

4. **适配页面布局**
   - 首页、搜索页、详情页
   - 设置页、收藏页、历史页

### 阶段 3: 测试验证（第 6-7 天）

1. **创建测试脚本**
   - `script/test_tv_layout.sh`
   - `script/test_phone_layout.sh`
   - `script/test_tablet_layout.sh`

2. **使用 ADB 截图验证**
   - 在 TV 设备上测试
   - 在手机上测试（横屏/竖屏）
   - 在平板上测试（横屏/竖屏）

3. **修复布局溢出问题**
   - 根据截图反馈调整布局
   - 优化不同设备的间距和尺寸

## 🎨 设计指南

### TV 设计原则

- 大字体（最小 18sp）
- 大触摸区域（最小 48dp）
- 清晰的焦点指示
- 简化的导航结构
- 高对比度配色

### 手机设计原则

- 竖屏优先
- 底部导航栏
- 滑动手势支持
- 紧凑的信息密度
- 拇动操作支持

### 平板设计原则

- 横屏优先，支持竖屏
- 两列或三列布局
- 充分利用空间
- 支持分屏操作
- 平衡的信息密度

## 🔧 技术栈

### 新增依赖

```yaml
dependencies:
  platform_detect: ^2.0.0  # 平台检测
  flutter_displaymode: ^0.6.0  # 显示模式控制
  
dev_dependencies:
  device_preview: ^0.7.0  # 设备预览
```

### 配置文件

#### Android

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<activity
    android:name=".MainActivity"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:resizeableActivity="true"
    android:supportsPictureInPicture="true">
    <!-- 支持多窗口模式 -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
```

#### iOS

```xml
<!-- ios/Runner/Info.plist -->
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
<key>UIRequiresFullScreen</key>
<false/>  <!-- 手机/平板不需要全屏 -->
```

## 📊 验证清单

### TV 设备

- [ ] 自动全屏
- [ ] 顶部导航栏横向滚动
- [ ] 焦点指示器清晰
- [ ] 遥控器导航流畅
- [ ] 字体大小合适

### 手机竖屏

- [ ] 底部导航栏
- [ ] 竖屏海报比例（2:3）
- [ ] 2 列网格布局
- [ ] 触摸操作流畅
- [ ] 滑动手势支持

### 手机横屏

- [ ] 3 列网格布局
- [ ] 横屏海报比例（16:9）
- [ ] 底部导航栏保留
- [ ] 触摸操作流畅

### 平板横屏

- [ ] 5 列网格布局
- [ ] 充分利用空间
- [ ] 底部导航栏或侧边栏
- [ ] 触摸操作流畅
- [ ] 可选键盘/遥控器支持

### 平板竖屏

- [ ] 4 列网格布局
- [ ] 竖屏海报比例
- [ ] 底部导航栏
- [ ] 触摸操作流畅

## 🚀 后续优化

1. **性能优化**
   - 针对不同设备优化图片加载
   - 懒加载策略调整

2. **用户体验**
   - 设备特定手势
   - 平台特定功能（如 TV 推荐频道）

3. **测试**
   - 自动化多设备测试
   - 视觉回归测试

## 📚 参考资料

- [Flutter 响应式设计指南](https://flutter.dev/docs/development/ui/layout/responsive)
- [Material Design 适配指南](https://material.io/design/platform-guidance/android-tv)
- [Android TV 开发指南](https://developer.android.com/training/tv/start/start)