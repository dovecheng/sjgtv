import 'package:base/l10n.dart';

/// 网页管理页面（index.html）专属国际化
///
/// keysPrefix: web，与 Flutter 的 source_l10n、tag、proxy 等分离，
/// 避免共用导致职责不清。
@L10nKeys(
  keysPrefix: 'web',
  keysDesc: 'shelf 服务网页（index.html）文案，含源/标签/代理管理',
)
abstract interface class WebL10n {
  // --- 头部 ---
  @L10nKey(
    en: 'AppleCMS Source Manage',
    zh_CN: '苹果CMS源管理',
    zh_HK: '蘋果CMS源管理',
    keyDesc: '网页标题',
    keyType: L10nKeyType.label,
  )
  String get pageTitleL10n;

  @L10nKey(en: 'Refresh', zh_CN: '刷新', zh_HK: '刷新', keyDesc: '刷新按钮', keyType: L10nKeyType.label)
  String get refreshL10n;

  // --- 统计 ---
  @L10nKey(en: 'Total Sources', zh_CN: '总源数量', zh_HK: '總源數量', keyDesc: '统计标签', keyType: L10nKeyType.label)
  String get totalSourcesL10n;

  @L10nKey(en: 'Active Sources', zh_CN: '活跃源', zh_HK: '活躍源', keyDesc: '统计标签', keyType: L10nKeyType.label)
  String get activeSourcesL10n;

  @L10nKey(en: 'Average Weight', zh_CN: '平均权重', zh_HK: '平均權重', keyDesc: '统计标签', keyType: L10nKeyType.label)
  String get averageWeightL10n;

  // --- 搜索 ---
  @L10nKey(
    en: 'Search by name or API URL...',
    zh_CN: '输入名称或API地址搜索...',
    zh_HK: '輸入名稱或API地址搜索...',
    keyDesc: '搜索框占位',
    keyType: L10nKeyType.label,
  )
  String get searchPlaceholderL10n;

  @L10nKey(en: 'Search', zh_CN: '搜索', zh_HK: '搜索', keyDesc: '搜索按钮', keyType: L10nKeyType.label)
  String get searchL10n;

  @L10nKey(en: 'Reset', zh_CN: '重置', zh_HK: '重置', keyDesc: '重置按钮', keyType: L10nKeyType.label)
  String get resetL10n;

  // --- 标签管理 ---
  @L10nKey(en: 'Tag Manage', zh_CN: '标签管理', zh_HK: '標籤管理', keyDesc: '卡片标题', keyType: L10nKeyType.label)
  String get tagManageTitleL10n;

  @L10nKey(en: 'Tag Name', zh_CN: '标签名称', zh_HK: '標籤名稱', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get tagNameL10n;

  @L10nKey(en: 'e.g. Movie', zh_CN: '例如: 电影', zh_HK: '例如: 電影', keyDesc: '标签名称占位', keyType: L10nKeyType.label)
  String get tagNamePlaceholderL10n;

  @L10nKey(en: 'Tag Color', zh_CN: '标签颜色', zh_HK: '標籤顏色', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get tagColorL10n;

  @L10nKey(en: 'Pick color', zh_CN: '选择颜色', zh_HK: '選擇顏色', keyDesc: '颜色选择器', keyType: L10nKeyType.label)
  String get pickColorL10n;

  @L10nKey(en: 'Save Tag', zh_CN: '保存标签', zh_HK: '保存標籤', keyDesc: '保存标签按钮', keyType: L10nKeyType.label)
  String get saveTagL10n;

  // --- 添加源 ---
  @L10nKey(en: 'Add New Source', zh_CN: '添加新源', zh_HK: '添加新源', keyDesc: '卡片/按钮', keyType: L10nKeyType.label)
  String get addSourceTitleL10n;

  @L10nKey(en: 'Add Source', zh_CN: '添加源', zh_HK: '添加源', keyDesc: '添加按钮', keyType: L10nKeyType.label)
  String get addSourceL10n;

  @L10nKey(en: 'Source Name', zh_CN: '源名称', zh_HK: '源名稱', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get sourceNameL10n;

  @L10nKey(
    en: 'e.g. Movie Heaven',
    zh_CN: '例如: 电影天堂资源',
    zh_HK: '例如: 電影天堂資源',
    keyDesc: '源名称占位',
    keyType: L10nKeyType.label,
  )
  String get sourceNamePlaceholderL10n;

  @L10nKey(en: 'API Base URL', zh_CN: 'API基础地址', zh_HK: 'API基礎地址', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get apiBaseUrlL10n;

  @L10nKey(
    en: 'Enter base URL, e.g. https://example.com/',
    zh_CN: '只需输入基础地址，如 https://caiji.dyttzyapi.com/',
    zh_HK: '只需輸入基礎地址，如 https://caiji.dyttzyapi.com/',
    keyDesc: 'API地址占位/提示',
    keyType: L10nKeyType.label,
  )
  String get apiBaseUrlPlaceholderL10n;

  @L10nKey(
    en: 'Enter base URL only',
    zh_CN: '只需输入基础地址，如 https://caiji.dyttzyapi.com/',
    zh_HK: '只需輸入基礎地址',
    keyDesc: 'API地址form-text',
    keyType: L10nKeyType.label,
  )
  String get apiBaseUrlHintL10n;

  @L10nKey(en: 'Weight (1-10)', zh_CN: '权重 (1-10)', zh_HK: '權重 (1-10)', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get weightLabelL10n;

  @L10nKey(
    en: 'Higher weight ranks first',
    zh_CN: '权重越高，排序越靠前',
    zh_HK: '權重越高，排序越靠前',
    keyDesc: '权重提示',
    keyType: L10nKeyType.label,
  )
  String get weightHintL10n;

  // --- 源列表 ---
  @L10nKey(en: 'Source List', zh_CN: '源列表', zh_HK: '源列表', keyDesc: '卡片标题', keyType: L10nKeyType.label)
  String get sourceListTitleL10n;

  @L10nKey(en: 'Name', zh_CN: '名称', zh_HK: '名稱', keyDesc: '表头', keyType: L10nKeyType.label)
  String get nameL10n;

  @L10nKey(en: 'API URL', zh_CN: 'API地址', zh_HK: 'API地址', keyDesc: '表头', keyType: L10nKeyType.label)
  String get apiUrlL10n;

  @L10nKey(en: 'Weight', zh_CN: '权重', zh_HK: '權重', keyDesc: '表头', keyType: L10nKeyType.label)
  String get weightL10n;

  @L10nKey(en: 'Status', zh_CN: '状态', zh_HK: '狀態', keyDesc: '表头', keyType: L10nKeyType.label)
  String get statusL10n;

  @L10nKey(en: 'Actions', zh_CN: '操作', zh_HK: '操作', keyDesc: '表头', keyType: L10nKeyType.label)
  String get actionsL10n;

  @L10nKey(en: 'Disabled', zh_CN: '已禁用', zh_HK: '已禁用', keyDesc: '状态', keyType: L10nKeyType.label)
  String get disabledL10n;

  @L10nKey(en: 'Enabled', zh_CN: '已启用', zh_HK: '已啟用', keyDesc: '状态', keyType: L10nKeyType.label)
  String get enabledL10n;

  @L10nKey(en: 'Enable', zh_CN: '启用', zh_HK: '啟用', keyDesc: '按钮', keyType: L10nKeyType.label)
  String get enableL10n;

  @L10nKey(en: 'Disable', zh_CN: '禁用', zh_HK: '禁用', keyDesc: '按钮', keyType: L10nKeyType.label)
  String get disableL10n;

  @L10nKey(en: 'Delete', zh_CN: '删除', zh_HK: '刪除', keyDesc: '按钮', keyType: L10nKeyType.label)
  String get deleteL10n;

  // --- 代理 ---
  @L10nKey(en: 'Proxy Settings', zh_CN: '代理设置', zh_HK: '代理設置', keyDesc: '卡片标题', keyType: L10nKeyType.label)
  String get proxySettingsTitleL10n;

  @L10nKey(
    en: 'No proxy configured',
    zh_CN: '当前未设置代理',
    zh_HK: '當前未設置代理',
    keyDesc: '空态',
    keyType: L10nKeyType.message,
  )
  String get noProxyL10n;

  @L10nKey(en: 'Add Proxy', zh_CN: '添加代理', zh_HK: '添加代理', keyDesc: '按钮', keyType: L10nKeyType.label)
  String get addProxyL10n;

  @L10nKey(en: 'Proxy Name', zh_CN: '代理名称', zh_HK: '代理名稱', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get proxyNameL10n;

  @L10nKey(
    en: 'e.g. HK Node',
    zh_CN: '例如: 香港节点',
    zh_HK: '例如: 香港節點',
    keyDesc: '代理名称占位',
    keyType: L10nKeyType.label,
  )
  String get proxyNamePlaceholderL10n;

  @L10nKey(en: 'Proxy URL', zh_CN: '代理地址', zh_HK: '代理地址', keyDesc: '表单标签', keyType: L10nKeyType.label)
  String get proxyUrlL10n;

  @L10nKey(
    en: 'http://proxy.example.com:8080',
    zh_CN: 'http://proxy.example.com:8080',
    zh_HK: 'http://proxy.example.com:8080',
    keyDesc: '代理地址占位',
    keyType: L10nKeyType.label,
  )
  String get proxyUrlPlaceholderL10n;

  // --- 通用 ---
  @L10nKey(en: 'Save', zh_CN: '保存', zh_HK: '保存', keyDesc: '保存按钮', keyType: L10nKeyType.label)
  String get saveL10n;

  @L10nKey(en: 'Cancel', zh_CN: '取消', zh_HK: '取消', keyDesc: '取消按钮', keyType: L10nKeyType.label)
  String get cancelL10n;

  @L10nKey(en: 'Close', zh_CN: '关闭', zh_HK: '關閉', keyDesc: '关闭按钮 aria-label', keyType: L10nKeyType.label)
  String get closeL10n;

  @L10nKey(en: 'Loading...', zh_CN: '加载中...', zh_HK: '載入中...', keyDesc: '加载态', keyType: L10nKeyType.message)
  String get loadingL10n;

  @L10nKey(en: 'Processing...', zh_CN: '处理中...', zh_HK: '處理中...', keyDesc: '提交中', keyType: L10nKeyType.message)
  String get processingL10n;

  @L10nKey(
    en: 'Load failed, please refresh',
    zh_CN: '加载失败，请刷新重试',
    zh_HK: '載入失敗，請重新整理',
    keyDesc: '加载失败提示',
    keyType: L10nKeyType.message,
  )
  String get loadFailedRetryL10n;

  @L10nKey(
    en: 'No data, please add',
    zh_CN: '暂无数据，请添加源',
    zh_HK: '暫無數據，請添加源',
    keyDesc: '源列表空态',
    keyType: L10nKeyType.message,
  )
  String get noDataAddSourceL10n;

  @L10nKey(
    en: 'Confirm Delete',
    zh_CN: '确认删除',
    zh_HK: '確認刪除',
    keyDesc: '确认按钮',
    keyType: L10nKeyType.label,
  )
  String get confirmDeleteL10n;

  @L10nKey(
    en: 'Cannot undo after delete',
    zh_CN: '此操作无法撤销',
    zh_HK: '此操作無法撤銷',
    keyDesc: '删除确认后缀',
    keyType: L10nKeyType.message,
  )
  String get cannotUndoL10n;

  // --- 消息（JS showMessage）---
  @L10nKey(en: 'Source list loaded', zh_CN: '源列表加载成功', zh_HK: '源列表載入成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgSourceListLoadedL10n;

  @L10nKey(en: 'Failed to load source list', zh_CN: '加载源列表失败', zh_HK: '載入源列表失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgSourceListLoadFailL10n;

  @L10nKey(en: 'No matching sources', zh_CN: '没有找到匹配的源', zh_HK: '沒有找到匹配的源', keyDesc: '警告消息', keyType: L10nKeyType.message)
  String get msgNoMatchL10n;

  @L10nKey(en: 'Search reset', zh_CN: '搜索已重置', zh_HK: '搜索已重置', keyDesc: '提示消息', keyType: L10nKeyType.message)
  String get msgSearchResetL10n;

  @L10nKey(en: 'Please enter source name', zh_CN: '请输入源名称', zh_HK: '請輸入源名稱', keyDesc: '校验消息', keyType: L10nKeyType.message)
  String get msgEnterSourceNameL10n;

  @L10nKey(en: 'Please enter API URL', zh_CN: '请输入API地址', zh_HK: '請輸入API地址', keyDesc: '校验消息', keyType: L10nKeyType.message)
  String get msgEnterApiUrlL10n;

  @L10nKey(en: 'Weight must be 1-10', zh_CN: '权重必须在1-10之间', zh_HK: '權重必須在1-10之間', keyDesc: '校验消息', keyType: L10nKeyType.message)
  String get msgWeightRangeL10n;

  @L10nKey(en: 'Source added', zh_CN: '源添加成功', zh_HK: '源添加成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgSourceAddedL10n;

  @L10nKey(en: 'Add failed', zh_CN: '添加失败', zh_HK: '添加失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgAddFailL10n;

  @L10nKey(en: 'Source disabled', zh_CN: '源已禁用', zh_HK: '源已禁用', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgSourceDisabledL10n;

  @L10nKey(en: 'Source enabled', zh_CN: '源已启用', zh_HK: '源已啟用', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgSourceEnabledL10n;

  @L10nKey(en: 'Status update failed', zh_CN: '状态更新失败', zh_HK: '狀態更新失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgStatusUpdateFailL10n;

  @L10nKey(en: 'Operation failed', zh_CN: '操作失败', zh_HK: '操作失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgOperationFailL10n;

  @L10nKey(en: 'Delete source "{name}"?', zh_CN: '确定要删除源 "{name}" 吗？', zh_HK: '確定要刪除源 "{name}" 嗎？', keyDesc: '删除确认', keyType: L10nKeyType.message)
  String get msgConfirmDeleteSourceL10n;

  @L10nKey(en: 'Deleted', zh_CN: '删除成功', zh_HK: '刪除成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgDeletedL10n;

  @L10nKey(en: 'Delete failed', zh_CN: '删除失败', zh_HK: '刪除失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgDeleteFailL10n;

  @L10nKey(en: 'Proxy loaded', zh_CN: '代理设置加载成功', zh_HK: '代理設置載入成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgProxyLoadedL10n;

  @L10nKey(en: 'Failed to load proxy', zh_CN: '加载代理设置失败', zh_HK: '載入代理設置失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgProxyLoadFailL10n;

  @L10nKey(en: 'Proxy enabled', zh_CN: '代理已启用', zh_HK: '代理已啟用', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgProxyEnabledL10n;

  @L10nKey(en: 'Proxy disabled', zh_CN: '代理已禁用', zh_HK: '代理已禁用', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgProxyDisabledL10n;

  @L10nKey(en: 'Delete proxy "{name}"?', zh_CN: '确定要删除代理 "{name}" 吗？', zh_HK: '確定要刪除代理 "{name}" 嗎？', keyDesc: '删除确认', keyType: L10nKeyType.message)
  String get msgConfirmDeleteProxyL10n;

  @L10nKey(en: 'Proxy deleted', zh_CN: '代理删除成功', zh_HK: '代理刪除成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgProxyDeletedL10n;

  @L10nKey(en: 'Please fill proxy info', zh_CN: '请填写完整的代理信息', zh_HK: '請填寫完整的代理資訊', keyDesc: '校验消息', keyType: L10nKeyType.message)
  String get msgProxyInfoRequiredL10n;

  @L10nKey(en: 'Proxy saved', zh_CN: '代理设置成功', zh_HK: '代理設置成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgProxySavedL10n;

  @L10nKey(en: 'Failed to save proxy', zh_CN: '保存代理失败', zh_HK: '保存代理失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgProxySaveFailL10n;

  @L10nKey(en: 'Tag list loaded', zh_CN: '标签列表加载成功', zh_HK: '標籤列表載入成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgTagListLoadedL10n;

  @L10nKey(en: 'Failed to load tag list', zh_CN: '加载标签列表失败', zh_HK: '載入標籤列表失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgTagListLoadFailL10n;

  @L10nKey(
    en: 'No tags, please add',
    zh_CN: '暂无标签，请添加',
    zh_HK: '暫無標籤，請添加',
    keyDesc: '标签空态',
    keyType: L10nKeyType.message,
  )
  String get msgNoTagsAddL10n;

  @L10nKey(en: 'Tag order updated', zh_CN: '标签顺序已更新', zh_HK: '標籤順序已更新', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgTagOrderUpdatedL10n;

  @L10nKey(en: 'Failed to update tag order', zh_CN: '更新标签顺序失败', zh_HK: '更新標籤順序失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgTagOrderUpdateFailL10n;

  @L10nKey(en: 'Please enter tag name', zh_CN: '请输入标签名称', zh_HK: '請輸入標籤名稱', keyDesc: '校验消息', keyType: L10nKeyType.message)
  String get msgEnterTagNameL10n;

  @L10nKey(en: 'Tag updated', zh_CN: '标签更新成功', zh_HK: '標籤更新成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgTagUpdatedL10n;

  @L10nKey(en: 'Tag added', zh_CN: '标签添加成功', zh_HK: '標籤添加成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgTagAddedL10n;

  @L10nKey(en: 'Failed to update tag', zh_CN: '更新标签失败', zh_HK: '更新標籤失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgTagUpdateFailL10n;

  @L10nKey(en: 'Failed to add tag', zh_CN: '添加标签失败', zh_HK: '添加標籤失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgTagAddFailL10n;

  @L10nKey(en: 'Delete tag "{name}"?', zh_CN: '确定要删除标签 "{name}" 吗？', zh_HK: '確定要刪除標籤 "{name}" 嗎？', keyDesc: '删除确认', keyType: L10nKeyType.message)
  String get msgConfirmDeleteTagL10n;

  @L10nKey(en: 'Tag deleted', zh_CN: '标签删除成功', zh_HK: '標籤刪除成功', keyDesc: '成功消息', keyType: L10nKeyType.message)
  String get msgTagDeletedL10n;

  @L10nKey(en: 'Failed to delete tag', zh_CN: '删除标签失败', zh_HK: '刪除標籤失敗', keyDesc: '错误消息', keyType: L10nKeyType.message)
  String get msgTagDeleteFailL10n;
}
