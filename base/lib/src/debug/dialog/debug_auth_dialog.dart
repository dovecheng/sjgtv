import 'package:base/app.dart';
import 'package:base/debug.dart';
import 'package:base/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 调试密码输入弹框
class DebugAuthDialog extends HookConsumerWidget {
  /// 显示调试密码输入弹框
  static Future<bool> show() => showDialog<bool>(
    context: AppNavigator.context,
    builder: (BuildContext context) => const DebugAuthDialog(),
  ).then((bool? value) => value == true);

  const DebugAuthDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<FormFieldState<String>> formKey = useMemoized(GlobalKey.new);
    ValueNotifier<bool> validating = useState(false);

    DebugProvider provider = ref.read(debugProvider.notifier);
    DebugModel? model = ref.watch(debugProvider).value;
    bool enable = model?.enable ?? !kReleaseMode;
    String authCode = provider.debugAuthCode;
    String? initialText = enable ? authCode : null;

    return AlertDialog(
      title: const Text('Enable debug tools'),
      content: TextFormField(
        key: formKey,
        initialValue: initialText,
        validator: (String? text) =>
            validating.value && text != authCode ? 'Invalid code' : null,
        decoration: const InputDecoration(
          labelText: 'Auth code',
          hintText: 'Enter code to continue',
        ),
        onChanged: (_) => validating.value = false,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            validating.value = true;
            if (formKey.currentState!.validate()) {
              if (model != null && !model.enable) {
                model.enable = true;
                provider.saveOrUpdate(model);
              }
              Navigator.pop(context, true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
