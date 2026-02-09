import 'dart:async';
import 'dart:io';

import 'package:sjgtv/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sjgtv/src/movie/page/player_intents.dart';
import 'package:sjgtv/src/movie/service/m3u8_ad_remover.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final Log _log = Log('FullScreenPlayer');

/// 全屏视频播放器页面
///
/// 功能：
/// - 使用 MediaKit 播放 M3U8/MP4 等格式视频
/// - 自动处理 M3U8 广告片段（通过 [M3U8AdRemover]）
/// - TV 遥控器控制：左右快进快退、上下切换集数、确认键播放暂停
/// - 长按方向键加速快进/快退
/// - 音量控制和静音
/// - 自动播放下一集
/// - 记录每集播放进度
/// - 屏幕常亮
/// - 多源时：菜单键打开换源面板，可切换播放源并保留进度
class FullScreenPlayerPage extends StatefulWidget {
  final dynamic movie;
  final List<Map<String, String>> episodes;
  final int initialIndex;
  /// 多播放源列表，每项需含 vod_play_url，可选 vod_pic、vod_name、source
  final List<Map<String, dynamic>>? sources;
  final int currentSourceIndex;

  const FullScreenPlayerPage({
    super.key,
    required this.movie,
    required this.episodes,
    required this.initialIndex,
    this.sources,
    this.currentSourceIndex = 0,
  });

  @override
  State<FullScreenPlayerPage> createState() => _FullScreenPlayerPageState();
}

class _FullScreenPlayerPageState extends State<FullScreenPlayerPage> {
  late final Player _player;
  late final VideoController _videoController;
  /// 当前使用的播放源列表（sources ?? [movie]）
  late final List<Map<String, dynamic>> _sources;
  int _currentSourceIndex;
  /// 当前源的剧集列表（从当前源的 vod_play_url 解析，换源时更新）
  late List<Map<String, String>> _episodes;
  int _currentEpisodeIndex;
  bool _isLoading = true;
  String? _errorMessage;
  final ValueNotifier<bool> _controlsVisibility = ValueNotifier(true);
  final FocusNode _playerFocusNode = FocusNode();
  final ValueNotifier<bool> _isSeeking = ValueNotifier(false);
  final ValueNotifier<bool> _isBuffering = ValueNotifier(false);
  final Duration _seekStep = const Duration(seconds: 10);
  Timer? _seekTimer;
  bool _isLongPressing = false;
  DateTime? _lastKeyEventTime;
  final Map<int, Duration> _episodeProgress = {};
  Duration _currentSeekSpeed = const Duration(seconds: 10);
  final Duration _minSeekSpeed = const Duration(seconds: 10);
  final Duration _maxSeekSpeed = const Duration(seconds: 300);
  final Duration _speedIncrement = const Duration(seconds: 10);
  Timer? _speedIncreaseTimer;
  Timer? _volumeHUDTimer;
  double _volume = 100.0;
  bool _showVolumeHUD = false;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _bufferingSubscription;
  StreamSubscription? _completedSubscription;
  final ValueNotifier<int> _seekDirection = ValueNotifier(0);
  final ValueNotifier<Duration?> _seekPosition = ValueNotifier<Duration?>(null);
  Timer? _seekHideTimer;
  final Duration _seekDisplayDuration = const Duration(seconds: 1);
  bool _showSourcePanel = false;
  final FocusNode _sourcePanelFocusNode = FocusNode();
  final ScrollController _sourcePanelScrollController = ScrollController();
  int _sourcePanelFocusedIndex = 0;
  /// 每项一个 GlobalKey，用于 Scrollable.ensureVisible 按真实高度滚动
  late final List<GlobalKey> _sourceItemKeys;
  /// 项未构建时的估算高度，用于先滚到可见区域再 ensureVisible
  static const double _sourceListItemHeightFallback = 120.0;
  /// 源测试结果：延迟(ms)、m3u8 是否可用
  final Map<int, _SourceTestResult> _sourceTestResults = {};
  /// 正在测试的源下标
  final Set<int> _sourceTestingIndices = {};
  /// 进度条节流：每 1s 更新，减少 UI 重建对播放帧率的影响
  final ValueNotifier<Duration> _progressPosition = ValueNotifier(Duration.zero);
  Timer? _progressTimer;

  _FullScreenPlayerPageState()
      : _currentSourceIndex = 0,
        _currentEpisodeIndex = 0;

  /// 仅保留可播放的源（vod_play_url 非空且能解析出剧集）
  List<Map<String, dynamic>> _filterPlayableSources(
      List<Map<String, dynamic>> list) {
    return list
        .where((Map<String, dynamic> s) =>
            (s['vod_play_url']?.toString() ?? '').trim().isNotEmpty &&
            _parseEpisodesFromPlayUrl(s).isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    List<Map<String, dynamic>> raw =
        widget.sources != null && widget.sources!.isNotEmpty
            ? List<Map<String, dynamic>>.from(widget.sources!)
            : <Map<String, dynamic>>[widget.movie as Map<String, dynamic>];
    _sources = _filterPlayableSources(raw);
    if (_sources.isEmpty) {
      _sources = raw;
    }
    _currentSourceIndex =
        widget.currentSourceIndex.clamp(0, _sources.length - 1);
    _episodes = _parseEpisodesFromPlayUrl(_sources[_currentSourceIndex]);
    _currentEpisodeIndex =
        widget.initialIndex.clamp(0, _episodes.isEmpty ? 0 : _episodes.length - 1);
    _sourcePanelFocusedIndex = _currentSourceIndex;
    _sourceItemKeys = List.generate(_sources.length, (_) => GlobalKey());
    _player = Player(
      configuration: const PlayerConfiguration(
        bufferSize: 64 * 1024 * 1024,
      ),
    );
    _videoController = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
        androidAttachSurfaceAfterVideoParameters: true,
        scale: 1.0,
      ),
    );
    final String? firstUrl = _episodes.isNotEmpty
        ? _episodes[_currentEpisodeIndex]['url']
        : null;
    if (firstUrl != null && firstUrl.isNotEmpty) {
      _initializePlayer(firstUrl);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = '当前源无有效剧集';
      });
    }
    _playerFocusNode.addListener(() {
      if (_playerFocusNode.hasFocus) {
        _toggleControlsVisibility(true);
      }
    });
  }

  /// 从源的 vod_play_url 解析剧集列表
  List<Map<String, String>> _parseEpisodesFromPlayUrl(
      Map<String, dynamic> source) {
    final List<Map<String, String>> list = <Map<String, String>>[];
    final String? playUrl = source['vod_play_url'] as String?;
    if (playUrl == null || playUrl.isEmpty) return list;
    final List<String> parts = playUrl.split('#');
    for (final String part in parts) {
      final List<String> episodeParts = part.split('\$');
      if (episodeParts.length == 2) {
        list.add(<String, String>{
          'title': episodeParts[0],
          'url': episodeParts[1],
        });
      }
    }
    return list;
  }

  void _toggleControlsVisibility(bool visible) {
    _controlsVisibility.value = visible;
    if (visible) {
      _startControlsAutoHideTimer();
    }
  }

  void _startControlsAutoHideTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _playerFocusNode.hasFocus) {
        _toggleControlsVisibility(false);
      }
    });
  }

  Future<void> _controlWakelock(bool enable) async {
    try {
      enable ? await WakelockPlus.enable() : await WakelockPlus.disable();
    } catch (e) {
      _log.e(() => 'Wakelock控制失败', e);
    }
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _progressPosition.value = _player.state.position;
    });
  }

  void _setupPlayerListeners() {
    _playerStateSubscription?.cancel();
    _bufferingSubscription?.cancel();
    _completedSubscription?.cancel();

    _playerStateSubscription = _player.stream.playing.listen((bool isPlaying) {
      _controlWakelock(isPlaying);
    });

    _bufferingSubscription = _player.stream.buffering.listen((bool isBuffering) {
      if (_isBuffering.value != isBuffering) {
        _isBuffering.value = isBuffering;
      }
    });

    _completedSubscription = _player.stream.completed.listen((bool completed) {
      if (completed) {
        _playNextEpisode();
      }
    });
  }

  void _cleanupSeek() {
    _isLongPressing = false;
    _seekTimer?.cancel();
    _seekTimer = null;
    _speedIncreaseTimer?.cancel();
    _speedIncreaseTimer = null;
    _currentSeekSpeed = _seekStep;
    _seekHideTimer?.cancel();
    _seekHideTimer = null;
    _isSeeking.value = false;
    _seekDirection.value = 0;
    _seekPosition.value = null;
  }

  @override
  void dispose() {
    _cleanupSeek();
    _episodeProgress.clear();
    _playerStateSubscription?.cancel();
    _bufferingSubscription?.cancel();
    _completedSubscription?.cancel();
    _player.dispose();
    _playerFocusNode.dispose();
    _sourcePanelFocusNode.dispose();
    _sourcePanelScrollController.dispose();
    _controlsVisibility.dispose();
    _isSeeking.dispose();
    _isBuffering.dispose();
    _seekDirection.dispose();
    _seekPosition.dispose();
    _progressTimer?.cancel();
    _progressPosition.dispose();
    _volumeHUDTimer?.cancel();
    WakelockPlus.disable().ignore();
    super.dispose();
  }

  Future<void> _initializePlayer(String url) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isBuffering.value = true;
    });

    try {
      var processM3u8Url = await _processM3u8Url(url);
      await _player.open(Media(processM3u8Url));
      _player.setVolume(_volume);
      _setupPlayerListeners();

      if (_episodeProgress.containsKey(_currentEpisodeIndex)) {
        await _player.seek(_episodeProgress[_currentEpisodeIndex]!);
      }

      if (mounted) {
        _startProgressTimer();
        setState(() => _isLoading = false);
        _preloadNextEpisode();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '播放失败: ${e.toString()}';
          _isBuffering.value = false;
        });
      }
    }
  }

  Future<void> _preloadNextEpisode() async {
    if (_currentEpisodeIndex >= _episodes.length - 1) return;

    final String? nextUrl = _episodes[_currentEpisodeIndex + 1]['url'];
    if (nextUrl == null || nextUrl.isEmpty) return;

    try {
      final Player preloadPlayer = Player();
      await preloadPlayer.open(Media(nextUrl));
      await preloadPlayer.pause();
      await preloadPlayer.setVolume(0);
      await preloadPlayer.seek(Duration.zero);
      await preloadPlayer.dispose();
    } catch (e) {
      _log.e(() => '预加载下一集失败', e);
    }
  }

  Future<void> _changeEpisode(int index) async {
    if (_episodes.isEmpty ||
        index < 0 ||
        index >= _episodes.length ||
        index == _currentEpisodeIndex) {
      return;
    }

    setState(() {
      _controlsVisibility.value = true;
      _isLoading = true;
      _errorMessage = null;
      _isBuffering.value = true;
    });

    _startControlsAutoHideTimer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '正在加载: ${_episodes[index]['title'] ?? '第${index + 1}集'}',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black54,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 100),
        ),
      );
    }

    _episodeProgress[_currentEpisodeIndex] = _player.state.position;

    final String? url = _episodes[index]['url'];
    if (url == null || url.isEmpty) {
      setState(() {
        _errorMessage = '无效的视频URL';
        _isLoading = false;
        _isBuffering.value = false;
      });
      return;
    }

    try {
      await _player.pause();
      var processM3u8Url = await _processM3u8Url(url);
      await _player.open(Media(processM3u8Url));
      _player.setVolume(_volume);

      if (_episodeProgress.containsKey(index)) {
        await _player.seek(_episodeProgress[index]!);
      }

      if (mounted) {
        setState(() {
          _currentEpisodeIndex = index;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '播放失败: ${e.toString()}';
          _isBuffering.value = false;
        });
      }
      _log.e(() => '初始化播放器错误', e);
    }
  }

  /// 切换到指定播放源，保留当前播放进度
  Future<void> _switchToSource(int index) async {
    if (index < 0 ||
        index >= _sources.length ||
        index == _currentSourceIndex) {
      return;
    }
    final Duration savedPosition = _player.state.position;
    setState(() {
      _showSourcePanel = false;
      _currentSourceIndex = index;
      _episodes = _parseEpisodesFromPlayUrl(_sources[index]);
      _currentEpisodeIndex =
          _currentEpisodeIndex.clamp(0, _episodes.isEmpty ? 0 : _episodes.length - 1);
      _controlsVisibility.value = true;
      _isLoading = true;
      _errorMessage = null;
      _isBuffering.value = true;
    });
    _sourcePanelFocusedIndex = index;

    final String? url = _episodes.isEmpty
        ? null
        : _episodes[_currentEpisodeIndex]['url'];
    if (url == null || url.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = '该源无有效剧集';
        _isBuffering.value = false;
      });
      return;
    }

    try {
      await _player.pause();
      final String processM3u8Url = await _processM3u8Url(url);
      await _player.open(Media(processM3u8Url));
      _player.setVolume(_volume);
      await _player.seek(savedPosition.clamp(Duration.zero, _player.state.duration));
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '换源失败: ${e.toString()}';
          _isBuffering.value = false;
        });
      }
      _log.e(() => '换源失败', e);
    }
  }

  void _playNextEpisode() {
    if (_currentEpisodeIndex < _episodes.length - 1) {
      _changeEpisode(_currentEpisodeIndex + 1);
    } else {
      _player.pause();
      if (mounted) {
        _toggleControlsVisibility(true);
      }
      _startControlsAutoHideTimer();
    }
  }

  void _togglePlayPause() {
    _toggleControlsVisibility(true);
    _player.state.playing ? _player.pause() : _player.play();
  }

  void _startSeek(Duration step) {
    if (_isLongPressing) return;

    _isLongPressing = true;
    _currentSeekSpeed = _seekStep;
    _seekDirection.value = step.inSeconds.sign;

    _updateSeekPosition(step);

    _resetSeekHideTimer();

    _seekTimer?.cancel();
    _seekTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_isLongPressing) {
        _updateSeekPosition(_currentSeekSpeed * _seekDirection.value);
        _resetSeekHideTimer();
      } else {
        timer.cancel();
      }
    });

    _speedIncreaseTimer?.cancel();
    _speedIncreaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSeekSpeed = (_currentSeekSpeed + _speedIncrement).clamp(
        _minSeekSpeed,
        _maxSeekSpeed,
      );
    });
  }

  void _resetSeekHideTimer() {
    _seekHideTimer?.cancel();
    _seekHideTimer = Timer(_seekDisplayDuration, () {
      if (!_isLongPressing) {
        _seekPosition.value = null;
        _isSeeking.value = false;
      }
    });
  }

  void _updateSeekPosition(Duration step) {
    final Duration newPosition = (_player.state.position + step).clamp(
      Duration.zero,
      _player.state.duration,
    );
    _seekPosition.value = newPosition;
    _isSeeking.value = true;
    _player.seek(newPosition);
  }

  void _stopSeek(Duration step) {
    _isLongPressing = false;
    _seekTimer?.cancel();
    _seekTimer = null;
    _speedIncreaseTimer?.cancel();
    _speedIncreaseTimer = null;
    _currentSeekSpeed = _seekStep;

    if (step != Duration.zero) {
      final Duration newPosition = (_player.state.position + step).clamp(
        Duration.zero,
        _player.state.duration,
      );
      _player.seek(newPosition);
    }

    _resetSeekHideTimer();
  }

  void _displayVolumeHUD(double volume) {
    setState(() {
      _volume = volume;
      _showVolumeHUD = true;
    });

    _volumeHUDTimer?.cancel();
    _volumeHUDTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showVolumeHUD = false;
        });
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyRepeatEvent) {
      return KeyEventResult.handled;
    }

    if (event is KeyDownEvent) {
      return _handleKeyDown(event);
    } else if (event is KeyUpEvent) {
      return _handleKeyUp(event);
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleKeyDown(KeyDownEvent event) {
    final DateTime now = DateTime.now();
    if (_lastKeyEventTime != null &&
        now.difference(_lastKeyEventTime!) < Duration(milliseconds: 100)) {
      return KeyEventResult.handled;
    }
    _lastKeyEventTime = now;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.select:
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.mediaPlayPause:
        _togglePlayPause();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _startSeek(_seekStep);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _startSeek(-_seekStep);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _stopSeek(Duration.zero);
        _changeEpisode(_currentEpisodeIndex - 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _stopSeek(Duration.zero);
        _changeEpisode(_currentEpisodeIndex + 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        _stopSeek(Duration.zero);
        if (_showSourcePanel) {
          setState(() => _showSourcePanel = false);
          return KeyEventResult.handled;
        }
        context.pop();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.contextMenu:
        _stopSeek(Duration.zero);
        setState(() {
          _showSourcePanel = !_showSourcePanel;
          if (_showSourcePanel) {
            _sourcePanelFocusedIndex = _currentSourceIndex;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _sourcePanelFocusNode.requestFocus();
              _scrollSourcePanelToFocusedIndex();
              _testAllSources();
            });
          }
        });
        return KeyEventResult.handled;
      case LogicalKeyboardKey.audioVolumeUp:
        final double newVolume = (_volume + 5).clamp(0.0, 100.0);
        _player.setVolume(newVolume);
        _displayVolumeHUD(newVolume);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.audioVolumeDown:
        final double newVolume = (_volume - 5).clamp(0.0, 100.0);
        _player.setVolume(newVolume);
        _displayVolumeHUD(newVolume);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.audioVolumeMute:
        final double newVolume = _volume > 0 ? 0.0 : 100.0;
        _player.setVolume(newVolume);
        _displayVolumeHUD(newVolume);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  KeyEventResult _handleKeyUp(KeyUpEvent event) {
    if (_isLongPressing) {
      _stopSeek(Duration.zero);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    return hours > 0
        ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_showSourcePanel,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && _showSourcePanel) {
          setState(() => _showSourcePanel = false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Shortcuts(
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.select):
                const ActivateIntent(),
            const SingleActivator(LogicalKeyboardKey.enter):
                const ActivateIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowUp): const UpIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowDown):
                const DownIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowLeft):
                const LeftIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowRight):
                const RightIntent(),
            const SingleActivator(LogicalKeyboardKey.mediaPlayPause):
                const PlayPauseIntent(),
            const SingleActivator(LogicalKeyboardKey.escape): const BackIntent(),
          },
          child: Actions(
            actions: {
              BackIntent: CallbackAction<BackIntent>(
                onInvoke: (intent) {
                  if (_showSourcePanel) {
                    setState(() => _showSourcePanel = false);
                    return null;
                  }
                  context.pop();
                  return null;
                },
              ),
            PlayPauseIntent: CallbackAction<PlayPauseIntent>(
              onInvoke: (intent) {
                _togglePlayPause();
                return null;
              },
            ),
          },
          child: Stack(
            children: [
              _buildPlayerWidget(),
              ValueListenableBuilder<bool>(
                valueListenable: _isBuffering,
                builder: (context, buffering, child) {
                  return Visibility(
                    visible: buffering,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '正在缓冲...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _controlsVisibility,
                builder: (context, visible, child) {
                  return Visibility(
                    visible: visible,
                    child: _buildTopGradient(),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _controlsVisibility,
                builder: (context, visible, child) {
                  return Visibility(
                    visible: visible,
                    child: _buildBottomControls(),
                  );
                },
              ),
              _buildSeekIndicator(),
              if (_showVolumeHUD) _buildVolumeHUD(),
              if (_showSourcePanel) _buildSourcePanel(),
            ],
          ),
        ),
      ),
    ),
    );
  }

  String _getSourceName(Map<String, dynamic> source) {
    final dynamic s = source['source'];
    if (s is Map && s['name'] != null) return s['name'] as String;
    return '源${_sources.indexOf(source) + 1}';
  }

  static const Duration _sourceTestTimeout = Duration(seconds: 10);

  /// 对单个源测速并检测 m3u8 可用性
  Future<void> _testOneSource(int index) async {
    if (index < 0 || index >= _sources.length) return;
    setState(() => _sourceTestingIndices.add(index));
    int? speedMs;
    bool m3u8Ok = false;
    try {
      final List<Map<String, String>> eps =
          _parseEpisodesFromPlayUrl(_sources[index]);
      final String? url =
          eps.isNotEmpty ? eps[0]['url'] : null;
      if (url == null || url.isEmpty) {
        if (mounted) {
          setState(() {
            _sourceTestingIndices.remove(index);
            _sourceTestResults[index] = _SourceTestResult(
              speedMs: null,
              speedKbps: null,
              m3u8Ok: false,
            );
          });
        }
        return;
      }
      final Stopwatch stopwatch = Stopwatch()..start();
      final http.Response response = await http
          .get(Uri.parse(url))
          .timeout(_sourceTestTimeout);
      stopwatch.stop();
      speedMs = stopwatch.elapsedMilliseconds;
      final String body = response.body.trim();
      final int bodyBytes = response.bodyBytes.length;
      m3u8Ok = response.statusCode == 200 && body.contains('#EXTM3U');
      double? speedKbps;
      if (speedMs > 0 && bodyBytes > 0) {
        speedKbps = bodyBytes / 1024 / (speedMs / 1000);
      }
      if (mounted) {
        setState(() {
          _sourceTestingIndices.remove(index);
          _sourceTestResults[index] = _SourceTestResult(
            speedMs: speedMs,
            speedKbps: speedKbps,
            m3u8Ok: m3u8Ok,
          );
        });
      }
    } catch (e) {
      _log.d(() => '源$index 测试失败: $e');
      if (mounted) {
        setState(() {
          _sourceTestingIndices.remove(index);
          _sourceTestResults[index] = _SourceTestResult(
            speedMs: speedMs,
            speedKbps: null,
            m3u8Ok: false,
          );
        });
      }
    }
  }

  /// 对全部源并发测速并检测 m3u8 可用性
  void _testAllSources() {
    _sourceTestResults.clear();
    _sourceTestingIndices.clear();
    setState(() {});
    for (int i = 0; i < _sources.length; i++) {
      _testOneSource(i);
    }
  }

  /// 将换源面板列表滚动到当前焦点项（按真实高度），使键盘上下移动焦点时可见
  void _scrollSourcePanelToFocusedIndex() {
    const Duration duration = Duration(milliseconds: 200);
    const Curve curve = Curves.easeInOut;
    void doEnsureVisible() {
      if (!mounted || _sourcePanelFocusedIndex >= _sourceItemKeys.length) return;
      final BuildContext? itemContext =
          _sourceItemKeys[_sourcePanelFocusedIndex].currentContext;
      if (itemContext != null) {
        Scrollable.ensureVisible(
          itemContext,
          alignment: 0.5,
          duration: duration,
          curve: curve,
        );
        return;
      }
      if (!_sourcePanelScrollController.hasClients) return;
      final double maxExtent =
          _sourcePanelScrollController.position.maxScrollExtent;
      final double estimatedOffset = (_sourcePanelFocusedIndex *
              _sourceListItemHeightFallback)
          .clamp(0.0, maxExtent);
      _sourcePanelScrollController
          .animateTo(estimatedOffset, duration: duration, curve: curve)
          .then((_) {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) => doEnsureVisible());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => doEnsureVisible());
  }

  Widget _buildSourcePanel() {
    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      width: 320,
      child: Focus(
        focusNode: _sourcePanelFocusNode,
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowUp:
              setState(() {
                _sourcePanelFocusedIndex =
                    (_sourcePanelFocusedIndex - 1).clamp(0, _sources.length - 1);
              });
              _scrollSourcePanelToFocusedIndex();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowDown:
              setState(() {
                _sourcePanelFocusedIndex =
                    (_sourcePanelFocusedIndex + 1).clamp(0, _sources.length - 1);
              });
              _scrollSourcePanelToFocusedIndex();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.select:
            case LogicalKeyboardKey.enter:
              _switchToSource(_sourcePanelFocusedIndex);
              return KeyEventResult.handled;
            case LogicalKeyboardKey.escape:
            case LogicalKeyboardKey.contextMenu:
              setState(() => _showSourcePanel = false);
              return KeyEventResult.handled;
            default:
              return KeyEventResult.ignored;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: const Offset(-4, 0),
              ),
            ],
          ),
          child: SafeArea(
            left: false,
            top: false,
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '换源',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _sourcePanelScrollController,
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: MediaQuery.paddingOf(context).bottom,
                    ),
                    itemCount: _sources.length,
                    itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> source = _sources[index];
                    final String name = _getSourceName(source);
                    final List<Map<String, String>> eps =
                        _parseEpisodesFromPlayUrl(source);
                    final bool isCurrent = index == _currentSourceIndex;
                    final bool isFocused = index == _sourcePanelFocusedIndex;
                    final String pic = source['vod_pic'] as String? ?? '';
                    final String title =
                        source['vod_name'] as String? ?? '未知';
                    return KeyedSubtree(
                      key: _sourceItemKeys[index],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Material(
                        color: isFocused
                            ? Colors.white24
                            : (isCurrent ? Colors.white12 : Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => _switchToSource(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    pic,
                                    width: 64,
                                    height: 88,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 64,
                                      height: 88,
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.movie_outlined,
                                        color: Colors.white54,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Chip(
                                        label: Text(
                                          name,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: Colors.white24,
                                        padding: EdgeInsets.zero,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '共${eps.length}集',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildSourceTestStatus(index),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    );
                  },
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTestStatus(int index) {
    final bool testing = _sourceTestingIndices.contains(index);
    final _SourceTestResult? result = _sourceTestResults[index];
    if (testing) {
      return Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '测试中...',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      );
    }
    if (result == null) {
      return const SizedBox.shrink();
    }
    const double fontSize = 11.0;
    const Color speedColor = Colors.greenAccent;
    const Color delayColor = Colors.orange;
    final String speedStr = result.speedKbps != null
        ? '${result.speedKbps!.toStringAsFixed(1)} KB/s'
        : '-- KB/s';
    final String delayStr = result.speedMs != null
        ? '${result.speedMs}ms'
        : '--ms';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '下载速度 $speedStr',
          style: TextStyle(
            color: speedColor.withValues(alpha: 0.95),
            fontSize: fontSize,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '延迟 $delayStr',
          style: TextStyle(
            color: delayColor.withValues(alpha: 0.95),
            fontSize: fontSize,
          ),
        ),
        if (!result.m3u8Ok)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'm3u8 不可用',
              style: TextStyle(
                color: Colors.redAccent.withValues(alpha: 0.9),
                fontSize: fontSize - 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerWidget() {
    return Focus(
      autofocus: true,
      focusNode: _playerFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Center(
        child: _isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(height: 16),
                  Text('正在加载视频...', style: TextStyle(color: Colors.white)),
                ],
              )
            : _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _initializePlayer(
                      _episodes[_currentEpisodeIndex]['url']!,
                    ),
                    child: const Text('重试'),
                  ),
                ],
              )
            : RepaintBoundary(
                child: Video(
                  controller: _videoController,
                  controls: null,
                  wakelock: false,
                ),
              ),
      ),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 100,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 140,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder<Duration>(
                valueListenable: _progressPosition,
                builder: (BuildContext context, Duration position, Widget? child) {
                  final Duration duration = _player.state.duration;
                  return LinearProgressIndicator(
                    value: duration.inMilliseconds > 0
                        ? position.inMilliseconds / duration.inMilliseconds
                        : 0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.theme.colorScheme.secondary,
                    ),
                    backgroundColor: Colors.grey[600],
                    minHeight: 4,
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '长按左右方向键可快进/快退',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _player.state.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () =>
                            _changeEpisode(_currentEpisodeIndex - 1),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () =>
                            _changeEpisode(_currentEpisodeIndex + 1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _volume == 0 ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          final double newVolume = _volume > 0 ? 0.0 : 50.0;
                          _player.setVolume(newVolume);
                          _displayVolumeHUD(newVolume);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekIndicator() {
    return ValueListenableBuilder<Duration?>(
      valueListenable: _seekPosition,
      builder: (context, seekPos, child) {
        if (seekPos == null) return const SizedBox.shrink();

        return Positioned(
          left: 0,
          right: 0,
          bottom: 140,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: _seekDirection,
              builder: (context, direction, child) {
                return AnimatedOpacity(
                  opacity: _isSeeking.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          direction > 0
                              ? Icons.fast_forward
                              : Icons.fast_rewind,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(seekPos),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / ${_formatDuration(_player.state.duration)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        if (_currentSeekSpeed > _seekStep)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'x${(_currentSeekSpeed.inSeconds / _seekStep.inSeconds).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildVolumeHUD() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 140,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _volume == 0 ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: _volume,
                  backgroundColor: Colors.grey[600],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单个源的测速与 m3u8 可用性结果
class _SourceTestResult {
  const _SourceTestResult({
    required this.speedMs,
    required this.speedKbps,
    required this.m3u8Ok,
  });
  /// 延迟（毫秒）
  final int? speedMs;
  /// 下载速度（KB/s）
  final double? speedKbps;
  final bool m3u8Ok;
}

Future<String> _processM3u8Url(String url) async {
  if (!url.toLowerCase().endsWith('.m3u8')) return url;

  try {
    final M3U8AdRemoverResult result = await M3U8AdRemover.removeAds(url);
    
    if (result.error != null) {
      _log.e(() => 'M3U8处理失败: ${result.error}');
      return url;
    }

    final String? cleanM3u8 = await M3U8AdRemover.getCleanedContent(url);
    if (cleanM3u8 == null) {
      _log.w(() => '无法获取清理后的M3U8内容');
      return url;
    }

    final Directory dir = await getTemporaryDirectory();
    final File file = File(
      '${dir.path}/cleaned_${DateTime.now().millisecondsSinceEpoch}.m3u8',
    );
    await file.writeAsString(cleanM3u8);

    if (!cleanM3u8.contains('#EXTM3U')) {
      throw Exception('Invalid M3U8: Missing #EXTM3U');
    }

    _log.d(() => 'Cleaned M3U8 saved to: ${file.path}, '
        'ads=${result.adCount}, content=${result.contentCount}');
    return file.uri.toString();
  } catch (e) {
    _log.e(() => 'M3U8处理失败，使用原始URL', e);
    return url;
  }
}

