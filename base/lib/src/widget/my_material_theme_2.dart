import 'package:flutter/material.dart';

/// 启用 Material2
///
/// 有一些组件如[Switch]仍然用 Material2样式
class MyMaterialTheme2 extends StatelessWidget {
  const MyMaterialTheme2({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ThemeData themeMaterial2 = ThemeData.from(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
      useMaterial3: false,
    );
    return Theme(data: themeMaterial2, child: child);
  }
}
