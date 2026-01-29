import 'package:base/base.dart';
import 'package:flutter/material.dart';

typedef ChildrenBuilder = List<Widget> Function(BuildContext context);

abstract final class PageDialog {
  /// 弹出一个充满屏幕的页面dialog
  static Future<T?> show<T>({
    required WidgetBuilder builder,
    // 距离顶部（遮罩层）高度
    double top = 100,
  }) =>
      showModalBottomSheet<T>(
        context: AppNavigator.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => AndroidSafeArea(
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: SizedBox(
                  height: top,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Builder(builder: builder),
                ),
              ),
            ],
          ),
        ),
      );

  /// 弹出一个页面dialog(包含AppBar)
  ///
  /// 不自适应高度
  static Future<T?> showScaffoldWithAppBarAndSliver<T>(
    BuildContext context, {
    required String title,
    Color? backgroundColor,
    WidgetBuilder? sliverBuilder,

    // 距离顶部（遮罩层）高度
    double top = 100,
    Color? backButtonColor,
    TextStyle? titleTextStyle,
  }) => showScaffoldWithAppBarAndSlivers(
    top: top,
    title: title,
    titleTextStyle: titleTextStyle,
    backButtonColor: Theme.of(context).buttonTheme.colorScheme!.surface,
    backgroundColor: backgroundColor,
    sliversBuilder: (BuildContext ctx) => [
      sliverBuilder?.call(ctx) ?? Container(),
    ],
  );

  /// 弹出一个自适应高度dialog(包含标题 + 关闭按钮)
  static Future<T?> showModalBottomSheetWithTitleAndIcon<T>(
    BuildContext context, {
    required String title,
    String? titleL10nKey,
    Color? backgroundColor,
    Color? appbarBackgroundColor,
    Color? backButtonColor,
    TextStyle? titleTextStyle,

    // 最大高度
    double? maxHeight,

    // 最大高度
    double? minHeight,

    // appbar高度
    double appbarExpandedHeight = 56,

    // bodyPadding
    EdgeInsets bodyPadding = const EdgeInsets.all(16),
    required Widget child,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        BoxConstraints? constraints;
        if (maxHeight != null && minHeight != null) {
          constraints = BoxConstraints(
            maxHeight: maxHeight,
            minHeight: minHeight,
          );
        } else if (maxHeight != null) {
          constraints = BoxConstraints(maxHeight: maxHeight);
        } else if (minHeight != null) {
          constraints = BoxConstraints(minHeight: minHeight);
        }

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            constraints: constraints,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: appbarExpandedHeight,
                    leading: Container(),
                    backgroundColor: appbarBackgroundColor,
                    flexibleSpace: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 48,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: L10nKeyTips(
                              keyTips: titleL10nKey,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: titleTextStyle,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close,
                              color: backButtonColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: bodyPadding,
                    sliver: SliverToBoxAdapter(child: child),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  /// 弹出一个dialog
  ///
  /// 注意: 不包含标题appbar
  static Future<T?> showCustomWidget<T>({
    Color? backgroundColor,
    Color? backButtonColor,

    // 最大高度
    double? maxHeight,

    // 最小高度
    double? minHeight,

    // bodyPadding
    EdgeInsets bodyPadding = const EdgeInsets.all(16),

    // 是否作为Scaffold.BottomSheet弹出
    bool isShowAsScaffoldBottomSheet = false,

    // 圆角
    double borderRadius = 24.0,
    required Widget child,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: AppNavigator.context,
      builder: (BuildContext context) {
        BoxConstraints? constraints;
        if (maxHeight != null && minHeight != null) {
          constraints = BoxConstraints(
            maxHeight: maxHeight,
            minHeight: minHeight,
          );
        } else if (maxHeight != null) {
          constraints = BoxConstraints(maxHeight: maxHeight);
        } else if (minHeight != null) {
          constraints = BoxConstraints(minHeight: minHeight);
        }

        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
          child: Container(
            constraints: constraints,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
              color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            ),
            child: SafeArea(
              child: Padding(padding: bodyPadding, child: child),
            ),
          ),
        ).let((ClipRRect it) {
          if (isShowAsScaffoldBottomSheet) {
            // 作为Scaffold.BottomSheet弹出
            //
            // 处理键盘覆盖问题
            return KeyboardHider(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.navigator.pop();
                  },
                ),
                bottomSheet: BottomSheet(
                  enableDrag: false,
                  builder: (BuildContext context) {
                    return it;
                  },
                  onClosing: () {},
                ),
              ),
            );
          }
          return it;
        });
      },
      isScrollControlled: true,
    );
  }

  /// 弹出一个页面dialog(包含AppBar)
  static Future<T?> showScaffoldWithAppBarAndSlivers<T>({
    required String title,
    ChildrenBuilder? sliversBuilder,
    Color? backgroundColor,

    // 距离顶部（遮罩层）高度
    double top = 100,
    Color? backButtonColor,
    TextStyle? titleTextStyle,
  }) => show(
    top: top,
    builder: (BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(title, style: titleTextStyle),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: backButtonColor),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: sliversBuilder?.call(context) ?? [],
      ),
    ),
  );

  /// 弹出一个充满屏幕的页面dialog
  static Future<T?> showWithSliver<T>(
    BuildContext context, {
    WidgetBuilder? sliverBuilder,
    Color? backgroundColor,

    // 距离顶部（遮罩层）高度
    double top = 100,
  }) => showWithSlivers(
    top: top,
    backgroundColor: backgroundColor,
    sliversBuilder: (BuildContext ctx) => [
      sliverBuilder?.call(ctx) ?? const SliverToBoxAdapter(),
    ],
  );

  /// 弹出一个充满屏幕的页面dialog
  static Future<T?> showWithSlivers<T>({
    ChildrenBuilder? sliversBuilder,
    Color? backgroundColor,

    // 距离顶部（遮罩层）高度
    double top = 100,
  }) => show(
    top: top,
    builder: (BuildContext context) => Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: sliversBuilder?.call(context) ?? [],
      ),
    ),
  );
}
