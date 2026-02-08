import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/app/constants/app_constants.dart';

/// YouTube TV 风格的横向滚动分类导航栏
///
/// 特性：
/// - 平滑的横向滚动
/// - 焦点状态高亮
/// - 动态指示器
/// - 电视遥控器友好
class YouTubeTVCategoryBar extends StatefulWidget {
  const YouTubeTVCategoryBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final EdgeInsets padding;

  @override
  State<YouTubeTVCategoryBar> createState() => _YouTubeTVCategoryBarState();
}

class _YouTubeTVCategoryBarState extends State<YouTubeTVCategoryBar>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _indicatorController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _indicatorController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  @override
  void didUpdateWidget(YouTubeTVCategoryBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _indicatorController.reset();
      _indicatorController.forward();
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    if (widget.categories.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final RenderBox? renderBox =
          context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final double screenWidth = renderBox.size.width;
      const double estimatedItemWidth = 120.0;
      final double targetPosition =
          widget.selectedIndex * estimatedItemWidth;

      _scrollController.animateTo(
        targetPosition - screenWidth / 2 + estimatedItemWidth / 2,
        duration: AppConstants.normalAnimation,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: widget.padding,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _CategoryItem(
              categoryName: widget.categories[index],
              isSelected: index == widget.selectedIndex,
              onTap: () => widget.onCategorySelected(index),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  const _CategoryItem({
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.fastAnimation,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.isSelected,
      onFocusChange: _handleFocusChange,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.select)) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 40,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppTheme.accent
                    : (_isFocused
                        ? AppTheme.surfaceVariant
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(20),
                border: _isFocused
                    ? Border.all(color: AppTheme.focus, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  widget.categoryName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: widget.isSelected ? Colors.white : null,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}