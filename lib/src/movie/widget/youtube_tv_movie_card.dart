import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/core/core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sjgtv/src/movie/model/movie_model.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';
import 'package:sjgtv/src/app/constants/app_constants.dart';
import 'package:sjgtv/src/app/router/app_router.dart';

/// YouTube TV 风格的电影卡片组件
///
/// 特性：
/// - 焦点状态缩放动画
/// - 焦点状态边框高亮
/// - 焦点状态发光效果
/// - 支持海报图片
/// - 显示标题和评分
/// - 支持网格内方向键导航
class YouTubeTVMovieCard extends StatefulWidget {
  const YouTubeTVMovieCard({
    super.key,
    required this.movie,
    this.focusNode,
    this.gridIndex,
    this.crossAxisCount,
    this.itemCount,
    this.onMoveFocus,
    this.aspectRatio = 2 / 3,
  });

  final MovieModel movie;
  final FocusNode? focusNode;
  final int? gridIndex;
  final int? crossAxisCount;
  final int? itemCount;
  final void Function(int targetIndex)? onMoveFocus;
  final double aspectRatio;

  @override
  State<YouTubeTVMovieCard> createState() => _YouTubeTVMovieCardState();
}

class _YouTubeTVMovieCardState extends State<YouTubeTVMovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<double> _glowAnimation;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: AppConstants.focusScaleFactor).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _borderAnimation =
        Tween<double>(begin: 0.0, end: AppConstants.focusBorderWidth).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _glowAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    if (hasFocus != _isFocused) {
      setState(() {
        _isFocused = hasFocus;
      });
      if (hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _onCardTap() {
    log.v(() => '用户点击电影卡片: ${widget.movie.title}');
    context.goToSearch(widget.movie.title);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final bool canMoveInGrid =
        widget.gridIndex != null &&
        widget.crossAxisCount != null &&
        widget.itemCount != null &&
        widget.onMoveFocus != null;

    return Focus(
      key: ValueKey('youtube_movie_card_${widget.movie.id}'),
      focusNode: widget.focusNode,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            _onCardTap();
            return KeyEventResult.handled;
          }
          if (canMoveInGrid) {
            final int i = widget.gridIndex!;
            final int cols = widget.crossAxisCount!;
            final int n = widget.itemCount!;
            final void Function(int) move = widget.onMoveFocus!;
            int? target;
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              target = i - cols;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              target = i + cols;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (i % cols != 0) target = i - 1;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              if ((i + 1) % cols != 0 && i + 1 < n) target = i + 1;
            }
            if (target != null && target >= 0 && target < n) {
              move(target);
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: _handleFocusChange,
      child:
          AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.focusGlow,
                            blurRadius: 8.0 * _glowAnimation.value,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: AppTheme.focus.withValues(
                            alpha: _borderAnimation.value / 2,
                          ),
                          width: _borderAnimation.value,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildCardContent(colorScheme),
                      ),
                    ),
                  );
                },
              )
              .animate(target: _isFocused ? 1 : 0)
              .shimmer(
                duration: 1500.ms,
                color: AppTheme.focus.withValues(alpha: 0.1),
                angle: 45,
              ),
    );
  }

  Widget _buildCardContent(ColorScheme colorScheme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onCardTap,
        child: Stack(
          children: [
            _buildImage(colorScheme),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildInfo(colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        color: colorScheme.surfaceContainer,
        child: widget.movie.coverUrl != null
            ? CachedImage(
                imageUrl: widget.movie.coverUrl!,
                httpHeaders: const {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                  'Accept':
                      'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
                  'Referer': 'https://movie.douban.com/',
                },
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (BuildContext ctx, String url) =>
                    networkImagePlaceholder(ctx),
                errorWidget: (BuildContext ctx, String url, Object error) =>
                    networkImageErrorWidget(ctx),
              )
            : Container(
                color: colorScheme.surfaceContainerLow,
                child: Center(
                  child: Text(
                    widget.movie.title.split(' ').first,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfo(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainer.withValues(alpha: 0.9),
            colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Text(
            widget.movie.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // 年份和评分
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.movie.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    '${widget.movie.rating}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
