import 'package:base/api.dart';
import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/api/service/api_service.dart';
import 'package:sjgtv/src/app/provider/api_service_provider.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';

final Log _log = Log('AddSourcePage');

/// 添加数据源页
///
/// 表单：名称、地址；提交调用 ApiService.addSource，成功后返回列表并刷新。
class AddSourcePage extends ConsumerStatefulWidget {
  const AddSourcePage({super.key});

  @override
  ConsumerState<AddSourcePage> createState() => _AddSourcePageState();
}

class _AddSourcePageState extends ConsumerState<AddSourcePage> {
  ApiService get _apiService => ref.read(apiServiceProvider);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _saveFocus = FocusNode();

  bool _isSubmitting = false;
  String? _errorText;

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
      final ApiResultModel<Source> result = await _apiService.addSource(
        <String, dynamic>{'name': name, 'url': url},
      );
      if (!mounted) return;
      if (result.isSuccess) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() {
        _errorText = result.message ?? '添加失败';
        _isSubmitting = false;
      });
    } catch (e, s) {
      _log.e(() => '添加源失败', e, s);
      if (!mounted) return;
      setState(() {
        _errorText = e.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appThemeColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('添加数据源'),
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
                labelText: '名称',
                labelStyle: TextStyle(color: colors.hint),
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_urlFocus),
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
                labelText: '地址（http 或 https）',
                labelStyle: TextStyle(color: colors.hint),
                hintText: 'https://example.com/',
                hintStyle: TextStyle(color: colors.hint),
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
              ),
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_saveFocus),
            ),
            if (_errorText != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                _errorText!,
                style: TextStyle(color: colors.error, fontSize: 14),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.maybePop(context),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 16),
                Focus(
                  focusNode: _saveFocus,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.black87,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('保存'),
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
