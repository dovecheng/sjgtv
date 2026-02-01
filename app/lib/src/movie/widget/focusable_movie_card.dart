import 'package:base/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/movie/model/movie_model.dart';
import 'package:sjgtv/src/movie/page/search_page.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';

/// 可聚焦的电影卡片组件（TV 遥控器适配）
class FocusableMovieCard extends StatefulWidget {
  final MovieModel movie;

  const FocusableMovieCard({super.key, required this.movie});

  @override
  State<FocusableMovieCard> createState() => _FocusableMovieCardState();
}

class _FocusableMovieCardState extends State<FocusableMovieCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;
    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  SearchPage(initialQuery: widget.movie.title),
            ),
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (bool hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _isFocused ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: _isFocused
                ? Border.all(color: Colors.white, width: 2.0)
                : null,
          ),
          child: ClipRect(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Container(
                    decoration: BoxDecoration(color: colors.cardSurface),
                    child: widget.movie.coverUrl != null
                        ? CachedImage(
                            imageUrl: widget.movie.coverUrl!,
                            httpHeaders: const <String, String>{
                              'User-Agent':
                                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:147.0) Gecko/20100101 Firefox/147.0',
                              'Accept':
                                  'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
                              'Referer': 'https://movie.douban.com/',
                            },
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (BuildContext ctx, String url) =>
                                networkImagePlaceholder(ctx),
                            errorWidget: (BuildContext ctx, String url,
                                    Object error) =>
                                networkImageErrorWidget(ctx),
                          )
                        : Container(
                            color: colors.surfaceVariant,
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
                  ),
                ),
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.movie.year}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.movie.rating}',
                              style: const TextStyle(
                                fontSize: 13,
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
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
