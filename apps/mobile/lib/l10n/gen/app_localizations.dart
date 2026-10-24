import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'İzmir Go'**
  String get appTitle;

  /// No description provided for @tabRoute.
  ///
  /// In tr, this message translates to:
  /// **'Rota'**
  String get tabRoute;

  /// No description provided for @tabNearby.
  ///
  /// In tr, this message translates to:
  /// **'Yakınımda'**
  String get tabNearby;

  /// No description provided for @tabLines.
  ///
  /// In tr, this message translates to:
  /// **'Hatlar'**
  String get tabLines;

  /// No description provided for @tabSaved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenler'**
  String get tabSaved;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @from.
  ///
  /// In tr, this message translates to:
  /// **'Nereden'**
  String get from;

  /// No description provided for @to.
  ///
  /// In tr, this message translates to:
  /// **'Nereye'**
  String get to;

  /// No description provided for @swap.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç ve varışı değiştir'**
  String get swap;

  /// No description provided for @myLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konumum'**
  String get myLocation;

  /// No description provided for @searchPlaceHint.
  ///
  /// In tr, this message translates to:
  /// **'Durak, istasyon veya adres ara'**
  String get searchPlaceHint;

  /// No description provided for @pickOnMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritadan seç'**
  String get pickOnMap;

  /// No description provided for @departNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi'**
  String get departNow;

  /// No description provided for @departAt.
  ///
  /// In tr, this message translates to:
  /// **'Kalkış'**
  String get departAt;

  /// No description provided for @arriveBy.
  ///
  /// In tr, this message translates to:
  /// **'Varış'**
  String get arriveBy;

  /// No description provided for @findRoutes.
  ///
  /// In tr, this message translates to:
  /// **'Rota bul'**
  String get findRoutes;

  /// No description provided for @chooseOriginAndDestination.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç ve varış noktasını seçin.'**
  String get chooseOriginAndDestination;

  /// No description provided for @recentPlaces.
  ///
  /// In tr, this message translates to:
  /// **'Son aramalar'**
  String get recentPlaces;

  /// No description provided for @clearRecent.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişi temizle'**
  String get clearRecent;

  /// No description provided for @results.
  ///
  /// In tr, this message translates to:
  /// **'Rotalar'**
  String get results;

  /// No description provided for @minutesShort.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String minutesShort(int minutes);

  /// No description provided for @transfers.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Aktarmasız} =1{1 aktarma} other{{count} aktarma}}'**
  String transfers(int count);

  /// No description provided for @walkMeters.
  ///
  /// In tr, this message translates to:
  /// **'{meters} m yürüme'**
  String walkMeters(int meters);

  /// No description provided for @walkOnly.
  ///
  /// In tr, this message translates to:
  /// **'Yürüyerek'**
  String get walkOnly;

  /// No description provided for @noJourneys.
  ///
  /// In tr, this message translates to:
  /// **'Bu saatte uygun sefer bulunamadı.'**
  String get noJourneys;

  /// No description provided for @noJourneysHint.
  ///
  /// In tr, this message translates to:
  /// **'Farklı bir saat deneyin veya başlangıç noktasını değiştirin.'**
  String get noJourneysHint;

  /// No description provided for @scheduledBasis.
  ///
  /// In tr, this message translates to:
  /// **'Tarifeye göre'**
  String get scheduledBasis;

  /// No description provided for @scheduledBasisExplain.
  ///
  /// In tr, this message translates to:
  /// **'Süreler operatörlerin yayımladığı tarifelere dayanır; anlık trafik veya gecikme bilgisi içermez.'**
  String get scheduledBasisExplain;

  /// No description provided for @approximateTimes.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşık saatler'**
  String get approximateTimes;

  /// No description provided for @liveBasis.
  ///
  /// In tr, this message translates to:
  /// **'Canlı'**
  String get liveBasis;

  /// No description provided for @cachedBasis.
  ///
  /// In tr, this message translates to:
  /// **'Önbellek'**
  String get cachedBasis;

  /// No description provided for @journeyDetail.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuk ayrıntısı'**
  String get journeyDetail;

  /// No description provided for @walkTo.
  ///
  /// In tr, this message translates to:
  /// **'{name} yönüne yürüyün'**
  String walkTo(String name);

  /// No description provided for @transferWalk.
  ///
  /// In tr, this message translates to:
  /// **'Aktarma: yaklaşık {meters} m yürüyün'**
  String transferWalk(int meters);

  /// No description provided for @boardAt.
  ///
  /// In tr, this message translates to:
  /// **'{stop} durağından binin'**
  String boardAt(String stop);

  /// No description provided for @alightAt.
  ///
  /// In tr, this message translates to:
  /// **'{stop} durağında inin'**
  String alightAt(String stop);

  /// No description provided for @towards.
  ///
  /// In tr, this message translates to:
  /// **'{headsign} yönü'**
  String towards(String headsign);

  /// No description provided for @intermediateStops.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Ara durak yok} =1{1 ara durak} other{{count} ara durak}}'**
  String intermediateStops(int count);

  /// No description provided for @geometryApproximate.
  ///
  /// In tr, this message translates to:
  /// **'Çizgi duraklar arası düz hat olarak gösteriliyor; gerçek güzergâh farklı olabilir.'**
  String get geometryApproximate;

  /// No description provided for @origin.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get origin;

  /// No description provided for @destination.
  ///
  /// In tr, this message translates to:
  /// **'Varış'**
  String get destination;

  /// No description provided for @nearbyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yakındaki duraklar'**
  String get nearbyTitle;

  /// No description provided for @nearbyNeedsLocation.
  ///
  /// In tr, this message translates to:
  /// **'Yakındaki durakları görmek için konum izni gerekir.'**
  String get nearbyNeedsLocation;

  /// No description provided for @allowLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni ver'**
  String get allowLocation;

  /// No description provided for @locationDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi. Durakları arayarak da bulabilirsiniz.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kapalı. Ayarlardan açabilir ya da arama kullanabilirsiniz.'**
  String get locationDeniedForever;

  /// No description provided for @openSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları aç'**
  String get openSettings;

  /// No description provided for @searchInstead.
  ///
  /// In tr, this message translates to:
  /// **'Durak ara'**
  String get searchInstead;

  /// No description provided for @noNearbyStops.
  ///
  /// In tr, this message translates to:
  /// **'Yakında durak bulunamadı.'**
  String get noNearbyStops;

  /// No description provided for @metersAway.
  ///
  /// In tr, this message translates to:
  /// **'{meters} m'**
  String metersAway(int meters);

  /// No description provided for @departures.
  ///
  /// In tr, this message translates to:
  /// **'Kalkışlar'**
  String get departures;

  /// No description provided for @noDepartures.
  ///
  /// In tr, this message translates to:
  /// **'Önümüzdeki saatlerde tarifeli kalkış yok.'**
  String get noDepartures;

  /// No description provided for @noScheduleForStop.
  ///
  /// In tr, this message translates to:
  /// **'Bu durak için geçerli tarife yok. Canlı veri varsa aşağıda gösterilir.'**
  String get noScheduleForStop;

  /// No description provided for @approaching.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan otobüsler'**
  String get approaching;

  /// No description provided for @stopsAway.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Durakta} =1{1 durak uzakta} other{{count} durak uzakta}}'**
  String stopsAway(int count);

  /// No description provided for @liveFetchedAt.
  ///
  /// In tr, this message translates to:
  /// **'Canlı · {time} itibarıyla'**
  String liveFetchedAt(String time);

  /// No description provided for @liveUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Canlı veri alınamadı.'**
  String get liveUnavailable;

  /// No description provided for @liveNone.
  ///
  /// In tr, this message translates to:
  /// **'Şu anda yaklaşan otobüs bilgisi yok.'**
  String get liveNone;

  /// No description provided for @liveExplain.
  ///
  /// In tr, this message translates to:
  /// **'Canlı bilgi kalan durak sayısını gösterir; dakika tahmini değildir.'**
  String get liveExplain;

  /// No description provided for @linesAtStop.
  ///
  /// In tr, this message translates to:
  /// **'Bu duraktan geçen hatlar'**
  String get linesAtStop;

  /// No description provided for @addFavorite.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlardan çıkar'**
  String get removeFavorite;

  /// No description provided for @linesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatlar'**
  String get linesTitle;

  /// No description provided for @searchLinesHint.
  ///
  /// In tr, this message translates to:
  /// **'Hat ara'**
  String get searchLinesHint;

  /// No description provided for @modeBus.
  ///
  /// In tr, this message translates to:
  /// **'Otobüs'**
  String get modeBus;

  /// No description provided for @modeMetro.
  ///
  /// In tr, this message translates to:
  /// **'Metro'**
  String get modeMetro;

  /// No description provided for @modeTram.
  ///
  /// In tr, this message translates to:
  /// **'Tramvay'**
  String get modeTram;

  /// No description provided for @modeRail.
  ///
  /// In tr, this message translates to:
  /// **'İZBAN'**
  String get modeRail;

  /// No description provided for @modeFerry.
  ///
  /// In tr, this message translates to:
  /// **'Vapur'**
  String get modeFerry;

  /// No description provided for @modeWalk.
  ///
  /// In tr, this message translates to:
  /// **'Yürüyüş'**
  String get modeWalk;

  /// No description provided for @direction.
  ///
  /// In tr, this message translates to:
  /// **'Yön'**
  String get direction;

  /// No description provided for @todaySchedule.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü seferler'**
  String get todaySchedule;

  /// No description provided for @stopsOnLine.
  ///
  /// In tr, this message translates to:
  /// **'Duraklar'**
  String get stopsOnLine;

  /// No description provided for @noLines.
  ///
  /// In tr, this message translates to:
  /// **'Hat bulunamadı.'**
  String get noLines;

  /// No description provided for @savedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilenler'**
  String get savedTitle;

  /// No description provided for @savedEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok. Durak ve hat sayfalarından kaydedebilirsiniz.'**
  String get savedEmpty;

  /// No description provided for @favoriteStops.
  ///
  /// In tr, this message translates to:
  /// **'Duraklar'**
  String get favoriteStops;

  /// No description provided for @favoriteLines.
  ///
  /// In tr, this message translates to:
  /// **'Hatlar'**
  String get favoriteLines;

  /// No description provided for @stopNoLongerExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu durak güncel veride yok.'**
  String get stopNoLongerExists;

  /// No description provided for @dataSources.
  ///
  /// In tr, this message translates to:
  /// **'Veri kaynakları'**
  String get dataSources;

  /// No description provided for @dataSourcesIntro.
  ///
  /// In tr, this message translates to:
  /// **'İzmir Go yalnızca operatörlerin yayımladığı verileri kullanır. Tahmini veya uydurma bilgi gösterilmez.'**
  String get dataSourcesIntro;

  /// No description provided for @sourceIncluded.
  ///
  /// In tr, this message translates to:
  /// **'Tarife dahil'**
  String get sourceIncluded;

  /// No description provided for @sourceExcluded.
  ///
  /// In tr, this message translates to:
  /// **'Tarife dahil değil'**
  String get sourceExcluded;

  /// No description provided for @validUntil.
  ///
  /// In tr, this message translates to:
  /// **'Geçerlilik: {date} tarihine kadar'**
  String validUntil(String date);

  /// No description provided for @lastUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Son güncelleme: {time}'**
  String lastUpdated(String time);

  /// No description provided for @liveAvailable.
  ///
  /// In tr, this message translates to:
  /// **'Canlı veri var'**
  String get liveAvailable;

  /// No description provided for @attribution.
  ///
  /// In tr, this message translates to:
  /// **'Lisans ve atıf'**
  String get attribution;

  /// No description provided for @notOfficial.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama İzmir Büyükşehir Belediyesi veya ulaşım operatörlerinin resmî uygulaması değildir.'**
  String get notOfficial;

  /// No description provided for @privacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get privacy;

  /// No description provided for @privacyText.
  ///
  /// In tr, this message translates to:
  /// **'Konumunuz yalnızca istek anında kullanılır ve sunucuda saklanmaz. Kayıtlarınız yalnızca bu cihazda tutulur.'**
  String get privacyText;

  /// No description provided for @clearLocalData.
  ///
  /// In tr, this message translates to:
  /// **'Yerel verileri temizle'**
  String get clearLocalData;

  /// No description provided for @localDataCleared.
  ///
  /// In tr, this message translates to:
  /// **'Yerel veriler temizlendi.'**
  String get localDataCleared;

  /// No description provided for @refreshData.
  ///
  /// In tr, this message translates to:
  /// **'Veriyi yenile'**
  String get refreshData;

  /// No description provided for @offline.
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışı'**
  String get offline;

  /// No description provided for @offlineBanner.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı yok. Kaydedilmiş veriler gösteriliyor ({time}).'**
  String offlineBanner(String time);

  /// No description provided for @staleData.
  ///
  /// In tr, this message translates to:
  /// **'Son güncelleme {time}'**
  String staleData(String time);

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya ulaşılamıyor. Bağlantınızı kontrol edin.'**
  String get errorNetwork;

  /// No description provided for @errorRouting.
  ///
  /// In tr, this message translates to:
  /// **'Rota planlama şu anda kullanılamıyor.'**
  String get errorRouting;

  /// No description provided for @errorRateLimited.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla istek gönderildi. Biraz sonra tekrar deneyin.'**
  String get errorRateLimited;

  /// No description provided for @errorOutsideCoverage.
  ///
  /// In tr, this message translates to:
  /// **'Konum İzmir dışında.'**
  String get errorOutsideCoverage;

  /// No description provided for @errorNoDataset.
  ///
  /// In tr, this message translates to:
  /// **'Ulaşım verisi henüz hazır değil.'**
  String get errorNoDataset;

  /// No description provided for @errorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bulunamadı.'**
  String get errorNotFound;

  /// No description provided for @transferPoint.
  ///
  /// In tr, this message translates to:
  /// **'Aktarma noktası'**
  String get transferPoint;

  /// No description provided for @noTimetableLive.
  ///
  /// In tr, this message translates to:
  /// **'Tarife yok · canlı veri'**
  String get noTimetableLive;

  /// No description provided for @mapLabel.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get mapLabel;

  /// No description provided for @journeyMapLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuk haritası'**
  String get journeyMapLabel;

  /// No description provided for @nearbyMapLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yakındaki duraklar haritası'**
  String get nearbyMapLabel;

  /// No description provided for @list.
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get list;

  /// No description provided for @map.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get map;

  /// No description provided for @selectThisPoint.
  ///
  /// In tr, this message translates to:
  /// **'Bu noktayı seç'**
  String get selectThisPoint;

  /// No description provided for @moveMapToSelect.
  ///
  /// In tr, this message translates to:
  /// **'Haritayı kaydırarak noktayı seçin'**
  String get moveMapToSelect;

  /// No description provided for @selectedPoint.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen nokta'**
  String get selectedPoint;

  /// No description provided for @alerts.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular'**
  String get alerts;

  /// No description provided for @firstDeparture.
  ///
  /// In tr, this message translates to:
  /// **'İlk kalkış'**
  String get firstDeparture;

  /// No description provided for @approxStopTimes.
  ///
  /// In tr, this message translates to:
  /// **'Bu hattın ara durak saatleri yaklaşıktır.'**
  String get approxStopTimes;

  /// No description provided for @appVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String appVersion(String version);

  /// No description provided for @timeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get timeLabel;

  /// No description provided for @now.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi'**
  String get now;

  /// No description provided for @journeyRemembered.
  ///
  /// In tr, this message translates to:
  /// **'Bu yolculuk çevrimdışı görüntülenmek üzere kaydedildi.'**
  String get journeyRemembered;

  /// No description provided for @otherAlternatives.
  ///
  /// In tr, this message translates to:
  /// **'Diğer seçenekler'**
  String get otherAlternatives;

  /// No description provided for @walkAlternative.
  ///
  /// In tr, this message translates to:
  /// **'Yürüme seçeneği'**
  String get walkAlternative;

  /// No description provided for @wheelchairAccessible.
  ///
  /// In tr, this message translates to:
  /// **'Engelli erişimine uygun'**
  String get wheelchairAccessible;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
