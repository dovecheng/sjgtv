import 'package:base/log.dart';
import 'package:base/viewer.dart';

void main() {
  Log log = Log('test_mime');

  log.d(() => '${MimeTypeModel.supported.length}');

  log.d(() => '${MimeTypeModel.lookupMimeType('1.txt')}');
  log.d(() => '${MimeTypeModel.lookupMimeType('Txt')}');
  log.d(() => '${MimeTypeModel.lookupMimeType('1.exe')}');

  log.d(() => '${MimeTypeModel.lookupMimeType('123.pdf')}');
  log.d(() => '${MimeTypeModel.lookupMimeType('123.doc')}');

  MimeTypeModel? mimeType = MimeTypeModel.lookupMimeType('123.doc');

  // 判断支持不支持
  if (mimeType != null && mimeType.isSupported == true) {
    // 判断 mime类型
    switch (mimeType.type) {
      // 文档类型 安卓需要判断后缀
      case 'application':
      // if ios 打开webview

      // else if 安卓
      //   if pdf 谷歌url
      //   else doc 微软url
      case 'video':
      case 'audio':
        // 播放器
        break;
      case 'text':
        // webview
        break;
    }
  }
}
