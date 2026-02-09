import 'package:flutter/material.dart';

import 'package:sjgtv/l10n_gen/app_localizations.dart';

/// shelf GET /api/l10n 与 index.html data-i18n 共用：按 Locale 返回 web_* 键的 Map。
///
/// index.html 使用 data-i18n="web_page_title" 等形式，键名需为 snake_case。
Map<String, String> appLocalizationsToWebMap(Locale locale) {
  final AppLocalizations l10n = lookupAppLocalizations(locale);
  return <String, String>{
    'web_actions': l10n.webActions,
    'web_active_sources': l10n.webActiveSources,
    'web_add_proxy': l10n.webAddProxy,
    'web_add_source': l10n.webAddSource,
    'web_add_source_title': l10n.webAddSourceTitle,
    'web_api_base_url': l10n.webApiBaseUrl,
    'web_api_base_url_hint': l10n.webApiBaseUrlHint,
    'web_api_base_url_placeholder': l10n.webApiBaseUrlPlaceholder,
    'web_api_url': l10n.webApiUrl,
    'web_average_weight': l10n.webAverageWeight,
    'web_cancel': l10n.webCancel,
    'web_cannot_undo': l10n.webCannotUndo,
    'web_close': l10n.webClose,
    'web_confirm_delete': l10n.webConfirmDelete,
    'web_delete': l10n.webDelete,
    'web_disable': l10n.webDisable,
    'web_disabled': l10n.webDisabled,
    'web_enable': l10n.webEnable,
    'web_enabled': l10n.webEnabled,
    'web_load_failed_retry': l10n.webLoadFailedRetry,
    'web_loading': l10n.webLoading,
    'web_msg_add_fail': l10n.webMsgAddFail,
    'web_msg_confirm_delete_proxy': l10n.webMsgConfirmDeleteProxy('{name}'),
    'web_msg_confirm_delete_source': l10n.webMsgConfirmDeleteSource('{name}'),
    'web_msg_confirm_delete_tag': l10n.webMsgConfirmDeleteTag('{name}'),
    'web_msg_delete_fail': l10n.webMsgDeleteFail,
    'web_msg_deleted': l10n.webMsgDeleted,
    'web_msg_enter_api_url': l10n.webMsgEnterApiUrl,
    'web_msg_enter_source_name': l10n.webMsgEnterSourceName,
    'web_msg_enter_tag_name': l10n.webMsgEnterTagName,
    'web_msg_no_match': l10n.webMsgNoMatch,
    'web_msg_no_tags_add': l10n.webMsgNoTagsAdd,
    'web_msg_operation_fail': l10n.webMsgOperationFail,
    'web_msg_proxy_deleted': l10n.webMsgProxyDeleted,
    'web_msg_proxy_disabled': l10n.webMsgProxyDisabled,
    'web_msg_proxy_enabled': l10n.webMsgProxyEnabled,
    'web_msg_proxy_info_required': l10n.webMsgProxyInfoRequired,
    'web_msg_proxy_load_fail': l10n.webMsgProxyLoadFail,
    'web_msg_proxy_loaded': l10n.webMsgProxyLoaded,
    'web_msg_proxy_save_fail': l10n.webMsgProxySaveFail,
    'web_msg_proxy_saved': l10n.webMsgProxySaved,
    'web_msg_search_reset': l10n.webMsgSearchReset,
    'web_msg_source_added': l10n.webMsgSourceAdded,
    'web_msg_source_disabled': l10n.webMsgSourceDisabled,
    'web_msg_source_enabled': l10n.webMsgSourceEnabled,
    'web_msg_source_list_load_fail': l10n.webMsgSourceListLoadFail,
    'web_msg_source_list_loaded': l10n.webMsgSourceListLoaded,
    'web_msg_status_update_fail': l10n.webMsgStatusUpdateFail,
    'web_msg_tag_add_fail': l10n.webMsgTagAddFail,
    'web_msg_tag_added': l10n.webMsgTagAdded,
    'web_msg_tag_delete_fail': l10n.webMsgTagDeleteFail,
    'web_msg_tag_deleted': l10n.webMsgTagDeleted,
    'web_msg_tag_list_load_fail': l10n.webMsgTagListLoadFail,
    'web_msg_tag_list_loaded': l10n.webMsgTagListLoaded,
    'web_msg_tag_order_update_fail': l10n.webMsgTagOrderUpdateFail,
    'web_msg_tag_order_updated': l10n.webMsgTagOrderUpdated,
    'web_msg_tag_update_fail': l10n.webMsgTagUpdateFail,
    'web_msg_tag_updated': l10n.webMsgTagUpdated,
    'web_msg_weight_range': l10n.webMsgWeightRange,
    'web_name': l10n.webName,
    'web_no_data_add_source': l10n.webNoDataAddSource,
    'web_no_proxy': l10n.webNoProxy,
    'web_page_title': l10n.webPageTitle,
    'web_pick_color': l10n.webPickColor,
    'web_processing': l10n.webProcessing,
    'web_proxy_name': l10n.webProxyName,
    'web_proxy_name_placeholder': l10n.webProxyNamePlaceholder,
    'web_proxy_settings_title': l10n.webProxySettingsTitle,
    'web_proxy_url': l10n.webProxyUrl,
    'web_proxy_url_placeholder': l10n.webProxyUrlPlaceholder,
    'web_refresh': l10n.webRefresh,
    'web_reset': l10n.webReset,
    'web_save': l10n.webSave,
    'web_save_tag': l10n.webSaveTag,
    'web_search': l10n.webSearch,
    'web_search_placeholder': l10n.webSearchPlaceholder,
    'web_source_list_title': l10n.webSourceListTitle,
    'web_source_name': l10n.webSourceName,
    'web_source_name_placeholder': l10n.webSourceNamePlaceholder,
    'web_status': l10n.webStatus,
    'web_tag_color': l10n.webTagColor,
    'web_tag_manage_title': l10n.webTagManageTitle,
    'web_tag_name': l10n.webTagName,
    'web_tag_name_placeholder': l10n.webTagNamePlaceholder,
    'web_total_sources': l10n.webTotalSources,
    'web_weight': l10n.webWeight,
    'web_weight_hint': l10n.webWeightHint,
    'web_weight_label': l10n.webWeightLabel,
  };
}

/// 从 Accept-Language 解析出 Locale，回退到 zh_CN。
Locale parseLocaleFromAcceptLanguage(String? acceptLanguage) {
  if (acceptLanguage == null || acceptLanguage.isEmpty) {
    return const Locale('zh', 'CN');
  }
  final List<String> parts = acceptLanguage
      .split(',')
      .map((String s) => s.split(';').first.trim())
      .toList();
  for (final String tag in parts) {
    if (tag.startsWith('zh-HK') || tag.startsWith('zh_HK')) {
      return const Locale('zh', 'HK');
    }
    if (tag.startsWith('zh') ||
        tag.startsWith('zh-CN') ||
        tag.startsWith('zh_CN')) {
      return const Locale('zh', 'CN');
    }
    if (tag.startsWith('en')) {
      return const Locale('en');
    }
  }
  return const Locale('zh', 'CN');
}
