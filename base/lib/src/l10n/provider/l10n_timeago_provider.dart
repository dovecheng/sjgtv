import 'dart:ui';

import 'package:base/l10n.dart';
import 'package:base/log.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'l10n_timeago_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [L10nLanguageProvider])
class L10nTimeagoProvider extends _$L10nTimeagoProvider {
  @override
  void build() {
    Locale? locale = ref.watch(
      l10nLanguageProvider.select((value) => value.value?.$1.locale),
    );
    log.d(() => locale);
    if (locale == null) {
      return;
    }
    switch (locale.languageCode) {
      case 'am':
        timeago.setLocaleMessages('am', timeago.AmMessages());
        timeago.setDefaultLocale('am');
        break;
      case 'ar':
        timeago.setLocaleMessages('ar', timeago.ArMessages());
        timeago.setDefaultLocale('ar');
        break;
      case 'az':
        timeago.setLocaleMessages('az', timeago.AzMessages());
        timeago.setDefaultLocale('az');
        break;
      case 'be':
        timeago.setLocaleMessages('be', timeago.BeMessages());
        timeago.setDefaultLocale('be');
        break;
      case 'bn':
        timeago.setLocaleMessages('bn', timeago.BnMessages());
        timeago.setDefaultLocale('bn');
        break;
      case 'bs':
        timeago.setLocaleMessages('bs', timeago.BsMessages());
        timeago.setDefaultLocale('bs');
        break;
      case 'ca':
        timeago.setLocaleMessages('ca', timeago.CaMessages());
        timeago.setDefaultLocale('ca');
        break;
      case 'cs':
        timeago.setLocaleMessages('cs', timeago.CsMessages());
        timeago.setDefaultLocale('cs');
        break;
      case 'da':
        timeago.setLocaleMessages('da', timeago.DaMessages());
        timeago.setDefaultLocale('da');
        break;
      case 'de':
        timeago.setLocaleMessages('de', timeago.DeMessages());
        timeago.setDefaultLocale('de');
        break;
      case 'dv':
        timeago.setLocaleMessages('dv', timeago.DvMessages());
        timeago.setDefaultLocale('dv');
        break;
      case 'es':
        timeago.setLocaleMessages('es', timeago.EsMessages());
        timeago.setDefaultLocale('es');
        break;
      case 'et':
        timeago.setLocaleMessages('et', timeago.EtMessages());
        timeago.setDefaultLocale('et');
        break;
      case 'fa':
        timeago.setLocaleMessages('fa', timeago.FaMessages());
        timeago.setDefaultLocale('fa');
        break;
      case 'fi':
        timeago.setLocaleMessages('fi', timeago.FiMessages());
        timeago.setDefaultLocale('fi');
        break;
      case 'fr':
        timeago.setLocaleMessages('fr', timeago.FrMessages());
        timeago.setDefaultLocale('fr');
        break;
      case 'gr':
        timeago.setLocaleMessages('gr', timeago.GrMessages());
        timeago.setDefaultLocale('gr');
        break;
      case 'he':
        timeago.setLocaleMessages('he', timeago.HeMessages());
        timeago.setDefaultLocale('he');
        break;
      case 'hi':
        timeago.setLocaleMessages('hi', timeago.HiMessages());
        timeago.setDefaultLocale('hi');
        break;
      case 'hr':
        timeago.setLocaleMessages('hr', timeago.HrMessages());
        timeago.setDefaultLocale('hr');
        break;
      case 'hu':
        timeago.setLocaleMessages('hu', timeago.HuMessages());
        timeago.setDefaultLocale('hu');
        break;
      case 'id':
        timeago.setLocaleMessages('id', timeago.IdMessages());
        timeago.setDefaultLocale('id');
        break;
      case 'it':
        timeago.setLocaleMessages('it', timeago.ItMessages());
        timeago.setDefaultLocale('it');
        break;
      case 'ja':
        timeago.setLocaleMessages('ja', timeago.JaMessages());
        timeago.setDefaultLocale('ja');
        break;
      case 'km':
        timeago.setLocaleMessages('km', timeago.KmMessages());
        timeago.setDefaultLocale('km');
        break;
      case 'ko':
        timeago.setLocaleMessages('ko', timeago.KoMessages());
        timeago.setDefaultLocale('ko');
        break;
      case 'ku':
        timeago.setLocaleMessages('ku', timeago.KuMessages());
        timeago.setDefaultLocale('ku');
        break;
      case 'lv':
        timeago.setLocaleMessages('lv', timeago.LvMessages());
        timeago.setDefaultLocale('lv');
        break;
      case 'mn':
        timeago.setLocaleMessages('mn', timeago.MnMessages());
        timeago.setDefaultLocale('mn');
        break;
      case 'ms_MY':
        timeago.setLocaleMessages('ms_MY', timeago.MsMyMessages());
        timeago.setDefaultLocale('ms_MY');
        break;
      case 'my':
        timeago.setLocaleMessages('my', timeago.MyMessages());
        timeago.setDefaultLocale('my');
        break;
      case 'nb_NO':
        timeago.setLocaleMessages('nb_NO', timeago.NbNoMessages());
        timeago.setDefaultLocale('nb_NO');
        break;
      case 'nl':
        timeago.setLocaleMessages('nl', timeago.NlMessages());
        timeago.setDefaultLocale('nl');
        break;
      case 'nn_NO':
        timeago.setLocaleMessages('nn_NO', timeago.NnNoMessages());
        timeago.setDefaultLocale('nn_NO');
        break;
      case 'pl':
        timeago.setLocaleMessages('pl', timeago.PlMessages());
        timeago.setDefaultLocale('pl');
        break;
      case 'pt_BR':
        timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
        timeago.setDefaultLocale('pt_BR');
        break;
      case 'ro':
        timeago.setLocaleMessages('ro', timeago.RoMessages());
        timeago.setDefaultLocale('ro');
        break;
      case 'ru':
        timeago.setLocaleMessages('ru', timeago.RuMessages());
        timeago.setDefaultLocale('ru');
        break;
      case 'rw':
        timeago.setLocaleMessages('rw', timeago.RwMessages());
        timeago.setDefaultLocale('rw');
        break;
      case 'sr':
        timeago.setLocaleMessages('sr', timeago.SrMessages());
        timeago.setDefaultLocale('sr');
        break;
      case 'sv':
        timeago.setLocaleMessages('sv', timeago.SvMessages());
        timeago.setDefaultLocale('sv');
        break;
      case 'ta':
        timeago.setLocaleMessages('ta', timeago.TaMessages());
        timeago.setDefaultLocale('ta');
        break;
      case 'th':
        timeago.setLocaleMessages('th', timeago.ThMessages());
        timeago.setDefaultLocale('th');
        break;
      case 'tk':
        timeago.setLocaleMessages('tk', timeago.TkMessages());
        timeago.setDefaultLocale('tk');
        break;
      case 'tr':
        timeago.setLocaleMessages('tr', timeago.TrMessages());
        timeago.setDefaultLocale('tr');
        break;
      case 'uk':
        timeago.setLocaleMessages('uk', timeago.UkMessages());
        timeago.setDefaultLocale('uk');
        break;
      case 'ur':
        timeago.setLocaleMessages('ur', timeago.UrMessages());
        timeago.setDefaultLocale('ur');
        break;
      case 'vi':
        timeago.setLocaleMessages('vi', timeago.ViMessages());
        timeago.setDefaultLocale('vi');
        break;
      case 'zh':
        switch (locale.countryCode) {
          case 'CN':
          case 'SG':
            timeago.setLocaleMessages('zh_CN', ZhCnMessages());
            timeago.setDefaultLocale('zh_CN');
            break;
          case 'HK':
          case 'MO':
          case 'TW':
          default:
            timeago.setLocaleMessages('zh', ZhMessages());
            timeago.setDefaultLocale('zh');
            break;
        }
        break;
      case 'en':
      default:
        timeago.setLocaleMessages('en', timeago.EnMessages());
        timeago.setDefaultLocale('en');
        break;
    }
  }
}
