/// 国际化Key类型
enum L10nKeyType {
  unknown('未知', 'unknown'),

  /// 普通文本
  label('界面标签', 'Display Label'),

  /// 提示消息
  message('提示信息', 'Prompt Label'),

  /// 表单验证
  verify('验证消息', 'Verification Label'),

  /// 错误信息
  error('错误消息', 'Error Label');

  /// Key类型描述 方便后台导入
  final String keyTypeDesc;

  /// Key类型用途 方便后台导入
  final String keyTypeUsage;

  const L10nKeyType(this.keyTypeDesc, this.keyTypeUsage);
}
