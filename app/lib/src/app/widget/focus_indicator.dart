import 'package:flutter/material.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/app/constants/app_constants.dart';
import 'package:sjgtv/src/app/utils/gesture_helper.dart';

/// 焦点指示器装饰
///
/// 提供多种焦点指示效果：
/// - 边框
/// - 阴影/发光
/// - 缩放
/// - 背景色变化
class FocusIndicatorDecoration {
  const FocusIndicatorDecoration({
    this.hasBorder = true,
    this.hasShadow = true,
    this.hasScale = true,
    this.hasBackgroundColor = false,
    this.borderColor,
    this.borderWidth,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.scaleFactor,
    this.backgroundColor,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
  });

  final bool hasBorder;
  final bool hasShadow;
  final bool hasScale;
  final bool hasBackgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final double? shadowSpreadRadius;
  final double? scaleFactor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;

  /// 默认焦点指示器
  static const FocusIndicatorDecoration defaultIndicator =
      FocusIndicatorDecoration();

  /// 无装饰
  static const FocusIndicatorDecoration none = FocusIndicatorDecoration(
    hasBorder: false,
    hasShadow: false,
    hasScale: false,
    hasBackgroundColor: false,
  );

  /// 强调焦点指示器
  static const FocusIndicatorDecoration prominent = FocusIndicatorDecoration(
    hasBorder: true,
    hasShadow: true,
    hasScale: true,
    borderWidth: 4.0,
    scaleFactor: 1.1,
    shadowBlurRadius: 16.0,
    shadowSpreadRadius: 3.0,
  );

  /// 简洁焦点指示器
  static const FocusIndicatorDecoration simple = FocusIndicatorDecoration(
    hasBorder: true,
    hasShadow: false,
    hasScale: false,
    hasBackgroundColor: false,
    borderWidth: 2.0,
  );

  /// 复制并修改属性
  FocusIndicatorDecoration copyWith({
    bool? hasBorder,
    bool? hasShadow,
    bool? hasScale,
    bool? hasBackgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    double? scaleFactor,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return FocusIndicatorDecoration(
      hasBorder: hasBorder ?? this.hasBorder,
      hasShadow: hasShadow ?? this.hasShadow,
      hasScale: hasScale ?? this.hasScale,
      hasBackgroundColor: hasBackgroundColor ?? this.hasBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

/// 焦点指示器组件
///
/// 为子组件提供焦点视觉效果
class FocusIndicator extends StatefulWidget {
  const FocusIndicator({
    super.key,
    required this.child,
    this.focusNode,
    this.decoration = FocusIndicatorDecoration.defaultIndicator,
    this.autofocus = false,
    this.onFocusChange,
    this.onTap,
  });

  final Widget child;
  final FocusNode? focusNode;
  final FocusIndicatorDecoration decoration;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onTap;

  @override
  State<FocusIndicator> createState() => _FocusIndicatorState();
}

class _FocusIndicatorState extends State<FocusIndicator>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _setupAnimation();

    _focusNode.addListener(_handleFocusChange);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _setupAnimation() {
    final Duration duration =
        widget.decoration.animationDuration ?? AppConstants.normalAnimation;
    final Curve curve = widget.decoration.animationCurve ?? Curves.easeOutCubic;

    _animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.decoration.scaleFactor ?? AppConstants.focusScaleFactor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: curve,
    ));

    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: widget.decoration.borderWidth ?? AppConstants.focusBorderWidth,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: curve,
    ));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: curve,
    ));

    if (widget.decoration.hasBackgroundColor) {
      _backgroundColorAnimation = ColorTween(
        begin: Colors.transparent,
        end: widget.decoration.backgroundColor ??
            AppTheme.focus.withValues(alpha: 0.1),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: curve,
      ));
    }
  }

  void _handleFocusChange() {
    final bool hasFocus = _focusNode.hasFocus;
    if (hasFocus != _isFocused) {
      setState(() {
        _isFocused = hasFocus;
      });

      if (hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      widget.onFocusChange?.call(hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final double scale = widget.decoration.hasScale
              ? _scaleAnimation.value
              : 1.0;

          final List<BoxShadow> shadows = [];
          if (widget.decoration.hasShadow) {
            final Color shadowColor =
                widget.decoration.shadowColor ?? AppTheme.focus;
            final double blurRadius =
                widget.decoration.shadowBlurRadius ?? 12.0;
            final double spreadRadius =
                widget.decoration.shadowSpreadRadius ?? 2.0;

            shadows.add(
              BoxShadow(
                color: shadowColor.withValues(
                  alpha: 0.4 * _shadowAnimation.value,
                ),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            );
          }

          final Border? border;
          if (widget.decoration.hasBorder) {
            final Color borderColor =
                widget.decoration.borderColor ?? AppTheme.focus;
            final double borderWidth = _borderAnimation.value;
            border = Border.all(
              color: borderColor,
              width: borderWidth,
            );
          } else {
            border = null;
          }

          final Color? backgroundColor;
          if (widget.decoration.hasBackgroundColor) {
            backgroundColor = _backgroundColorAnimation.value;
          } else {
            backgroundColor = null;
          }

          Widget result = Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                border: border,
                borderRadius: widget.decoration.borderRadius ??
                    BorderRadius.circular(AppConstants.cardBorderRadius),
                boxShadow: shadows.isNotEmpty ? shadows : null,
                color: backgroundColor,
              ),
              child: child,
            ),
          );

          if (widget.onTap != null) {
            // 在触摸设备上使用 InkWell 提供触摸反馈
            if (GestureHelper.isTouchDevice(context)) {
              result = Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: widget.decoration.borderRadius ??
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                  splashColor: GestureHelper.getRecommendedRippleColor(context),
                  highlightColor: GestureHelper.getRecommendedHighlightColor(context),
                  child: result,
                ),
              );
            } else {
              // TV 设备上使用 GestureDetector
              result = GestureDetector(
                onTap: widget.onTap,
                child: result,
              );
            }
          }

          return result;
        },
        child: widget.child,
      ),
    );
  }
}

/// 焦点指示器包装器
///
/// 便捷的焦点指示器包装函数
Widget withFocusIndicator(
  Widget child, {
  FocusNode? focusNode,
  FocusIndicatorDecoration decoration = FocusIndicatorDecoration.defaultIndicator,
  bool autofocus = false,
  ValueChanged<bool>? onFocusChange,
  VoidCallback? onTap,
}) {
  return FocusIndicator(
    focusNode: focusNode,
    decoration: decoration,
    autofocus: autofocus,
    onFocusChange: onFocusChange,
    onTap: onTap,
    child: child,
  );
}

/// 脉冲焦点指示器
///
/// 添加脉冲动画效果的焦点指示器
class PulseFocusIndicator extends StatefulWidget {
  const PulseFocusIndicator({
    super.key,
    required this.child,
    this.focusNode,
    this.decoration = FocusIndicatorDecoration.defaultIndicator,
    this.autofocus = false,
    this.onFocusChange,
    this.onTap,
    this.pulseDuration = const Duration(seconds: 1),
  });

  final Widget child;
  final FocusNode? focusNode;
  final FocusIndicatorDecoration decoration;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onTap;
  final Duration pulseDuration;

  @override
  State<PulseFocusIndicator> createState() => _PulseFocusIndicatorState();
}

class _PulseFocusIndicatorState extends State<PulseFocusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusIndicator(
      focusNode: widget.focusNode,
      decoration: widget.decoration.copyWith(
        hasShadow: true,
        shadowBlurRadius: 20.0,
      ),
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      child: widget.child,
    );
  }
}

/// 滑动焦点指示器
///
/// 滑动效果切换焦点
class SlideFocusIndicator extends StatefulWidget {
  const SlideFocusIndicator({
    super.key,
    required this.child,
    this.focusNode,
    this.decoration = FocusIndicatorDecoration.defaultIndicator,
    this.autofocus = false,
    this.onFocusChange,
    this.onTap,
    this.slideOffset = const Offset(0, -8),
  });

  final Widget child;
  final FocusNode? focusNode;
  final FocusIndicatorDecoration decoration;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onTap;
  final Offset slideOffset;

  @override
  State<SlideFocusIndicator> createState() => _SlideFocusIndicatorState();
}

class _SlideFocusIndicatorState extends State<SlideFocusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.slideOffset,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusIndicator(
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      autofocus: widget.autofocus,
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
        widget.onFocusChange?.call(focused);
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _isFocused ? _slideAnimation.value : Offset.zero,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}