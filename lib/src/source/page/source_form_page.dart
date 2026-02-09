import 'package:sjgtv/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';
import 'package:uuid/uuid.dart';

final Log _log = Log('SourceFormPage');

/// 添加/编辑数据源页
///
/// 表单：名称、地址；[sourceToEdit] 非空时为编辑模式，预填并提交调用 updateSource。
class SourceFormPage extends ConsumerStatefulWidget {
  const SourceFormPage({super.key, this.sourceToEdit});

  final SourceModel? sourceToEdit;

  @override
  ConsumerState<SourceFormPage> createState() => _SourceFormPageState();
}

class _SourceFormPageState extends ConsumerState<SourceFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _saveFocus = FocusNode();

  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final SourceModel? edit = widget.sourceToEdit;
    if (edit != null) {
      _nameController.text = edit.name;
      _urlController.text = edit.url;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _nameFocus.dispose();
    _urlFocus.dispose();
    _saveFocus.dispose();
    super.dispose();
  }

  bool _isValidUrl(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final Uri? uri = Uri.tryParse(value.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String _normalizeUrl(String urlInput) {
    String url = urlInput.trim();
    if (url.isEmpty) return url;
    if (!url.endsWith('/')) url += '/';
    if (!url.endsWith('api.php/provide/vod')) {
      url += 'api.php/provide/vod';
    }
    return url;
  }

  Future<void> _submit() async {
    final String name = _nameController.text.trim();
    final String url = _urlController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorText = '请输入名称');
      return;
    }
    if (!_isValidUrl(url)) {
      setState(() => _errorText = '请输入有效的 http(s) 地址');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final SourceModel? edit = widget.sourceToEdit;
      final String normalizedUrl = _normalizeUrl(url);
      final SourcesProvider notifier = ref.read(sourcesProvider.notifier);

      if (edit != null) {
        final SourceModel updated = SourceModel(
          uuid: edit.uuid,
          name: name,
          url: normalizedUrl,
          weight: edit.weight,
          disabled: edit.disabled,
          tagIds: List<String>.from(edit.tagIds),
          createdAt: edit.createdAt,
          updatedAt: DateTime.now(),
        );
        await notifier.updateSource(updated);
      } else {
        await notifier.addSource(
          SourceModel(
            uuid: const Uuid().v4(),
            name: name,
            url: normalizedUrl,
            tagIds: const [],
          ),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e, s) {
      _log.e(() => widget.sourceToEdit != null ? '更新源失败' : '添加源失败', e, s);
      if (!mounted) return;
      setState(() {
        _errorText = e.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ColorScheme colorScheme = context.theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.sourceToEdit != null
              ? l10n.sourceEditTitle
              : l10n.sourceAddTitle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSubmitting ? null : () => Navigator.maybePop(context),
          focusColor: Colors.red,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              enabled: !_isSubmitting,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: l10n.sourceName,
                labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_urlFocus),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _urlController,
              focusNode: _urlFocus,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.url,
              autocorrect: false,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: l10n.sourceUrlHint,
                labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                hintText: 'https://example.com/',
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_saveFocus),
            ),
            if (_errorText != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                _errorText!,
                style: TextStyle(color: colorScheme.error, fontSize: 14),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.maybePop(context),
                  child: Text(l10n.sourceCancel),
                ),
                const SizedBox(width: 16),
                Focus(
                  focusNode: _saveFocus,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.black87,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.sourceSave),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
