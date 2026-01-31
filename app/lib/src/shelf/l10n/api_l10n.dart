import 'package:base/l10n.dart';

@L10nKeys(
  keysPrefix: 'shelf_api',
  keysDesc: 'shelf 本地 API 接口的错误消息和返回消息',
)
abstract interface class ShelfApiL10n {
  // --- 错误消息 ---
  @L10nKey(
    en: 'Failed to get source list',
    zh_CN: '获取源列表失败',
    zh_HK: '獲取源列表失敗',
    keyDesc: '获取源列表接口错误',
    keyType: L10nKeyType.error,
  )
  String get getSourceListFailL10n;

  @L10nKey(
    en: 'Name and URL are required',
    zh_CN: '名称和URL不能为空',
    zh_HK: '名稱和URL不能為空',
    keyDesc: '源添加/更新参数校验',
    keyType: L10nKeyType.error,
  )
  String get nameAndUrlRequiredL10n;

  @L10nKey(
    en: 'Please enter a valid URL',
    zh_CN: '请输入有效的URL地址',
    zh_HK: '請輸入有效的URL地址',
    keyDesc: 'URL 格式校验',
    keyType: L10nKeyType.error,
  )
  String get invalidUrlL10n;

  @L10nKey(
    en: 'ID parameter is required',
    zh_CN: '缺少ID参数',
    zh_HK: '缺少ID參數',
    keyDesc: '缺少 ID 参数',
    keyType: L10nKeyType.error,
  )
  String get idRequiredL10n;

  @L10nKey(
    en: 'Source not found',
    zh_CN: '源不存在',
    zh_HK: '源不存在',
    keyDesc: '源不存在',
    keyType: L10nKeyType.error,
  )
  String get sourceNotFoundL10n;

  @L10nKey(
    en: 'Failed to get proxy list',
    zh_CN: '获取代理列表失败',
    zh_HK: '獲取代理列表失敗',
    keyDesc: '获取代理列表接口错误',
    keyType: L10nKeyType.error,
  )
  String get getProxyListFailL10n;

  @L10nKey(
    en: 'URL is required',
    zh_CN: 'URL不能为空',
    zh_HK: 'URL不能為空',
    keyDesc: '代理 URL 必填',
    keyType: L10nKeyType.error,
  )
  String get urlRequiredL10n;

  @L10nKey(
    en: 'Proxy name is required',
    zh_CN: '代理名称不能为空',
    zh_HK: '代理名稱不能為空',
    keyDesc: '代理名称必填',
    keyType: L10nKeyType.error,
  )
  String get proxyNameRequiredL10n;

  @L10nKey(
    en: 'Failed to get tag list',
    zh_CN: '获取标签列表失败',
    zh_HK: '獲取標籤列表失敗',
    keyDesc: '获取标签列表接口错误',
    keyType: L10nKeyType.error,
  )
  String get getTagListFailL10n;

  @L10nKey(
    en: 'Tag name is required',
    zh_CN: '标签名称不能为空',
    zh_HK: '標籤名稱不能為空',
    keyDesc: '标签名称必填',
    keyType: L10nKeyType.error,
  )
  String get tagNameRequiredL10n;

  @L10nKey(
    en: 'ID and name are required',
    zh_CN: 'ID和名称不能为空',
    zh_HK: 'ID和名稱不能為空',
    keyDesc: '标签更新参数校验',
    keyType: L10nKeyType.error,
  )
  String get idAndNameRequiredL10n;

  @L10nKey(
    en: 'Tag not found',
    zh_CN: '标签不存在',
    zh_HK: '標籤不存在',
    keyDesc: '标签不存在',
    keyType: L10nKeyType.error,
  )
  String get tagNotFoundL10n;

  @L10nKey(
    en: 'Tag IDs array is required',
    zh_CN: '需要标签ID数组',
    zh_HK: '需要標籤ID數組',
    keyDesc: '标签顺序更新参数',
    keyType: L10nKeyType.error,
  )
  String get tagIdsArrayRequiredL10n;

  @L10nKey(
    en: 'No available sources',
    zh_CN: '没有可用的源',
    zh_HK: '沒有可用的源',
    keyDesc: '搜索时无可用数据源',
    keyType: L10nKeyType.message,
  )
  String get noAvailableSourcesL10n;

  @L10nKey(
    en: 'No results found',
    zh_CN: '未找到相关内容',
    zh_HK: '未找到相關內容',
    keyDesc: '搜索无结果',
    keyType: L10nKeyType.message,
  )
  String get noSearchResultsL10n;

  @L10nKey(
    en: 'Search failed',
    zh_CN: '搜索失败',
    zh_HK: '搜索失敗',
    keyDesc: '搜索接口错误',
    keyType: L10nKeyType.error,
  )
  String get searchFailL10n;

  @L10nKey(
    en: 'Failed to get translations',
    zh_CN: '获取翻译失败',
    zh_HK: '獲取翻譯失敗',
    keyDesc: '获取网页翻译接口错误',
    keyType: L10nKeyType.error,
  )
  String get getL10nFailL10n;

  // --- 成功消息 ---
  @L10nKey(
    en: 'Source added successfully',
    zh_CN: '源添加成功',
    zh_HK: '源添加成功',
    keyDesc: '源添加成功',
    keyType: L10nKeyType.message,
  )
  String get sourceAddSuccessL10n;

  @L10nKey(
    en: 'Source updated successfully',
    zh_CN: '源更新成功',
    zh_HK: '源更新成功',
    keyDesc: '源更新成功',
    keyType: L10nKeyType.message,
  )
  String get sourceUpdateSuccessL10n;

  @L10nKey(
    en: 'Proxy added successfully',
    zh_CN: '代理添加成功',
    zh_HK: '代理添加成功',
    keyDesc: '代理添加成功',
    keyType: L10nKeyType.message,
  )
  String get proxyAddSuccessL10n;

  @L10nKey(
    en: 'Tag added successfully',
    zh_CN: '标签添加成功',
    zh_HK: '標籤添加成功',
    keyDesc: '标签添加成功',
    keyType: L10nKeyType.message,
  )
  String get tagAddSuccessL10n;

  @L10nKey(
    en: 'Tag updated successfully',
    zh_CN: '标签更新成功',
    zh_HK: '標籤更新成功',
    keyDesc: '标签更新成功',
    keyType: L10nKeyType.message,
  )
  String get tagUpdateSuccessL10n;

  @L10nKey(
    en: 'Tag order updated successfully',
    zh_CN: '标签顺序更新成功',
    zh_HK: '標籤順序更新成功',
    keyDesc: '标签顺序更新成功',
    keyType: L10nKeyType.message,
  )
  String get tagOrderUpdateSuccessL10n;

  @L10nKey(
    en: 'Data list',
    zh_CN: '数据列表',
    zh_HK: '數據列表',
    keyDesc: '搜索返回数据列表',
    keyType: L10nKeyType.message,
  )
  String get dataListL10n;
}
