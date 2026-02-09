// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AppleCMS Movie Player';

  @override
  String get watchHistory => 'Watch History';

  @override
  String get noWatchHistory => 'No watch history';

  @override
  String get clearAll => 'Clear All';

  @override
  String get clearAllHistory => 'Clear History';

  @override
  String get clearAllHistoryConfirm =>
      'Are you sure you want to clear all watch history?';

  @override
  String get deleteHistory => 'Delete History';

  @override
  String get deleteHistoryConfirm =>
      'Are you sure you want to delete this watch history?';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get shelfApiDataList => 'Data list';

  @override
  String get shelfApiGetL10nFail => 'Failed to get translations';

  @override
  String get shelfApiGetProxyListFail => 'Failed to get proxy list';

  @override
  String get shelfApiGetSourceListFail => 'Failed to get source list';

  @override
  String get shelfApiGetTagListFail => 'Failed to get tag list';

  @override
  String get shelfApiIdAndNameRequired => 'ID and name are required';

  @override
  String get shelfApiIdRequired => 'ID parameter is required';

  @override
  String get shelfApiInvalidUrl => 'Please enter a valid URL';

  @override
  String get shelfApiNameAndUrlRequired => 'Name and URL are required';

  @override
  String get shelfApiNoAvailableSources => 'No available sources';

  @override
  String get shelfApiNoSearchResults => 'No results found';

  @override
  String get shelfApiProxyAddSuccess => 'Proxy added successfully';

  @override
  String get shelfApiProxyNameRequired => 'Proxy name is required';

  @override
  String get shelfApiSearchFail => 'Search failed';

  @override
  String get shelfApiSourceAddSuccess => 'Source added successfully';

  @override
  String get shelfApiSourceNotFound => 'Source not found';

  @override
  String get shelfApiSourceUpdateSuccess => 'Source updated successfully';

  @override
  String get shelfApiTagAddSuccess => 'Tag added successfully';

  @override
  String get shelfApiTagIdsArrayRequired => 'Tag IDs array is required';

  @override
  String get shelfApiTagNameRequired => 'Tag name is required';

  @override
  String get shelfApiTagNotFound => 'Tag not found';

  @override
  String get shelfApiTagOrderUpdateSuccess => 'Tag order updated successfully';

  @override
  String get shelfApiTagUpdateSuccess => 'Tag updated successfully';

  @override
  String get shelfApiUrlRequired => 'URL is required';

  @override
  String get sourceAddTitle => 'Add Data Source';

  @override
  String get sourceEditTitle => 'Edit Source';

  @override
  String get sourceDeleteTitle => 'Delete Source';

  @override
  String get sourceConfirmDelete => 'Confirm Delete';

  @override
  String get sourceDeleted => 'Deleted';

  @override
  String get sourceDeleteFail => 'Delete failed';

  @override
  String get sourceOperationFail => 'Operation failed';

  @override
  String get sourceCancel => 'Cancel';

  @override
  String get sourceListTitle => 'Source List';

  @override
  String get sourceManageTitle => 'Source Manage';

  @override
  String get sourceName => 'Name';

  @override
  String get sourceNoSources => 'No data sources';

  @override
  String get sourceRetry => 'Retry';

  @override
  String get sourceSave => 'Save';

  @override
  String get sourceUrlHint => 'URL (http or https)';

  @override
  String get updateCheckerAutoUpdate => 'Auto update';

  @override
  String get updateCheckerCancelDownload => 'Cancel download';

  @override
  String get updateCheckerDownloadFail => 'Download failed';

  @override
  String get updateCheckerDownloading => 'Downloading';

  @override
  String get updateCheckerInstallFail => 'Install failed';

  @override
  String get updateCheckerInstallPermissionRequired =>
      'Allow installing unknown apps to install update';

  @override
  String get updateCheckerLater => 'Later';

  @override
  String get updateCheckerManualUpdate => 'Manual update';

  @override
  String get updateCheckerNewVersionTitle => 'New version available';

  @override
  String get updateCheckerNoNotes => 'No release notes';

  @override
  String get updateCheckerStorageRequired =>
      'Storage permission required to download update';

  @override
  String get updateCheckerUpdateContent => 'Update content:';

  @override
  String get updateCheckerUserCancelDownload => 'User cancelled download';

  @override
  String get webActions => 'Actions';

  @override
  String get webActiveSources => 'Active Sources';

  @override
  String get webAddProxy => 'Add Proxy';

  @override
  String get webAddSource => 'Add Source';

  @override
  String get webAddSourceTitle => 'Add New Source';

  @override
  String get webApiBaseUrl => 'API Base URL';

  @override
  String get webApiBaseUrlHint => 'Enter base URL only';

  @override
  String get webApiBaseUrlPlaceholder =>
      'Enter base URL, e.g. https://example.com/';

  @override
  String get webApiUrl => 'API URL';

  @override
  String get webAverageWeight => 'Average Weight';

  @override
  String get webCancel => 'Cancel';

  @override
  String get webCannotUndo => 'Cannot undo after delete';

  @override
  String get webClose => 'Close';

  @override
  String get webConfirmDelete => 'Confirm Delete';

  @override
  String get webDelete => 'Delete';

  @override
  String get webDisable => 'Disable';

  @override
  String get webDisabled => 'Disabled';

  @override
  String get webEnable => 'Enable';

  @override
  String get webEnabled => 'Enabled';

  @override
  String get webLoadFailedRetry => 'Load failed, please refresh';

  @override
  String get webLoading => 'Loading...';

  @override
  String get webMsgAddFail => 'Add failed';

  @override
  String webMsgConfirmDeleteProxy(String name) {
    return 'Delete proxy $name?';
  }

  @override
  String webMsgConfirmDeleteSource(String name) {
    return 'Delete source $name?';
  }

  @override
  String webMsgConfirmDeleteTag(String name) {
    return 'Delete tag $name?';
  }

  @override
  String get webMsgDeleteFail => 'Delete failed';

  @override
  String get webMsgDeleted => 'Deleted';

  @override
  String get webMsgEnterApiUrl => 'Please enter API URL';

  @override
  String get webMsgEnterSourceName => 'Please enter source name';

  @override
  String get webMsgEnterTagName => 'Please enter tag name';

  @override
  String get webMsgNoMatch => 'No matching sources';

  @override
  String get webMsgNoTagsAdd => 'No tags, please add';

  @override
  String get webMsgOperationFail => 'Operation failed';

  @override
  String get webMsgProxyDeleted => 'Proxy deleted';

  @override
  String get webMsgProxyDisabled => 'Proxy disabled';

  @override
  String get webMsgProxyEnabled => 'Proxy enabled';

  @override
  String get webMsgProxyInfoRequired => 'Please fill proxy info';

  @override
  String get webMsgProxyLoadFail => 'Failed to load proxy';

  @override
  String get webMsgProxyLoaded => 'Proxy loaded';

  @override
  String get webMsgProxySaveFail => 'Failed to save proxy';

  @override
  String get webMsgProxySaved => 'Proxy saved';

  @override
  String get webMsgSearchReset => 'Search reset';

  @override
  String get webMsgSourceAdded => 'Source added';

  @override
  String get webMsgSourceDisabled => 'Source disabled';

  @override
  String get webMsgSourceEnabled => 'Source enabled';

  @override
  String get webMsgSourceListLoadFail => 'Failed to load source list';

  @override
  String get webMsgSourceListLoaded => 'Source list loaded';

  @override
  String get webMsgStatusUpdateFail => 'Status update failed';

  @override
  String get webMsgTagAddFail => 'Failed to add tag';

  @override
  String get webMsgTagAdded => 'Tag added';

  @override
  String get webMsgTagDeleteFail => 'Failed to delete tag';

  @override
  String get webMsgTagDeleted => 'Tag deleted';

  @override
  String get webMsgTagListLoadFail => 'Failed to load tag list';

  @override
  String get webMsgTagListLoaded => 'Tag list loaded';

  @override
  String get webMsgTagOrderUpdateFail => 'Failed to update tag order';

  @override
  String get webMsgTagOrderUpdated => 'Tag order updated';

  @override
  String get webMsgTagUpdateFail => 'Failed to update tag';

  @override
  String get webMsgTagUpdated => 'Tag updated';

  @override
  String get webMsgWeightRange => 'Weight must be 1-10';

  @override
  String get webName => 'Name';

  @override
  String get webNoDataAddSource => 'No data, please add';

  @override
  String get webNoProxy => 'No proxy configured';

  @override
  String get webPageTitle => 'AppleCMS Source Manage';

  @override
  String get webPickColor => 'Pick color';

  @override
  String get webProcessing => 'Processing...';

  @override
  String get webProxyName => 'Proxy Name';

  @override
  String get webProxyNamePlaceholder => 'e.g. HK Node';

  @override
  String get webProxySettingsTitle => 'Proxy Settings';

  @override
  String get webProxyUrl => 'Proxy URL';

  @override
  String get webProxyUrlPlaceholder => 'http://proxy.example.com:8080';

  @override
  String get webRefresh => 'Refresh';

  @override
  String get webReset => 'Reset';

  @override
  String get webSave => 'Save';

  @override
  String get webSaveTag => 'Save Tag';

  @override
  String get webSearch => 'Search';

  @override
  String get webSearchPlaceholder => 'Search by name or API URL...';

  @override
  String get webSourceListTitle => 'Source List';

  @override
  String get webSourceName => 'Source Name';

  @override
  String get webSourceNamePlaceholder => 'e.g. Movie Heaven';

  @override
  String get webStatus => 'Status';

  @override
  String get webTagColor => 'Tag Color';

  @override
  String get webTagManageTitle => 'Tag Manage';

  @override
  String get webTagName => 'Tag Name';

  @override
  String get webTagNamePlaceholder => 'e.g. Movie';

  @override
  String get webTotalSources => 'Total Sources';

  @override
  String get webWeight => 'Weight';

  @override
  String get webWeightHint => 'Higher weight ranks first';

  @override
  String get webWeightLabel => 'Weight (1-10)';
}
