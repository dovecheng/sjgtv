import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n_gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh', 'CN'),
    Locale('en'),
    Locale('zh', 'HK'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'苹果CMS电影播放器'**
  String get appTitle;

  /// No description provided for @watchHistory.
  ///
  /// In zh_CN, this message translates to:
  /// **'观看历史'**
  String get watchHistory;

  /// No description provided for @noWatchHistory.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无观看历史'**
  String get noWatchHistory;

  /// No description provided for @clearAll.
  ///
  /// In zh_CN, this message translates to:
  /// **'清空'**
  String get clearAll;

  /// No description provided for @clearAllHistory.
  ///
  /// In zh_CN, this message translates to:
  /// **'清空历史'**
  String get clearAllHistory;

  /// No description provided for @clearAllHistoryConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要清空所有观看历史吗？'**
  String get clearAllHistoryConfirm;

  /// No description provided for @deleteHistory.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除历史'**
  String get deleteHistory;

  /// No description provided for @deleteHistoryConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除这条观看历史吗？'**
  String get deleteHistoryConfirm;

  /// No description provided for @confirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @shelfApiDataList.
  ///
  /// In zh_CN, this message translates to:
  /// **'数据列表'**
  String get shelfApiDataList;

  /// No description provided for @shelfApiGetL10nFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'获取翻译失败'**
  String get shelfApiGetL10nFail;

  /// No description provided for @shelfApiGetProxyListFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'获取代理列表失败'**
  String get shelfApiGetProxyListFail;

  /// No description provided for @shelfApiGetSourceListFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'获取源列表失败'**
  String get shelfApiGetSourceListFail;

  /// No description provided for @shelfApiGetTagListFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'获取标签列表失败'**
  String get shelfApiGetTagListFail;

  /// No description provided for @shelfApiIdAndNameRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'ID和名称不能为空'**
  String get shelfApiIdAndNameRequired;

  /// No description provided for @shelfApiIdRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'缺少ID参数'**
  String get shelfApiIdRequired;

  /// No description provided for @shelfApiInvalidUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入有效的URL地址'**
  String get shelfApiInvalidUrl;

  /// No description provided for @shelfApiNameAndUrlRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'名称和URL不能为空'**
  String get shelfApiNameAndUrlRequired;

  /// No description provided for @shelfApiNoAvailableSources.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有可用的源'**
  String get shelfApiNoAvailableSources;

  /// No description provided for @shelfApiNoSearchResults.
  ///
  /// In zh_CN, this message translates to:
  /// **'未找到相关内容'**
  String get shelfApiNoSearchResults;

  /// No description provided for @shelfApiProxyAddSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理添加成功'**
  String get shelfApiProxyAddSuccess;

  /// No description provided for @shelfApiProxyNameRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理名称不能为空'**
  String get shelfApiProxyNameRequired;

  /// No description provided for @shelfApiSearchFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索失败'**
  String get shelfApiSearchFail;

  /// No description provided for @shelfApiSourceAddSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'源添加成功'**
  String get shelfApiSourceAddSuccess;

  /// No description provided for @shelfApiSourceNotFound.
  ///
  /// In zh_CN, this message translates to:
  /// **'源不存在'**
  String get shelfApiSourceNotFound;

  /// No description provided for @shelfApiSourceUpdateSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'源更新成功'**
  String get shelfApiSourceUpdateSuccess;

  /// No description provided for @shelfApiTagAddSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签添加成功'**
  String get shelfApiTagAddSuccess;

  /// No description provided for @shelfApiTagIdsArrayRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'需要标签ID数组'**
  String get shelfApiTagIdsArrayRequired;

  /// No description provided for @shelfApiTagNameRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签名称不能为空'**
  String get shelfApiTagNameRequired;

  /// No description provided for @shelfApiTagNotFound.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签不存在'**
  String get shelfApiTagNotFound;

  /// No description provided for @shelfApiTagOrderUpdateSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签顺序更新成功'**
  String get shelfApiTagOrderUpdateSuccess;

  /// No description provided for @shelfApiTagUpdateSuccess.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签更新成功'**
  String get shelfApiTagUpdateSuccess;

  /// No description provided for @shelfApiUrlRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'URL不能为空'**
  String get shelfApiUrlRequired;

  /// No description provided for @sourceAddTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加数据源'**
  String get sourceAddTitle;

  /// No description provided for @sourceEditTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'编辑源'**
  String get sourceEditTitle;

  /// No description provided for @sourceDeleteTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除源'**
  String get sourceDeleteTitle;

  /// No description provided for @sourceConfirmDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'确认删除'**
  String get sourceConfirmDelete;

  /// No description provided for @sourceDeleted.
  ///
  /// In zh_CN, this message translates to:
  /// **'已删除'**
  String get sourceDeleted;

  /// No description provided for @sourceDeleteFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除失败'**
  String get sourceDeleteFail;

  /// No description provided for @sourceOperationFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'操作失败'**
  String get sourceOperationFail;

  /// No description provided for @sourceCancel.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消'**
  String get sourceCancel;

  /// No description provided for @sourceListTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'源列表'**
  String get sourceListTitle;

  /// No description provided for @sourceManageTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'源管理'**
  String get sourceManageTitle;

  /// No description provided for @sourceName.
  ///
  /// In zh_CN, this message translates to:
  /// **'名称'**
  String get sourceName;

  /// No description provided for @sourceNoSources.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无数据源'**
  String get sourceNoSources;

  /// No description provided for @sourceRetry.
  ///
  /// In zh_CN, this message translates to:
  /// **'重试'**
  String get sourceRetry;

  /// No description provided for @sourceSave.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存'**
  String get sourceSave;

  /// No description provided for @sourceUrlHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'地址（http 或 https）'**
  String get sourceUrlHint;

  /// No description provided for @updateCheckerAutoUpdate.
  ///
  /// In zh_CN, this message translates to:
  /// **'自动更新'**
  String get updateCheckerAutoUpdate;

  /// No description provided for @updateCheckerCancelDownload.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消下载'**
  String get updateCheckerCancelDownload;

  /// No description provided for @updateCheckerDownloadFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'下载失败'**
  String get updateCheckerDownloadFail;

  /// No description provided for @updateCheckerDownloading.
  ///
  /// In zh_CN, this message translates to:
  /// **'下载中'**
  String get updateCheckerDownloading;

  /// No description provided for @updateCheckerInstallFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'安装失败'**
  String get updateCheckerInstallFail;

  /// No description provided for @updateCheckerInstallPermissionRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'需要允许安装未知应用才能安装更新'**
  String get updateCheckerInstallPermissionRequired;

  /// No description provided for @updateCheckerLater.
  ///
  /// In zh_CN, this message translates to:
  /// **'稍后再说'**
  String get updateCheckerLater;

  /// No description provided for @updateCheckerManualUpdate.
  ///
  /// In zh_CN, this message translates to:
  /// **'手动更新'**
  String get updateCheckerManualUpdate;

  /// No description provided for @updateCheckerNewVersionTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'发现新版本'**
  String get updateCheckerNewVersionTitle;

  /// No description provided for @updateCheckerNoNotes.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无更新说明'**
  String get updateCheckerNoNotes;

  /// No description provided for @updateCheckerStorageRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'需要存储权限才能下载更新'**
  String get updateCheckerStorageRequired;

  /// No description provided for @updateCheckerUpdateContent.
  ///
  /// In zh_CN, this message translates to:
  /// **'更新内容:'**
  String get updateCheckerUpdateContent;

  /// No description provided for @updateCheckerUserCancelDownload.
  ///
  /// In zh_CN, this message translates to:
  /// **'用户取消下载'**
  String get updateCheckerUserCancelDownload;

  /// No description provided for @webActions.
  ///
  /// In zh_CN, this message translates to:
  /// **'操作'**
  String get webActions;

  /// No description provided for @webActiveSources.
  ///
  /// In zh_CN, this message translates to:
  /// **'活跃源'**
  String get webActiveSources;

  /// No description provided for @webAddProxy.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加代理'**
  String get webAddProxy;

  /// No description provided for @webAddSource.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加源'**
  String get webAddSource;

  /// No description provided for @webAddSourceTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加新源'**
  String get webAddSourceTitle;

  /// No description provided for @webApiBaseUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'API基础地址'**
  String get webApiBaseUrl;

  /// No description provided for @webApiBaseUrlHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'只需输入基础地址，如 https://caiji.dyttzyapi.com/'**
  String get webApiBaseUrlHint;

  /// No description provided for @webApiBaseUrlPlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'只需输入基础地址，如 https://caiji.dyttzyapi.com/'**
  String get webApiBaseUrlPlaceholder;

  /// No description provided for @webApiUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'API地址'**
  String get webApiUrl;

  /// No description provided for @webAverageWeight.
  ///
  /// In zh_CN, this message translates to:
  /// **'平均权重'**
  String get webAverageWeight;

  /// No description provided for @webCancel.
  ///
  /// In zh_CN, this message translates to:
  /// **'取消'**
  String get webCancel;

  /// No description provided for @webCannotUndo.
  ///
  /// In zh_CN, this message translates to:
  /// **'此操作无法撤销'**
  String get webCannotUndo;

  /// No description provided for @webClose.
  ///
  /// In zh_CN, this message translates to:
  /// **'关闭'**
  String get webClose;

  /// No description provided for @webConfirmDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'确认删除'**
  String get webConfirmDelete;

  /// No description provided for @webDelete.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除'**
  String get webDelete;

  /// No description provided for @webDisable.
  ///
  /// In zh_CN, this message translates to:
  /// **'禁用'**
  String get webDisable;

  /// No description provided for @webDisabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'已禁用'**
  String get webDisabled;

  /// No description provided for @webEnable.
  ///
  /// In zh_CN, this message translates to:
  /// **'启用'**
  String get webEnable;

  /// No description provided for @webEnabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'已启用'**
  String get webEnabled;

  /// No description provided for @webLoadFailedRetry.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载失败，请刷新重试'**
  String get webLoadFailedRetry;

  /// No description provided for @webLoading.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载中...'**
  String get webLoading;

  /// No description provided for @webMsgAddFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加失败'**
  String get webMsgAddFail;

  /// No description provided for @webMsgConfirmDeleteProxy.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除代理 {name} 吗？'**
  String webMsgConfirmDeleteProxy(String name);

  /// No description provided for @webMsgConfirmDeleteSource.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除源 {name} 吗？'**
  String webMsgConfirmDeleteSource(String name);

  /// No description provided for @webMsgConfirmDeleteTag.
  ///
  /// In zh_CN, this message translates to:
  /// **'确定要删除标签 {name} 吗？'**
  String webMsgConfirmDeleteTag(String name);

  /// No description provided for @webMsgDeleteFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除失败'**
  String get webMsgDeleteFail;

  /// No description provided for @webMsgDeleted.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除成功'**
  String get webMsgDeleted;

  /// No description provided for @webMsgEnterApiUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入API地址'**
  String get webMsgEnterApiUrl;

  /// No description provided for @webMsgEnterSourceName.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入源名称'**
  String get webMsgEnterSourceName;

  /// No description provided for @webMsgEnterTagName.
  ///
  /// In zh_CN, this message translates to:
  /// **'请输入标签名称'**
  String get webMsgEnterTagName;

  /// No description provided for @webMsgNoMatch.
  ///
  /// In zh_CN, this message translates to:
  /// **'没有找到匹配的源'**
  String get webMsgNoMatch;

  /// No description provided for @webMsgNoTagsAdd.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无标签，请添加'**
  String get webMsgNoTagsAdd;

  /// No description provided for @webMsgOperationFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'操作失败'**
  String get webMsgOperationFail;

  /// No description provided for @webMsgProxyDeleted.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理删除成功'**
  String get webMsgProxyDeleted;

  /// No description provided for @webMsgProxyDisabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理已禁用'**
  String get webMsgProxyDisabled;

  /// No description provided for @webMsgProxyEnabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理已启用'**
  String get webMsgProxyEnabled;

  /// No description provided for @webMsgProxyInfoRequired.
  ///
  /// In zh_CN, this message translates to:
  /// **'请填写完整的代理信息'**
  String get webMsgProxyInfoRequired;

  /// No description provided for @webMsgProxyLoadFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载代理设置失败'**
  String get webMsgProxyLoadFail;

  /// No description provided for @webMsgProxyLoaded.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理设置加载成功'**
  String get webMsgProxyLoaded;

  /// No description provided for @webMsgProxySaveFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存代理失败'**
  String get webMsgProxySaveFail;

  /// No description provided for @webMsgProxySaved.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理设置成功'**
  String get webMsgProxySaved;

  /// No description provided for @webMsgSearchReset.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索已重置'**
  String get webMsgSearchReset;

  /// No description provided for @webMsgSourceAdded.
  ///
  /// In zh_CN, this message translates to:
  /// **'源添加成功'**
  String get webMsgSourceAdded;

  /// No description provided for @webMsgSourceDisabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'源已禁用'**
  String get webMsgSourceDisabled;

  /// No description provided for @webMsgSourceEnabled.
  ///
  /// In zh_CN, this message translates to:
  /// **'源已启用'**
  String get webMsgSourceEnabled;

  /// No description provided for @webMsgSourceListLoadFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载源列表失败'**
  String get webMsgSourceListLoadFail;

  /// No description provided for @webMsgSourceListLoaded.
  ///
  /// In zh_CN, this message translates to:
  /// **'源列表加载成功'**
  String get webMsgSourceListLoaded;

  /// No description provided for @webMsgStatusUpdateFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'状态更新失败'**
  String get webMsgStatusUpdateFail;

  /// No description provided for @webMsgTagAddFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'添加标签失败'**
  String get webMsgTagAddFail;

  /// No description provided for @webMsgTagAdded.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签添加成功'**
  String get webMsgTagAdded;

  /// No description provided for @webMsgTagDeleteFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除标签失败'**
  String get webMsgTagDeleteFail;

  /// No description provided for @webMsgTagDeleted.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签删除成功'**
  String get webMsgTagDeleted;

  /// No description provided for @webMsgTagListLoadFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'加载标签列表失败'**
  String get webMsgTagListLoadFail;

  /// No description provided for @webMsgTagListLoaded.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签列表加载成功'**
  String get webMsgTagListLoaded;

  /// No description provided for @webMsgTagOrderUpdateFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'更新标签顺序失败'**
  String get webMsgTagOrderUpdateFail;

  /// No description provided for @webMsgTagOrderUpdated.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签顺序已更新'**
  String get webMsgTagOrderUpdated;

  /// No description provided for @webMsgTagUpdateFail.
  ///
  /// In zh_CN, this message translates to:
  /// **'更新标签失败'**
  String get webMsgTagUpdateFail;

  /// No description provided for @webMsgTagUpdated.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签更新成功'**
  String get webMsgTagUpdated;

  /// No description provided for @webMsgWeightRange.
  ///
  /// In zh_CN, this message translates to:
  /// **'权重必须在1-10之间'**
  String get webMsgWeightRange;

  /// No description provided for @webName.
  ///
  /// In zh_CN, this message translates to:
  /// **'名称'**
  String get webName;

  /// No description provided for @webNoDataAddSource.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无数据，请添加源'**
  String get webNoDataAddSource;

  /// No description provided for @webNoProxy.
  ///
  /// In zh_CN, this message translates to:
  /// **'当前未设置代理'**
  String get webNoProxy;

  /// No description provided for @webPageTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'苹果CMS源管理'**
  String get webPageTitle;

  /// No description provided for @webPickColor.
  ///
  /// In zh_CN, this message translates to:
  /// **'选择颜色'**
  String get webPickColor;

  /// No description provided for @webProcessing.
  ///
  /// In zh_CN, this message translates to:
  /// **'处理中...'**
  String get webProcessing;

  /// No description provided for @webProxyName.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理名称'**
  String get webProxyName;

  /// No description provided for @webProxyNamePlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'例如: 香港节点'**
  String get webProxyNamePlaceholder;

  /// No description provided for @webProxySettingsTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理设置'**
  String get webProxySettingsTitle;

  /// No description provided for @webProxyUrl.
  ///
  /// In zh_CN, this message translates to:
  /// **'代理地址'**
  String get webProxyUrl;

  /// No description provided for @webProxyUrlPlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'http://proxy.example.com:8080'**
  String get webProxyUrlPlaceholder;

  /// No description provided for @webRefresh.
  ///
  /// In zh_CN, this message translates to:
  /// **'刷新'**
  String get webRefresh;

  /// No description provided for @webReset.
  ///
  /// In zh_CN, this message translates to:
  /// **'重置'**
  String get webReset;

  /// No description provided for @webSave.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存'**
  String get webSave;

  /// No description provided for @webSaveTag.
  ///
  /// In zh_CN, this message translates to:
  /// **'保存标签'**
  String get webSaveTag;

  /// No description provided for @webSearch.
  ///
  /// In zh_CN, this message translates to:
  /// **'搜索'**
  String get webSearch;

  /// No description provided for @webSearchPlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'输入名称或API地址搜索...'**
  String get webSearchPlaceholder;

  /// No description provided for @webSourceListTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'源列表'**
  String get webSourceListTitle;

  /// No description provided for @webSourceName.
  ///
  /// In zh_CN, this message translates to:
  /// **'源名称'**
  String get webSourceName;

  /// No description provided for @webSourceNamePlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'例如: 电影天堂资源'**
  String get webSourceNamePlaceholder;

  /// No description provided for @webStatus.
  ///
  /// In zh_CN, this message translates to:
  /// **'状态'**
  String get webStatus;

  /// No description provided for @webTagColor.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签颜色'**
  String get webTagColor;

  /// No description provided for @webTagManageTitle.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签管理'**
  String get webTagManageTitle;

  /// No description provided for @webTagName.
  ///
  /// In zh_CN, this message translates to:
  /// **'标签名称'**
  String get webTagName;

  /// No description provided for @webTagNamePlaceholder.
  ///
  /// In zh_CN, this message translates to:
  /// **'例如: 电影'**
  String get webTagNamePlaceholder;

  /// No description provided for @webTotalSources.
  ///
  /// In zh_CN, this message translates to:
  /// **'总源数量'**
  String get webTotalSources;

  /// No description provided for @webWeight.
  ///
  /// In zh_CN, this message translates to:
  /// **'权重'**
  String get webWeight;

  /// No description provided for @webWeightHint.
  ///
  /// In zh_CN, this message translates to:
  /// **'权重越高，排序越靠前'**
  String get webWeightHint;

  /// No description provided for @webWeightLabel.
  ///
  /// In zh_CN, this message translates to:
  /// **'权重 (1-10)'**
  String get webWeightLabel;

  /// No description provided for @favorites.
  ///
  /// In zh_CN, this message translates to:
  /// **'收藏'**
  String get favorites;

  /// No description provided for @clearAllFavorites.
  ///
  /// In zh_CN, this message translates to:
  /// **'清空收藏'**
  String get clearAllFavorites;

  /// No description provided for @clearAllFavoritesConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确认清空所有收藏？'**
  String get clearAllFavoritesConfirm;

  /// No description provided for @noFavorites.
  ///
  /// In zh_CN, this message translates to:
  /// **'暂无收藏'**
  String get noFavorites;

  /// No description provided for @deleteFavorite.
  ///
  /// In zh_CN, this message translates to:
  /// **'删除收藏'**
  String get deleteFavorite;

  /// No description provided for @deleteFavoriteConfirm.
  ///
  /// In zh_CN, this message translates to:
  /// **'确认删除此收藏？'**
  String get deleteFavoriteConfirm;

  /// No description provided for @settings.
  ///
  /// In zh_CN, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @playbackSettings.
  ///
  /// In zh_CN, this message translates to:
  /// **'播放设置'**
  String get playbackSettings;

  /// No description provided for @defaultVolume.
  ///
  /// In zh_CN, this message translates to:
  /// **'默认音量'**
  String get defaultVolume;

  /// No description provided for @defaultPlaybackSpeed.
  ///
  /// In zh_CN, this message translates to:
  /// **'默认播放速度'**
  String get defaultPlaybackSpeed;

  /// No description provided for @autoPlayNext.
  ///
  /// In zh_CN, this message translates to:
  /// **'自动播放下一集'**
  String get autoPlayNext;

  /// No description provided for @autoPlayNextDescription.
  ///
  /// In zh_CN, this message translates to:
  /// **'播放完当前集数后自动播放下一集'**
  String get autoPlayNextDescription;

  /// No description provided for @displaySettings.
  ///
  /// In zh_CN, this message translates to:
  /// **'显示设置'**
  String get displaySettings;

  /// No description provided for @themeMode.
  ///
  /// In zh_CN, this message translates to:
  /// **'主题模式'**
  String get themeMode;

  /// No description provided for @themeLight.
  ///
  /// In zh_CN, this message translates to:
  /// **'浅色'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In zh_CN, this message translates to:
  /// **'深色'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In zh_CN, this message translates to:
  /// **'跟随系统'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In zh_CN, this message translates to:
  /// **'语言'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'HK':
            return AppLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
