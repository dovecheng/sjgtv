import 'package:sjgtv/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/page/source_form_page.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';

final Log _log = Log('SourceManagePage');

/// 源管理页
///
/// 通过 [sourcesProvider] 监听列表，增删改或切换后 [ref.invalidate] 即可自动刷新。
class SourceManagePage extends ConsumerStatefulWidget {
  const SourceManagePage({super.key});

  @override
  ConsumerState<SourceManagePage> createState() => _SourceManagePageState();
}

class _SourceManagePageState extends ConsumerState<SourceManagePage> {
  Future<void> _toggleSource(SourceModel source) async {
    try {
      await ref.read(sourcesProvider.notifier).toggleSource(source.uuid);
      if (mounted) ref.invalidate(sourcesProvider);
    } catch (e) {
      _log.e(() => '切换源状态失败', e);
      if (mounted) {
        final String msg = AppLocalizations.of(context).sourceOperationFail;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$msg: $e')));
      }
    }
  }

  Future<void> _deleteSource(SourceModel source) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String content =
        '${l10n.webMsgConfirmDeleteSource(source.name)} ${l10n.webCannotUndo}';
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l10n.sourceDeleteTitle),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.sourceCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.sourceConfirmDelete),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.sourceDeleted)));
      }
    } catch (e) {
      _log.e(() => '删除源失败', e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.sourceDeleteFail}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = context.theme.colorScheme;
    final AsyncValue<List<SourceModel>> sourcesAsync = ref.watch(
      sourcesProvider,
    );
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.sourceManageTitle),
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
            tooltip: l10n.sourceAddTitle,
            onPressed: () async {
              final bool? added = await Navigator.of(context).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) => const SourceFormPage(),
                ),
              );
              if (added == true && mounted) {
                ref.invalidate(sourcesProvider);
              }
            },
            focusColor: Colors.red,
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
                  child: Text(l10n.sourceRetry),
                ),
              ],
            ),
          );
        },
        data: (List<SourceModel> sources) {
          if (sources.isEmpty) {
            return Center(
              child: Text(
                l10n.sourceNoSources,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        color: source.disabled ? Colors.white54 : Colors.white,
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
                            final bool? updated = await Navigator.of(context)
                                .push<bool>(
                                  MaterialPageRoute<bool>(
                                    builder: (BuildContext context) =>
                                        SourceFormPage(sourceToEdit: source),
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
                          source.disabled ? Icons.toggle_off : Icons.toggle_on,
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
