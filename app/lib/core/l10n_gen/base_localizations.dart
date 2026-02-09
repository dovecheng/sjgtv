import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'base_localizations_en.dart';
import 'base_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BaseLocalizations
/// returned by `BaseLocalizations.of(context)`.
///
/// Applications need to include `BaseLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n_gen/base_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BaseLocalizations.localizationsDelegates,
///   supportedLocales: BaseLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BaseLocalizations.supportedLocales
/// property.
abstract class BaseLocalizations {
  BaseLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BaseLocalizations of(BuildContext context) {
    return Localizations.of<BaseLocalizations>(context, BaseLocalizations)!;
  }

  static const LocalizationsDelegate<BaseLocalizations> delegate =
      _BaseLocalizationsDelegate();

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

  /// An exception that happens in the handshake phase of establishing a secure network connection, when looking up or verifying a certificate
  ///
  /// In zh_CN, this message translates to:
  /// **'SSL安全证书验证失败'**
  String get apiBadCertificate;

  /// When the server response, but with a incorrect status, such as 404, 503...
  ///
  /// In zh_CN, this message translates to:
  /// **'服务器响应错误'**
  String get apiBadResponse;

  /// When the request is cancelled, will throw a error with this type
  ///
  /// In zh_CN, this message translates to:
  /// **'已取消加载'**
  String get apiCancel;

  /// Socket is not connected
  ///
  /// In zh_CN, this message translates to:
  /// **'服务器连接失败'**
  String get apiConnectionError;

  /// It occurs when url is opened timeout
  ///
  /// In zh_CN, this message translates to:
  /// **'连接超时, 请重试'**
  String get apiConnectionTimeout;

  /// 服务器响应数据格式错误
  ///
  /// In zh_CN, this message translates to:
  /// **'无效的数据格式'**
  String get apiFormatError;

  /// An exception that happens in the handshake phase of establishing a secure network connection
  ///
  /// In zh_CN, this message translates to:
  /// **'建立安全网络连接时发生错误'**
  String get apiHandshakeError;

  /// 服务器响应数据格式错误
  ///
  /// In zh_CN, this message translates to:
  /// **'无效的数据格式'**
  String get apiParseError;

  /// It occurs when receiving timeout
  ///
  /// In zh_CN, this message translates to:
  /// **'接收数据超时, 请重试'**
  String get apiReceiveTimeout;

  /// It occurs when url is sent timeout
  ///
  /// In zh_CN, this message translates to:
  /// **'发送数据超时, 请重试'**
  String get apiSendTimeout;

  /// Some other Error
  ///
  /// In zh_CN, this message translates to:
  /// **'未知错误'**
  String get apiUnknownError;
}

class _BaseLocalizationsDelegate
    extends LocalizationsDelegate<BaseLocalizations> {
  const _BaseLocalizationsDelegate();

  @override
  Future<BaseLocalizations> load(Locale locale) {
    return SynchronousFuture<BaseLocalizations>(
      lookupBaseLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_BaseLocalizationsDelegate old) => false;
}

BaseLocalizations lookupBaseLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return BaseLocalizationsZhCn();
          case 'HK':
            return BaseLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return BaseLocalizationsEn();
    case 'zh':
      return BaseLocalizationsZh();
  }

  throw FlutterError(
    'BaseLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
