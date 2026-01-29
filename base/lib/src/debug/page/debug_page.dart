import 'package:base/base.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 调试工具页面
class DebugPage extends StatefulHookConsumerWidget {
  const DebugPage({super.key});

  @override
  ConsumerState<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends ConsumerState<DebugPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = useMemoized(GlobalKey.new);
    ObjectRef<TextEditingController?> proxyController = useRef(null);
    DebugModel model = useMemoized(
      () => ref.read(debugProvider).value!.copyWith(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug tools'),
        actions: [
          // 重置
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
              scaffold.removeCurrentMaterialBanner();
              scaffold.showMaterialBanner(
                MaterialBanner(
                  elevation: 8,
                  content: const Text('Confirm reset to default setting?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        NavigatorState navigator = context.navigator;
                        await ref.read(debugProvider.notifier).reset();
                        scaffold.removeCurrentMaterialBanner();
                        navigator.pop();
                      },
                      child: const Text('reset'),
                    ),
                    TextButton(
                      onPressed: () {
                        scaffold.removeCurrentMaterialBanner();
                      },
                      child: const Text('dismiss'),
                    ),
                  ],
                ),
              );
            },
          ), // 保存
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                model.proxy = proxyController.value?.text;
                if (model.proxy?.isNotEmpty == true &&
                    model.proxyOptions?.contains(model.proxy) != true) {
                  (model.proxyOptions ??= []).add(model.proxy!);
                }
                NavigatorState navigator = context.navigator;
                await ref.read(debugProvider.notifier).saveOrUpdate(model);
                navigator.maybePop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // 代理地址
              if (!kIsWeb) ...[
                buildAutocomplete(
                  context,
                  initialValue: model.proxy,
                  label: 'Proxy',
                  hint: 'IP address and port',
                  helper: 'e.g. 192.168.100.100:8080',
                  onCreated: (TextEditingController controller) =>
                      proxyController.value = controller,
                  validator: (String? text) =>
                      text?.isNotEmpty == true &&
                          !RegExp(
                            r'^((^|\.)([01]?\d{1,2}|2[0-4]\d|2[0-5][0-5])){4}(:([0-5]?\d{0,5}|6[0-5][0-5][0-3][0-6][0-5]))?$',
                          ).hasMatch(text!)
                      ? 'Invalid proxy ip and port'
                      : null,
                  options: [...?model.proxyOptions],
                ),
                const SizedBox(height: 16),
              ],
              // 演示模式开关
              buildSwitch(
                context,
                label: 'Demo mode',
                value: model.demoMode == true,
                onChanged: (bool value) =>
                    setState(() => model.demoMode = !model.demoMode),
              ),
              // 屏幕常亮开关
              buildSwitch(
                context,
                label: 'Keep screen on',
                value: model.keepScreenOn == true,
                onChanged: (bool value) =>
                    setState(() => model.keepScreenOn = !model.keepScreenOn),
              ),
              // 国际化提示开关
              buildSwitch(
                context,
                label: 'Translate key tips',
                value: model.translateKeyTips == true,
                onChanged: (bool value) =>
                    setState(() => model.translateKeyTips = value),
              ),
              // 语言种类定时切换
              buildSwitch(
                context,
                label: 'Languages switcher',
                value: model.switchLanguage == true,
                onChanged: (bool value) =>
                    setState(() => model.switchLanguage = value),
              ),
              // 字体缩放比例定时切换
              buildSwitch(
                context,
                label: 'Text scale switcher',
                value: model.switchTextScale == true,
                onChanged: (bool value) => setState(
                  () => model.switchTextScale = !model.switchTextScale,
                ),
              ),
              // 主题模式定时切换
              buildSwitch(
                context,
                label: 'Theme mode switcher',
                value: model.switchThemeMode == true,
                onChanged: (bool value) =>
                    setState(() => model.switchThemeMode = value),
              ),
              const SizedBox(height: 16),
              // 动画慢放
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Slow animations'),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<double>(
                        alignment: Alignment.centerRight,
                        isDense: true,
                        items: const [0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]
                            .map(
                              (double value) => DropdownMenuItem<double>(
                                value: value,
                                child: Text('${value}x'),
                              ),
                            )
                            .toList(),
                        value: model.timeDilation,
                        onChanged: (double? value) =>
                            setState(() => model.timeDilation = value ?? 1.0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildDebugSeedColor(context, model),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 自动完成输入框
  Widget buildAutocomplete(
    BuildContext context, {
    String? initialValue,
    String? label,
    String? hint,
    String? helper,
    List<String> options = const [],
    FormFieldValidator<String>? validator,
    ValueSetter<TextEditingController>? onCreated,
    ValueChanged<String>? onChanged,
  }) {
    List<String> lowerCaseOptions = options
        .map((String e) => e.toLowerCase())
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Autocomplete<String>(
        initialValue: initialValue?.let((it) => TextEditingValue(text: it)),
        fieldViewBuilder:
            (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) => TextFormField(
              controller: textEditingController.also(
                (TextEditingController it) => onCreated?.call(it),
              ),
              focusNode: focusNode,
              onFieldSubmitted: (String text) => onFieldSubmitted(),
              validator: validator,
              onChanged: (String text) => onChanged?.call(text),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                helperText: helper,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                suffixIcon: IconButton(
                  onPressed: () {
                    textEditingController.clear();
                    onChanged?.call(textEditingController.text);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
        optionsBuilder: (TextEditingValue textEditingValue) {
          String text = textEditingValue.text.trim();
          if (text.isEmpty) {
            return options;
          }
          String lowerCaseText = text.toLowerCase();
          Iterable<MapEntry<int, int>> indexes = lowerCaseOptions
              .mapIndexed(
                (int index, String e) => e
                    .indexOf(lowerCaseText)
                    .let((int it) => it != -1 ? MapEntry(index, it) : null),
              )
              .nonNulls;
          if (indexes.isEmpty) {
            return options;
          }
          return indexes
              .sorted(
                (MapEntry<int, int> a, MapEntry<int, int> b) =>
                    a.value.compareTo(b.value),
              )
              .map((MapEntry<int, int> e) => options[e.key]);
        },
      ),
    );
  }

  /// 切换开关
  Widget buildSwitch(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        MyMaterialTheme2(
          child: Switch(onChanged: onChanged, value: value),
        ),
      ],
    ),
  );

  /// Debug Seed Color
  Widget _buildDebugSeedColor(BuildContext context, DebugModel? model) {
    bool debugSeedColorEnabled = model?.debugSeedColorEnabled == true;
    log.d(() => 'debugSeedColorEnabled:$debugSeedColorEnabled');
    String? debugSeedColor = model?.debugSeedColor;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Column(
        children: [
          /// 是否启用种子颜色
          Row(
            children: [
              const Expanded(child: Text('Enable Seed Color')),
              MyMaterialTheme2(
                child: Switch(
                  onChanged: (value) {
                    setState(() {
                      model?.debugSeedColorEnabled = value;
                    });
                  },
                  value: debugSeedColorEnabled,
                ),
              ),
            ],
          ),

          /// 配置种子颜色
          if (debugSeedColorEnabled) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                const Color defaultPickerColor = Colors.red;
                Color pickerColor = debugSeedColor != null
                    ? debugSeedColor.toColor() ?? defaultPickerColor
                    : defaultPickerColor;
                String? result = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0),
                      contentPadding: const EdgeInsets.all(0),
                      content: SingleChildScrollView(
                        child: MaterialPicker(
                          pickerColor: pickerColor,
                          onColorChanged: (value) {
                            String hexColor = value.toHexString();
                            log.d(() => '选中的颜色:$value, hexColor:$hexColor');
                            context.navigator.pop(hexColor);
                          },
                          // enableLabel: _enableLabel,
                          // portraitOnly: _portraitOnly,
                        ),
                      ),
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    model?.debugSeedColor = result;
                  });
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: Text('Seed Color')),
                  if (debugSeedColor != null)
                    Container(
                      width: 60,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: HexColor(debugSeedColor),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
