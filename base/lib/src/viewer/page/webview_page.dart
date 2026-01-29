import 'package:base/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 通用 Webview 页面, 用于打开隐私条款, 用户协议等网页.
class WebViewPage extends StatefulWidget {
  final String? title;

  final String? url;

  const WebViewPage({super.key, this.title, this.url});

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final WebViewController _webviewController = WebViewController();

  /// 页面标题
  String? _title;

  /// 当网页可以后退时, 才显示关闭按钮
  bool _canClose = false;

  @override
  void initState() {
    super.initState();

    _webviewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webviewController.setBackgroundColor(Colors.white);
    _webviewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String val) {
          Future.wait([
            _webviewController.getTitle().then((value) => _title = value),
            _webviewController.canGoBack().then((value) => _canClose = value),
          ]).then((_) => setState(() {}));
        },
      ),
    );

    log.d(() => 'load url ${widget.url}');
    widget.url?.let(Uri.tryParse)?.let(_webviewController.loadRequest);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (await _webviewController.canGoBack() == true) {
          log.d(() => '网页后退');
          await _webviewController.goBack();
        } else if (context.mounted && !didPop) {
          log.d(() => '退出页面');
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? _title ?? ''),
          actions: [if (_canClose) const CloseButton()],
        ),
        body: RefreshIndicator(
          child: WebViewWidget(
            controller: _webviewController,
            gestureRecognizers: {
              // 允许点击
              const Factory<TapGestureRecognizer>(TapGestureRecognizer.new),
              // 允许长按
              Factory<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
              ),
              // 允许拖动
              const Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new),
            },
          ),
          onRefresh: () async {
            if (await _webviewController.currentUrl() != null) {
              await _webviewController.reload();
            } else {
              await widget.url
                  ?.let(Uri.tryParse)
                  ?.let(_webviewController.loadRequest);
            }
          },
        ),
      ),
    );
  }
}
