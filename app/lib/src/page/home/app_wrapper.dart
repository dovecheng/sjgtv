import 'package:flutter/material.dart';
import 'package:sjgtv/src/page/home/category_page.dart';
import 'package:sjgtv/src/widget/update_checker.dart';

/// 应用包装器
///
/// 作为应用的根组件，负责：
/// - 启动时检查应用更新
/// - 包装主页面 [MovieHomePage]
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await AppUpdater.checkForUpdate(context);
  }

  @override
  Widget build(BuildContext context) {
    return MovieHomePage();
  }
}
