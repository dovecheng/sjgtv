import 'package:base/l10n.dart';
import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';
import 'package:base/app.dart';
import 'package:sjgtv/src/source/l10n/source_l10n.gen.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/page/source_form_page.dart';

final Log _log = Log('SourceManagePage');

/// 源管理页
///
/// 通过 [sourcesProvider] 监听列表，增删改或切换后 [ref.invalidate] 即可自动刷新。
class SourceManagePage extends ConsumerStatefulWidget {
  const SourceManagePage({super.key});

  @override
  ConsumerState<SourceManagePage> createState() => _SourceManagePageState();
}

class _SourceManagePageState extends ConsumerState<SourceManagePage>
    with SourceL10nMixin {
  Future<void> _toggleSource(SourceModel source) async {
    try {
      await ref.read(sourcesProvider.notifier).toggleSource(source.uuid);
      if (mounted) ref.invalidate(sourcesProvider);
    } catch (e) {
      _log.e(() => '切换源状态失败', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  Future<void> _deleteSource(SourceModel source) async {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('删除源'),
        content: Text('确定要删除源「${source.name}」吗？此操作无法撤销。'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelL10n),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await ref.read(sourcesProvider.notifier).deleteSource(source.uuid);
      if (!mounted) return;
      ref.invalidate(sourcesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已删除')),
        );
      }
    } catch (e) {
      _log.e(() => '删除源失败', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final AsyncValue<List<SourceModel>> sourcesAsync =
        ref.watch(sourcesProvider);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: L10nKeyTips(
          keyTips: manageTitleL10nKey,
          child: Text(manageTitleL10n),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
          focusColor: Colors.red,
        ),
        actions: <Widget>[
          L10nKeyTips(
            keyTips: addTitleL10nKey,
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: addTitleL10n,
              onPressed: () async {
                final bool? added = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (BuildContext context) =>
                        const SourceFormPage(),
                  ),
                );
                if (added == true && mounted) {
                  ref.invalidate(sourcesProvider);
                }
              },
              focusColor: Colors.red,
            ),
          ),
        ],
      ),
      body: sourcesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) {
          _log.e(() => '获取源列表失败', error, stackTrace);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => ref.invalidate(sourcesProvider),
                  child: L10nKeyTips(
                    keyTips: retryL10nKey,
                    child: Text(retryL10n),
                  ),
                ),
              ],
            ),
          );
        },
        data: (List<SourceModel> sources) {
          if (sources.isEmpty) {
            return Center(
              child: L10nKeyTips(
                keyTips: noSourcesL10nKey,
                child: Text(
                  noSourcesL10n,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 18),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            itemCount: sources.length,
            itemBuilder: (BuildContext context, int index) {
              final SourceModel source = sources[index];
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final bool? updated =
                                await Navigator.of(context).push<bool>(
                              MaterialPageRoute<bool>(
                                builder: (BuildContext context) =>
                                    SourceFormPage(
                                  sourceToEdit: source,
                                ),
                              ),
                            );
                            if (updated == true && mounted) {
                                ref.invalidate(sourcesProvider);
                            }
                          },
                          focusColor: Colors.red,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteSource(source),
                          focusColor: Colors.red,
                        ),
                        Icon(
                          source.disabled
                              ? Icons.toggle_off
                              : Icons.toggle_on,
                          color: source.disabled
                              ? Colors.white38
                              : colorScheme.primary,
                          size: 36,
                        ),
                      ],
                    ),
                    onTap: () => _toggleSource(source),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
