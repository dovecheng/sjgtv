import 'package:base/api.dart';
import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/api/service/api_service.dart';
import 'package:sjgtv/src/app/provider/api_service_provider.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/page/source/add_source_page.dart';

final Log _log = Log('SourceManagePage');

/// 源管理页
///
/// 功能：
/// - 从本地 shelf 服务获取数据源列表
/// - 展示名称、地址、启用状态
/// - 支持切换启用/禁用、TV 遥控器焦点
class SourceManagePage extends ConsumerStatefulWidget {
  const SourceManagePage({super.key});

  @override
  ConsumerState<SourceManagePage> createState() => _SourceManagePageState();
}

class _SourceManagePageState extends ConsumerState<SourceManagePage> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  List<Source> _sources = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final ApiListResultModel<Source> result = await _apiService.getSources();
      if (!mounted) return;
      if (result.isSuccess && result.data != null) {
        setState(() {
          _sources = result.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.message ?? '获取源列表失败';
          _isLoading = false;
        });
      }
    } catch (e, s) {
      _log.e(() => '获取源列表失败', e, s);
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSource(Source source) async {
    try {
      final ApiResultModel<Source> result =
          await _apiService.toggleSource(source.id);
      if (result.isSuccess) {
        await _loadSources();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message ?? '操作失败')),
          );
        }
      }
    } catch (e) {
      _log.e(() => '切换源状态失败', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('源管理'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
          focusColor: Colors.red,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '添加数据源',
            onPressed: () async {
              final bool? added = await Navigator.of(context).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) => const AddSourcePage(),
                ),
              );
              if (added == true && mounted) {
                _loadSources();
              }
            },
            focusColor: Colors.red,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _loadSources,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _sources.isEmpty
                  ? const Center(
                      child: Text(
                        '暂无数据源',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      itemCount: _sources.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Source source = _sources[index];
                        return Focus(
                          onKeyEvent: (FocusNode node, KeyEvent event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey.keyLabel == 'Select') {
                              _toggleSource(source);
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                source.name,
                                style: TextStyle(
                                  color: source.disabled
                                      ? Colors.white54
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  source.url,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: Icon(
                                source.disabled ? Icons.toggle_off : Icons.toggle_on,
                                color: source.disabled
                                    ? Colors.white38
                                    : colors.primary,
                                size: 36,
                              ),
                              onTap: () => _toggleSource(source),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
