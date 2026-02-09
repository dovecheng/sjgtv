// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '苹果CMS电影播放器';

  @override
  String get watchHistory => '观看历史';

  @override
  String get noWatchHistory => '暂无观看历史';

  @override
  String get clearAll => '清空';

  @override
  String get clearAllHistory => '清空历史';

  @override
  String get clearAllHistoryConfirm => '确定要清空所有观看历史吗？';

  @override
  String get deleteHistory => '删除历史';

  @override
  String get deleteHistoryConfirm => '确定要删除这条观看历史吗？';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get shelfApiDataList => '数据列表';

  @override
  String get shelfApiGetL10nFail => '获取翻译失败';

  @override
  String get shelfApiGetProxyListFail => '获取代理列表失败';

  @override
  String get shelfApiGetSourceListFail => '获取源列表失败';

  @override
  String get shelfApiGetTagListFail => '获取标签列表失败';

  @override
  String get shelfApiIdAndNameRequired => 'ID和名称不能为空';

  @override
  String get shelfApiIdRequired => '缺少ID参数';

  @override
  String get shelfApiInvalidUrl => '请输入有效的URL地址';

  @override
  String get shelfApiNameAndUrlRequired => '名称和URL不能为空';

  @override
  String get shelfApiNoAvailableSources => '没有可用的源';

  @override
  String get shelfApiNoSearchResults => '未找到相关内容';

  @override
  String get shelfApiProxyAddSuccess => '代理添加成功';

  @override
  String get shelfApiProxyNameRequired => '代理名称不能为空';

  @override
  String get shelfApiSearchFail => '搜索失败';

  @override
  String get shelfApiSourceAddSuccess => '源添加成功';

  @override
  String get shelfApiSourceNotFound => '源不存在';

  @override
  String get shelfApiSourceUpdateSuccess => '源更新成功';

  @override
  String get shelfApiTagAddSuccess => '标签添加成功';

  @override
  String get shelfApiTagIdsArrayRequired => '需要标签ID数组';

  @override
  String get shelfApiTagNameRequired => '标签名称不能为空';

  @override
  String get shelfApiTagNotFound => '标签不存在';

  @override
  String get shelfApiTagOrderUpdateSuccess => '标签顺序更新成功';

  @override
  String get shelfApiTagUpdateSuccess => '标签更新成功';

  @override
  String get shelfApiUrlRequired => 'URL不能为空';

  @override
  String get sourceAddTitle => '添加数据源';

  @override
  String get sourceEditTitle => '编辑源';

  @override
  String get sourceDeleteTitle => '删除源';

  @override
  String get sourceConfirmDelete => '确认删除';

  @override
  String get sourceDeleted => '已删除';

  @override
  String get sourceDeleteFail => '删除失败';

  @override
  String get sourceOperationFail => '操作失败';

  @override
  String get sourceCancel => '取消';

  @override
  String get sourceListTitle => '源列表';

  @override
  String get sourceManageTitle => '源管理';

  @override
  String get sourceName => '名称';

  @override
  String get sourceNoSources => '暂无数据源';

  @override
  String get sourceRetry => '重试';

  @override
  String get sourceSave => '保存';

  @override
  String get sourceUrlHint => '地址（http 或 https）';

  @override
  String get updateCheckerAutoUpdate => '自动更新';

  @override
  String get updateCheckerCancelDownload => '取消下载';

  @override
  String get updateCheckerDownloadFail => '下载失败';

  @override
  String get updateCheckerDownloading => '下载中';

  @override
  String get updateCheckerInstallFail => '安装失败';

  @override
  String get updateCheckerInstallPermissionRequired => '需要允许安装未知应用才能安装更新';

  @override
  String get updateCheckerLater => '稍后再说';

  @override
  String get updateCheckerManualUpdate => '手动更新';

  @override
  String get updateCheckerNewVersionTitle => '发现新版本';

  @override
  String get updateCheckerNoNotes => '暂无更新说明';

  @override
  String get updateCheckerStorageRequired => '需要存储权限才能下载更新';

  @override
  String get updateCheckerUpdateContent => '更新内容:';

  @override
  String get updateCheckerUserCancelDownload => '用户取消下载';

  @override
  String get webActions => '操作';

  @override
  String get webActiveSources => '活跃源';

  @override
  String get webAddProxy => '添加代理';

  @override
  String get webAddSource => '添加源';

  @override
  String get webAddSourceTitle => '添加新源';

  @override
  String get webApiBaseUrl => 'API基础地址';

  @override
  String get webApiBaseUrlHint => '只需输入基础地址，如 https://caiji.dyttzyapi.com/';

  @override
  String get webApiBaseUrlPlaceholder =>
      '只需输入基础地址，如 https://caiji.dyttzyapi.com/';

  @override
  String get webApiUrl => 'API地址';

  @override
  String get webAverageWeight => '平均权重';

  @override
  String get webCancel => '取消';

  @override
  String get webCannotUndo => '此操作无法撤销';

  @override
  String get webClose => '关闭';

  @override
  String get webConfirmDelete => '确认删除';

  @override
  String get webDelete => '删除';

  @override
  String get webDisable => '禁用';

  @override
  String get webDisabled => '已禁用';

  @override
  String get webEnable => '启用';

  @override
  String get webEnabled => '已启用';

  @override
  String get webLoadFailedRetry => '加载失败，请刷新重试';

  @override
  String get webLoading => '加载中...';

  @override
  String get webMsgAddFail => '添加失败';

  @override
  String webMsgConfirmDeleteProxy(String name) {
    return '确定要删除代理 $name 吗？';
  }

  @override
  String webMsgConfirmDeleteSource(String name) {
    return '确定要删除源 $name 吗？';
  }

  @override
  String webMsgConfirmDeleteTag(String name) {
    return '确定要删除标签 $name 吗？';
  }

  @override
  String get webMsgDeleteFail => '删除失败';

  @override
  String get webMsgDeleted => '删除成功';

  @override
  String get webMsgEnterApiUrl => '请输入API地址';

  @override
  String get webMsgEnterSourceName => '请输入源名称';

  @override
  String get webMsgEnterTagName => '请输入标签名称';

  @override
  String get webMsgNoMatch => '没有找到匹配的源';

  @override
  String get webMsgNoTagsAdd => '暂无标签，请添加';

  @override
  String get webMsgOperationFail => '操作失败';

  @override
  String get webMsgProxyDeleted => '代理删除成功';

  @override
  String get webMsgProxyDisabled => '代理已禁用';

  @override
  String get webMsgProxyEnabled => '代理已启用';

  @override
  String get webMsgProxyInfoRequired => '请填写完整的代理信息';

  @override
  String get webMsgProxyLoadFail => '加载代理设置失败';

  @override
  String get webMsgProxyLoaded => '代理设置加载成功';

  @override
  String get webMsgProxySaveFail => '保存代理失败';

  @override
  String get webMsgProxySaved => '代理设置成功';

  @override
  String get webMsgSearchReset => '搜索已重置';

  @override
  String get webMsgSourceAdded => '源添加成功';

  @override
  String get webMsgSourceDisabled => '源已禁用';

  @override
  String get webMsgSourceEnabled => '源已启用';

  @override
  String get webMsgSourceListLoadFail => '加载源列表失败';

  @override
  String get webMsgSourceListLoaded => '源列表加载成功';

  @override
  String get webMsgStatusUpdateFail => '状态更新失败';

  @override
  String get webMsgTagAddFail => '添加标签失败';

  @override
  String get webMsgTagAdded => '标签添加成功';

  @override
  String get webMsgTagDeleteFail => '删除标签失败';

  @override
  String get webMsgTagDeleted => '标签删除成功';

  @override
  String get webMsgTagListLoadFail => '加载标签列表失败';

  @override
  String get webMsgTagListLoaded => '标签列表加载成功';

  @override
  String get webMsgTagOrderUpdateFail => '更新标签顺序失败';

  @override
  String get webMsgTagOrderUpdated => '标签顺序已更新';

  @override
  String get webMsgTagUpdateFail => '更新标签失败';

  @override
  String get webMsgTagUpdated => '标签更新成功';

  @override
  String get webMsgWeightRange => '权重必须在1-10之间';

  @override
  String get webName => '名称';

  @override
  String get webNoDataAddSource => '暂无数据，请添加源';

  @override
  String get webNoProxy => '当前未设置代理';

  @override
  String get webPageTitle => '苹果CMS源管理';

  @override
  String get webPickColor => '选择颜色';

  @override
  String get webProcessing => '处理中...';

  @override
  String get webProxyName => '代理名称';

  @override
  String get webProxyNamePlaceholder => '例如: 香港节点';

  @override
  String get webProxySettingsTitle => '代理设置';

  @override
  String get webProxyUrl => '代理地址';

  @override
  String get webProxyUrlPlaceholder => 'http://proxy.example.com:8080';

  @override
  String get webRefresh => '刷新';

  @override
  String get webReset => '重置';

  @override
  String get webSave => '保存';

  @override
  String get webSaveTag => '保存标签';

  @override
  String get webSearch => '搜索';

  @override
  String get webSearchPlaceholder => '输入名称或API地址搜索...';

  @override
  String get webSourceListTitle => '源列表';

  @override
  String get webSourceName => '源名称';

  @override
  String get webSourceNamePlaceholder => '例如: 电影天堂资源';

  @override
  String get webStatus => '状态';

  @override
  String get webTagColor => '标签颜色';

  @override
  String get webTagManageTitle => '标签管理';

  @override
  String get webTagName => '标签名称';

  @override
  String get webTagNamePlaceholder => '例如: 电影';

  @override
  String get webTotalSources => '总源数量';

  @override
  String get webWeight => '权重';

  @override
  String get webWeightHint => '权重越高，排序越靠前';

  @override
  String get webWeightLabel => '权重 (1-10)';

  @override
  String get favorites => '收藏';

  @override
  String get clearAllFavorites => '清空收藏';

  @override
  String get clearAllFavoritesConfirm => '确认清空所有收藏？';

  @override
  String get noFavorites => '暂无收藏';

  @override
  String get deleteFavorite => '删除收藏';

  @override
  String get deleteFavoriteConfirm => '确认删除此收藏？';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => '苹果CMS电影播放器';

  @override
  String get watchHistory => '观看历史';

  @override
  String get noWatchHistory => '暂无观看历史';

  @override
  String get clearAll => '清空';

  @override
  String get clearAllHistory => '清空历史';

  @override
  String get clearAllHistoryConfirm => '确定要清空所有观看历史吗？';

  @override
  String get deleteHistory => '删除历史';

  @override
  String get deleteHistoryConfirm => '确定要删除这条观看历史吗？';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get shelfApiDataList => '数据列表';

  @override
  String get shelfApiGetL10nFail => '获取翻译失败';

  @override
  String get shelfApiGetProxyListFail => '获取代理列表失败';

  @override
  String get shelfApiGetSourceListFail => '获取源列表失败';

  @override
  String get shelfApiGetTagListFail => '获取标签列表失败';

  @override
  String get shelfApiIdAndNameRequired => 'ID和名称不能为空';

  @override
  String get shelfApiIdRequired => '缺少ID参数';

  @override
  String get shelfApiInvalidUrl => '请输入有效的URL地址';

  @override
  String get shelfApiNameAndUrlRequired => '名称和URL不能为空';

  @override
  String get shelfApiNoAvailableSources => '没有可用的源';

  @override
  String get shelfApiNoSearchResults => '未找到相关内容';

  @override
  String get shelfApiProxyAddSuccess => '代理添加成功';

  @override
  String get shelfApiProxyNameRequired => '代理名称不能为空';

  @override
  String get shelfApiSearchFail => '搜索失败';

  @override
  String get shelfApiSourceAddSuccess => '源添加成功';

  @override
  String get shelfApiSourceNotFound => '源不存在';

  @override
  String get shelfApiSourceUpdateSuccess => '源更新成功';

  @override
  String get shelfApiTagAddSuccess => '标签添加成功';

  @override
  String get shelfApiTagIdsArrayRequired => '需要标签ID数组';

  @override
  String get shelfApiTagNameRequired => '标签名称不能为空';

  @override
  String get shelfApiTagNotFound => '标签不存在';

  @override
  String get shelfApiTagOrderUpdateSuccess => '标签顺序更新成功';

  @override
  String get shelfApiTagUpdateSuccess => '标签更新成功';

  @override
  String get shelfApiUrlRequired => 'URL不能为空';

  @override
  String get sourceAddTitle => '添加数据源';

  @override
  String get sourceEditTitle => '编辑源';

  @override
  String get sourceDeleteTitle => '删除源';

  @override
  String get sourceConfirmDelete => '确认删除';

  @override
  String get sourceDeleted => '已删除';

  @override
  String get sourceDeleteFail => '删除失败';

  @override
  String get sourceOperationFail => '操作失败';

  @override
  String get sourceCancel => '取消';

  @override
  String get sourceListTitle => '源列表';

  @override
  String get sourceManageTitle => '源管理';

  @override
  String get sourceName => '名称';

  @override
  String get sourceNoSources => '暂无数据源';

  @override
  String get sourceRetry => '重试';

  @override
  String get sourceSave => '保存';

  @override
  String get sourceUrlHint => '地址（http 或 https）';

  @override
  String get updateCheckerAutoUpdate => '自动更新';

  @override
  String get updateCheckerCancelDownload => '取消下载';

  @override
  String get updateCheckerDownloadFail => '下载失败';

  @override
  String get updateCheckerDownloading => '下载中';

  @override
  String get updateCheckerInstallFail => '安装失败';

  @override
  String get updateCheckerInstallPermissionRequired => '需要允许安装未知应用才能安装更新';

  @override
  String get updateCheckerLater => '稍后再说';

  @override
  String get updateCheckerManualUpdate => '手动更新';

  @override
  String get updateCheckerNewVersionTitle => '发现新版本';

  @override
  String get updateCheckerNoNotes => '暂无更新说明';

  @override
  String get updateCheckerStorageRequired => '需要存储权限才能下载更新';

  @override
  String get updateCheckerUpdateContent => '更新内容:';

  @override
  String get updateCheckerUserCancelDownload => '用户取消下载';

  @override
  String get webActions => '操作';

  @override
  String get webActiveSources => '活跃源';

  @override
  String get webAddProxy => '添加代理';

  @override
  String get webAddSource => '添加源';

  @override
  String get webAddSourceTitle => '添加新源';

  @override
  String get webApiBaseUrl => 'API基础地址';

  @override
  String get webApiBaseUrlHint => '只需输入基础地址，如 https://caiji.dyttzyapi.com/';

  @override
  String get webApiBaseUrlPlaceholder =>
      '只需输入基础地址，如 https://caiji.dyttzyapi.com/';

  @override
  String get webApiUrl => 'API地址';

  @override
  String get webAverageWeight => '平均权重';

  @override
  String get webCancel => '取消';

  @override
  String get webCannotUndo => '此操作无法撤销';

  @override
  String get webClose => '关闭';

  @override
  String get webConfirmDelete => '确认删除';

  @override
  String get webDelete => '删除';

  @override
  String get webDisable => '禁用';

  @override
  String get webDisabled => '已禁用';

  @override
  String get webEnable => '启用';

  @override
  String get webEnabled => '已启用';

  @override
  String get webLoadFailedRetry => '加载失败，请刷新重试';

  @override
  String get webLoading => '加载中...';

  @override
  String get webMsgAddFail => '添加失败';

  @override
  String webMsgConfirmDeleteProxy(String name) {
    return '确定要删除代理 $name 吗？';
  }

  @override
  String webMsgConfirmDeleteSource(String name) {
    return '确定要删除源 $name 吗？';
  }

  @override
  String webMsgConfirmDeleteTag(String name) {
    return '确定要删除标签 $name 吗？';
  }

  @override
  String get webMsgDeleteFail => '删除失败';

  @override
  String get webMsgDeleted => '删除成功';

  @override
  String get webMsgEnterApiUrl => '请输入API地址';

  @override
  String get webMsgEnterSourceName => '请输入源名称';

  @override
  String get webMsgEnterTagName => '请输入标签名称';

  @override
  String get webMsgNoMatch => '没有找到匹配的源';

  @override
  String get webMsgNoTagsAdd => '暂无标签，请添加';

  @override
  String get webMsgOperationFail => '操作失败';

  @override
  String get webMsgProxyDeleted => '代理删除成功';

  @override
  String get webMsgProxyDisabled => '代理已禁用';

  @override
  String get webMsgProxyEnabled => '代理已启用';

  @override
  String get webMsgProxyInfoRequired => '请填写完整的代理信息';

  @override
  String get webMsgProxyLoadFail => '加载代理设置失败';

  @override
  String get webMsgProxyLoaded => '代理设置加载成功';

  @override
  String get webMsgProxySaveFail => '保存代理失败';

  @override
  String get webMsgProxySaved => '代理设置成功';

  @override
  String get webMsgSearchReset => '搜索已重置';

  @override
  String get webMsgSourceAdded => '源添加成功';

  @override
  String get webMsgSourceDisabled => '源已禁用';

  @override
  String get webMsgSourceEnabled => '源已启用';

  @override
  String get webMsgSourceListLoadFail => '加载源列表失败';

  @override
  String get webMsgSourceListLoaded => '源列表加载成功';

  @override
  String get webMsgStatusUpdateFail => '状态更新失败';

  @override
  String get webMsgTagAddFail => '添加标签失败';

  @override
  String get webMsgTagAdded => '标签添加成功';

  @override
  String get webMsgTagDeleteFail => '删除标签失败';

  @override
  String get webMsgTagDeleted => '标签删除成功';

  @override
  String get webMsgTagListLoadFail => '加载标签列表失败';

  @override
  String get webMsgTagListLoaded => '标签列表加载成功';

  @override
  String get webMsgTagOrderUpdateFail => '更新标签顺序失败';

  @override
  String get webMsgTagOrderUpdated => '标签顺序已更新';

  @override
  String get webMsgTagUpdateFail => '更新标签失败';

  @override
  String get webMsgTagUpdated => '标签更新成功';

  @override
  String get webMsgWeightRange => '权重必须在1-10之间';

  @override
  String get webName => '名称';

  @override
  String get webNoDataAddSource => '暂无数据，请添加源';

  @override
  String get webNoProxy => '当前未设置代理';

  @override
  String get webPageTitle => '苹果CMS源管理';

  @override
  String get webPickColor => '选择颜色';

  @override
  String get webProcessing => '处理中...';

  @override
  String get webProxyName => '代理名称';

  @override
  String get webProxyNamePlaceholder => '例如: 香港节点';

  @override
  String get webProxySettingsTitle => '代理设置';

  @override
  String get webProxyUrl => '代理地址';

  @override
  String get webProxyUrlPlaceholder => 'http://proxy.example.com:8080';

  @override
  String get webRefresh => '刷新';

  @override
  String get webReset => '重置';

  @override
  String get webSave => '保存';

  @override
  String get webSaveTag => '保存标签';

  @override
  String get webSearch => '搜索';

  @override
  String get webSearchPlaceholder => '输入名称或API地址搜索...';

  @override
  String get webSourceListTitle => '源列表';

  @override
  String get webSourceName => '源名称';

  @override
  String get webSourceNamePlaceholder => '例如: 电影天堂资源';

  @override
  String get webStatus => '状态';

  @override
  String get webTagColor => '标签颜色';

  @override
  String get webTagManageTitle => '标签管理';

  @override
  String get webTagName => '标签名称';

  @override
  String get webTagNamePlaceholder => '例如: 电影';

  @override
  String get webTotalSources => '总源数量';

  @override
  String get webWeight => '权重';

  @override
  String get webWeightHint => '权重越高，排序越靠前';

  @override
  String get webWeightLabel => '权重 (1-10)';

  @override
  String get favorites => '收藏';

  @override
  String get clearAllFavorites => '清空收藏';

  @override
  String get clearAllFavoritesConfirm => '确认清空所有收藏？';

  @override
  String get noFavorites => '暂无收藏';

  @override
  String get deleteFavorite => '删除收藏';

  @override
  String get deleteFavoriteConfirm => '确认删除此收藏？';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String get appTitle => '蘋果CMS電影播放器';

  @override
  String get watchHistory => '觀看歷史';

  @override
  String get noWatchHistory => '暫無觀看歷史';

  @override
  String get clearAll => '清空';

  @override
  String get clearAllHistory => '清空歷史';

  @override
  String get clearAllHistoryConfirm => '確定要清空所有觀看歷史嗎？';

  @override
  String get deleteHistory => '刪除歷史';

  @override
  String get deleteHistoryConfirm => '確定要刪除這條觀看歷史嗎？';

  @override
  String get confirm => '確定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get shelfApiDataList => '數據列表';

  @override
  String get shelfApiGetL10nFail => '獲取翻譯失敗';

  @override
  String get shelfApiGetProxyListFail => '獲取代理列表失敗';

  @override
  String get shelfApiGetSourceListFail => '獲取源列表失敗';

  @override
  String get shelfApiGetTagListFail => '獲取標籤列表失敗';

  @override
  String get shelfApiIdAndNameRequired => 'ID和名稱不能為空';

  @override
  String get shelfApiIdRequired => '缺少ID參數';

  @override
  String get shelfApiInvalidUrl => '請輸入有效的URL地址';

  @override
  String get shelfApiNameAndUrlRequired => '名稱和URL不能為空';

  @override
  String get shelfApiNoAvailableSources => '沒有可用的源';

  @override
  String get shelfApiNoSearchResults => '未找到相關內容';

  @override
  String get shelfApiProxyAddSuccess => '代理添加成功';

  @override
  String get shelfApiProxyNameRequired => '代理名稱不能為空';

  @override
  String get shelfApiSearchFail => '搜索失敗';

  @override
  String get shelfApiSourceAddSuccess => '源添加成功';

  @override
  String get shelfApiSourceNotFound => '源不存在';

  @override
  String get shelfApiSourceUpdateSuccess => '源更新成功';

  @override
  String get shelfApiTagAddSuccess => '標籤添加成功';

  @override
  String get shelfApiTagIdsArrayRequired => '需要標籤ID數組';

  @override
  String get shelfApiTagNameRequired => '標籤名稱不能為空';

  @override
  String get shelfApiTagNotFound => '標籤不存在';

  @override
  String get shelfApiTagOrderUpdateSuccess => '標籤順序更新成功';

  @override
  String get shelfApiTagUpdateSuccess => '標籤更新成功';

  @override
  String get shelfApiUrlRequired => 'URL不能為空';

  @override
  String get sourceAddTitle => '添加數據源';

  @override
  String get sourceEditTitle => '編輯源';

  @override
  String get sourceDeleteTitle => '刪除源';

  @override
  String get sourceConfirmDelete => '確認刪除';

  @override
  String get sourceDeleted => '已刪除';

  @override
  String get sourceDeleteFail => '刪除失敗';

  @override
  String get sourceOperationFail => '操作失敗';

  @override
  String get sourceCancel => '取消';

  @override
  String get sourceListTitle => '源列表';

  @override
  String get sourceManageTitle => '源管理';

  @override
  String get sourceName => '名稱';

  @override
  String get sourceNoSources => '暫無數據源';

  @override
  String get sourceRetry => '重試';

  @override
  String get sourceSave => '保存';

  @override
  String get sourceUrlHint => '地址（http 或 https）';

  @override
  String get updateCheckerAutoUpdate => '自動更新';

  @override
  String get updateCheckerCancelDownload => '取消下載';

  @override
  String get updateCheckerDownloadFail => '下載失敗';

  @override
  String get updateCheckerDownloading => '下載中';

  @override
  String get updateCheckerInstallFail => '安裝失敗';

  @override
  String get updateCheckerInstallPermissionRequired => '需要允許安裝未知應用才能安裝更新';

  @override
  String get updateCheckerLater => '稍後再說';

  @override
  String get updateCheckerManualUpdate => '手動更新';

  @override
  String get updateCheckerNewVersionTitle => '發現新版本';

  @override
  String get updateCheckerNoNotes => '暫無更新說明';

  @override
  String get updateCheckerStorageRequired => '需要存儲權限才能下載更新';

  @override
  String get updateCheckerUpdateContent => '更新內容:';

  @override
  String get updateCheckerUserCancelDownload => '用戶取消下載';

  @override
  String get webActions => '操作';

  @override
  String get webActiveSources => '活躍源';

  @override
  String get webAddProxy => '添加代理';

  @override
  String get webAddSource => '添加源';

  @override
  String get webAddSourceTitle => '添加新源';

  @override
  String get webApiBaseUrl => 'API基礎地址';

  @override
  String get webApiBaseUrlHint => '只需輸入基礎地址';

  @override
  String get webApiBaseUrlPlaceholder =>
      '只需輸入基礎地址，如 https://caiji.dyttzyapi.com/';

  @override
  String get webApiUrl => 'API地址';

  @override
  String get webAverageWeight => '平均權重';

  @override
  String get webCancel => '取消';

  @override
  String get webCannotUndo => '此操作無法撤銷';

  @override
  String get webClose => '關閉';

  @override
  String get webConfirmDelete => '確認刪除';

  @override
  String get webDelete => '刪除';

  @override
  String get webDisable => '禁用';

  @override
  String get webDisabled => '已禁用';

  @override
  String get webEnable => '啟用';

  @override
  String get webEnabled => '已啟用';

  @override
  String get webLoadFailedRetry => '載入失敗，請重新整理';

  @override
  String get webLoading => '載入中...';

  @override
  String get webMsgAddFail => '添加失敗';

  @override
  String webMsgConfirmDeleteProxy(String name) {
    return '確定要刪除代理 $name 嗎？';
  }

  @override
  String webMsgConfirmDeleteSource(String name) {
    return '確定要刪除源 $name 嗎？';
  }

  @override
  String webMsgConfirmDeleteTag(String name) {
    return '確定要刪除標籤 $name 嗎？';
  }

  @override
  String get webMsgDeleteFail => '刪除失敗';

  @override
  String get webMsgDeleted => '刪除成功';

  @override
  String get webMsgEnterApiUrl => '請輸入API地址';

  @override
  String get webMsgEnterSourceName => '請輸入源名稱';

  @override
  String get webMsgEnterTagName => '請輸入標籤名稱';

  @override
  String get webMsgNoMatch => '沒有找到匹配的源';

  @override
  String get webMsgNoTagsAdd => '暫無標籤，請添加';

  @override
  String get webMsgOperationFail => '操作失敗';

  @override
  String get webMsgProxyDeleted => '代理刪除成功';

  @override
  String get webMsgProxyDisabled => '代理已禁用';

  @override
  String get webMsgProxyEnabled => '代理已啟用';

  @override
  String get webMsgProxyInfoRequired => '請填寫完整的代理資訊';

  @override
  String get webMsgProxyLoadFail => '載入代理設置失敗';

  @override
  String get webMsgProxyLoaded => '代理設置載入成功';

  @override
  String get webMsgProxySaveFail => '保存代理失敗';

  @override
  String get webMsgProxySaved => '代理設置成功';

  @override
  String get webMsgSearchReset => '搜索已重置';

  @override
  String get webMsgSourceAdded => '源添加成功';

  @override
  String get webMsgSourceDisabled => '源已禁用';

  @override
  String get webMsgSourceEnabled => '源已啟用';

  @override
  String get webMsgSourceListLoadFail => '載入源列表失敗';

  @override
  String get webMsgSourceListLoaded => '源列表載入成功';

  @override
  String get webMsgStatusUpdateFail => '狀態更新失敗';

  @override
  String get webMsgTagAddFail => '添加標籤失敗';

  @override
  String get webMsgTagAdded => '標籤添加成功';

  @override
  String get webMsgTagDeleteFail => '刪除標籤失敗';

  @override
  String get webMsgTagDeleted => '標籤刪除成功';

  @override
  String get webMsgTagListLoadFail => '載入標籤列表失敗';

  @override
  String get webMsgTagListLoaded => '標籤列表載入成功';

  @override
  String get webMsgTagOrderUpdateFail => '更新標籤順序失敗';

  @override
  String get webMsgTagOrderUpdated => '標籤順序已更新';

  @override
  String get webMsgTagUpdateFail => '更新標籤失敗';

  @override
  String get webMsgTagUpdated => '標籤更新成功';

  @override
  String get webMsgWeightRange => '權重必須在1-10之間';

  @override
  String get webName => '名稱';

  @override
  String get webNoDataAddSource => '暫無數據，請添加源';

  @override
  String get webNoProxy => '當前未設置代理';

  @override
  String get webPageTitle => '蘋果CMS源管理';

  @override
  String get webPickColor => '選擇顏色';

  @override
  String get webProcessing => '處理中...';

  @override
  String get webProxyName => '代理名稱';

  @override
  String get webProxyNamePlaceholder => '例如: 香港節點';

  @override
  String get webProxySettingsTitle => '代理設置';

  @override
  String get webProxyUrl => '代理地址';

  @override
  String get webProxyUrlPlaceholder => 'http://proxy.example.com:8080';

  @override
  String get webRefresh => '刷新';

  @override
  String get webReset => '重置';

  @override
  String get webSave => '保存';

  @override
  String get webSaveTag => '保存標籤';

  @override
  String get webSearch => '搜索';

  @override
  String get webSearchPlaceholder => '輸入名稱或API地址搜索...';

  @override
  String get webSourceListTitle => '源列表';

  @override
  String get webSourceName => '源名稱';

  @override
  String get webSourceNamePlaceholder => '例如: 電影天堂資源';

  @override
  String get webStatus => '狀態';

  @override
  String get webTagColor => '標籤顏色';

  @override
  String get webTagManageTitle => '標籤管理';

  @override
  String get webTagName => '標籤名稱';

  @override
  String get webTagNamePlaceholder => '例如: 電影';

  @override
  String get webTotalSources => '總源數量';

  @override
  String get webWeight => '權重';

  @override
  String get webWeightHint => '權重越高，排序越靠前';

  @override
  String get webWeightLabel => '權重 (1-10)';

  @override
  String get favorites => '收藏';

  @override
  String get clearAllFavorites => '清空收藏';

  @override
  String get clearAllFavoritesConfirm => '確認清空所有收藏？';

  @override
  String get noFavorites => '暫無收藏';

  @override
  String get deleteFavorite => '刪除收藏';

  @override
  String get deleteFavoriteConfirm => '確認刪除此收藏？';
}
