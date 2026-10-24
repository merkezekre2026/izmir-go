// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'İzmir Go';

  @override
  String get tabRoute => 'Rota';

  @override
  String get tabNearby => 'Yakınımda';

  @override
  String get tabLines => 'Hatlar';

  @override
  String get tabSaved => 'Kaydedilenler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get from => 'Nereden';

  @override
  String get to => 'Nereye';

  @override
  String get swap => 'Başlangıç ve varışı değiştir';

  @override
  String get myLocation => 'Konumum';

  @override
  String get searchPlaceHint => 'Durak, istasyon veya adres ara';

  @override
  String get pickOnMap => 'Haritadan seç';

  @override
  String get departNow => 'Şimdi';

  @override
  String get departAt => 'Kalkış';

  @override
  String get arriveBy => 'Varış';

  @override
  String get findRoutes => 'Rota bul';

  @override
  String get chooseOriginAndDestination => 'Başlangıç ve varış noktasını seçin.';

  @override
  String get recentPlaces => 'Son aramalar';

  @override
  String get clearRecent => 'Geçmişi temizle';

  @override
  String get results => 'Rotalar';

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String transfers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktarma',
      one: '1 aktarma',
      zero: 'Aktarmasız',
    );
    return '$_temp0';
  }

  @override
  String walkMeters(int meters) {
    return '$meters m yürüme';
  }

  @override
  String get walkOnly => 'Yürüyerek';

  @override
  String get noJourneys => 'Bu saatte uygun sefer bulunamadı.';

  @override
  String get noJourneysHint => 'Farklı bir saat deneyin veya başlangıç noktasını değiştirin.';

  @override
  String get scheduledBasis => 'Tarifeye göre';

  @override
  String get scheduledBasisExplain =>
      'Süreler operatörlerin yayımladığı tarifelere dayanır; anlık trafik veya gecikme bilgisi içermez.';

  @override
  String get approximateTimes => 'Yaklaşık saatler';

  @override
  String get liveBasis => 'Canlı';

  @override
  String get cachedBasis => 'Önbellek';

  @override
  String get journeyDetail => 'Yolculuk ayrıntısı';

  @override
  String walkTo(String name) {
    return '$name yönüne yürüyün';
  }

  @override
  String transferWalk(int meters) {
    return 'Aktarma: yaklaşık $meters m yürüyün';
  }

  @override
  String boardAt(String stop) {
    return '$stop durağından binin';
  }

  @override
  String alightAt(String stop) {
    return '$stop durağında inin';
  }

  @override
  String towards(String headsign) {
    return '$headsign yönü';
  }

  @override
  String intermediateStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ara durak',
      one: '1 ara durak',
      zero: 'Ara durak yok',
    );
    return '$_temp0';
  }

  @override
  String get geometryApproximate =>
      'Çizgi duraklar arası düz hat olarak gösteriliyor; gerçek güzergâh farklı olabilir.';

  @override
  String get origin => 'Başlangıç';

  @override
  String get destination => 'Varış';

  @override
  String get nearbyTitle => 'Yakındaki duraklar';

  @override
  String get nearbyNeedsLocation => 'Yakındaki durakları görmek için konum izni gerekir.';

  @override
  String get allowLocation => 'Konum izni ver';

  @override
  String get locationDenied => 'Konum izni verilmedi. Durakları arayarak da bulabilirsiniz.';

  @override
  String get locationDeniedForever =>
      'Konum izni kapalı. Ayarlardan açabilir ya da arama kullanabilirsiniz.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get searchInstead => 'Durak ara';

  @override
  String get noNearbyStops => 'Yakında durak bulunamadı.';

  @override
  String metersAway(int meters) {
    return '$meters m';
  }

  @override
  String get departures => 'Kalkışlar';

  @override
  String get noDepartures => 'Önümüzdeki saatlerde tarifeli kalkış yok.';

  @override
  String get noScheduleForStop =>
      'Bu durak için geçerli tarife yok. Canlı veri varsa aşağıda gösterilir.';

  @override
  String get approaching => 'Yaklaşan otobüsler';

  @override
  String stopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count durak uzakta',
      one: '1 durak uzakta',
      zero: 'Durakta',
    );
    return '$_temp0';
  }

  @override
  String liveFetchedAt(String time) {
    return 'Canlı · $time itibarıyla';
  }

  @override
  String get liveUnavailable => 'Canlı veri alınamadı.';

  @override
  String get liveNone => 'Şu anda yaklaşan otobüs bilgisi yok.';

  @override
  String get liveExplain => 'Canlı bilgi kalan durak sayısını gösterir; dakika tahmini değildir.';

  @override
  String get linesAtStop => 'Bu duraktan geçen hatlar';

  @override
  String get addFavorite => 'Kaydet';

  @override
  String get removeFavorite => 'Kayıtlardan çıkar';

  @override
  String get linesTitle => 'Hatlar';

  @override
  String get searchLinesHint => 'Hat ara';

  @override
  String get modeBus => 'Otobüs';

  @override
  String get modeMetro => 'Metro';

  @override
  String get modeTram => 'Tramvay';

  @override
  String get modeRail => 'İZBAN';

  @override
  String get modeFerry => 'Vapur';

  @override
  String get modeWalk => 'Yürüyüş';

  @override
  String get direction => 'Yön';

  @override
  String get todaySchedule => 'Bugünkü seferler';

  @override
  String get stopsOnLine => 'Duraklar';

  @override
  String get noLines => 'Hat bulunamadı.';

  @override
  String get savedTitle => 'Kaydedilenler';

  @override
  String get savedEmpty => 'Henüz kayıt yok. Durak ve hat sayfalarından kaydedebilirsiniz.';

  @override
  String get favoriteStops => 'Duraklar';

  @override
  String get favoriteLines => 'Hatlar';

  @override
  String get stopNoLongerExists => 'Bu durak güncel veride yok.';

  @override
  String get dataSources => 'Veri kaynakları';

  @override
  String get dataSourcesIntro =>
      'İzmir Go yalnızca operatörlerin yayımladığı verileri kullanır. Tahmini veya uydurma bilgi gösterilmez.';

  @override
  String get sourceIncluded => 'Tarife dahil';

  @override
  String get sourceExcluded => 'Tarife dahil değil';

  @override
  String validUntil(String date) {
    return 'Geçerlilik: $date tarihine kadar';
  }

  @override
  String lastUpdated(String time) {
    return 'Son güncelleme: $time';
  }

  @override
  String get liveAvailable => 'Canlı veri var';

  @override
  String get attribution => 'Lisans ve atıf';

  @override
  String get notOfficial =>
      'Bu uygulama İzmir Büyükşehir Belediyesi veya ulaşım operatörlerinin resmî uygulaması değildir.';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyText =>
      'Konumunuz yalnızca istek anında kullanılır ve sunucuda saklanmaz. Kayıtlarınız yalnızca bu cihazda tutulur.';

  @override
  String get clearLocalData => 'Yerel verileri temizle';

  @override
  String get localDataCleared => 'Yerel veriler temizlendi.';

  @override
  String get refreshData => 'Veriyi yenile';

  @override
  String get offline => 'Çevrimdışı';

  @override
  String offlineBanner(String time) {
    return 'İnternet bağlantısı yok. Kaydedilmiş veriler gösteriliyor ($time).';
  }

  @override
  String staleData(String time) {
    return 'Son güncelleme $time';
  }

  @override
  String get retry => 'Tekrar dene';

  @override
  String get loading => 'Yükleniyor';

  @override
  String get errorGeneric => 'Bir sorun oluştu.';

  @override
  String get errorNetwork => 'Sunucuya ulaşılamıyor. Bağlantınızı kontrol edin.';

  @override
  String get errorRouting => 'Rota planlama şu anda kullanılamıyor.';

  @override
  String get errorRateLimited => 'Çok fazla istek gönderildi. Biraz sonra tekrar deneyin.';

  @override
  String get errorOutsideCoverage => 'Konum İzmir dışında.';

  @override
  String get errorNoDataset => 'Ulaşım verisi henüz hazır değil.';

  @override
  String get errorNotFound => 'Bulunamadı.';

  @override
  String get transferPoint => 'Aktarma noktası';

  @override
  String get noTimetableLive => 'Tarife yok · canlı veri';

  @override
  String get mapLabel => 'Harita';

  @override
  String get journeyMapLabel => 'Yolculuk haritası';

  @override
  String get nearbyMapLabel => 'Yakındaki duraklar haritası';

  @override
  String get list => 'Liste';

  @override
  String get map => 'Harita';

  @override
  String get selectThisPoint => 'Bu noktayı seç';

  @override
  String get moveMapToSelect => 'Haritayı kaydırarak noktayı seçin';

  @override
  String get selectedPoint => 'Seçilen nokta';

  @override
  String get alerts => 'Duyurular';

  @override
  String get firstDeparture => 'İlk kalkış';

  @override
  String get approxStopTimes => 'Bu hattın ara durak saatleri yaklaşıktır.';

  @override
  String appVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get timeLabel => 'Saat';

  @override
  String get now => 'Şimdi';

  @override
  String get journeyRemembered => 'Bu yolculuk çevrimdışı görüntülenmek üzere kaydedildi.';

  @override
  String get otherAlternatives => 'Diğer seçenekler';

  @override
  String get walkAlternative => 'Yürüme seçeneği';

  @override
  String get wheelchairAccessible => 'Engelli erişimine uygun';
}
