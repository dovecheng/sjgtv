import '../../../analyzer.dart';
import '../../../coder.dart';

extension ClassModelExt on ClassModel {
  /// import 引用
  Reference getRefer() => refer(name, file.packageUri);

  /// import 别名
  String getScope(Allocate scope) => scope(getRefer());
}
