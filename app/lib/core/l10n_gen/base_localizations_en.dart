// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'base_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BaseLocalizationsEn extends BaseLocalizations {
  BaseLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get apiBadCertificate => 'SSL certificate verification failures';

  @override
  String get apiBadResponse => 'Internal server error';

  @override
  String get apiCancel => 'Request canceled';

  @override
  String get apiConnectionError => 'Connection host error';

  @override
  String get apiConnectionTimeout => 'Connection timeout, Please try again';

  @override
  String get apiFormatError => 'Invalid data format';

  @override
  String get apiHandshakeError => 'Connection terminated during handshake';

  @override
  String get apiParseError => 'Invalid data format';

  @override
  String get apiReceiveTimeout => 'Receive data timeout, Please try again';

  @override
  String get apiSendTimeout => 'Send data timeout, Please try again';

  @override
  String get apiUnknownError => 'Unknown fault';
}
