import 'package:geolocator/geolocator.dart';
import 'package:izmir_go/core/failures.dart';

class LatLon {
  const LatLon(this.lat, this.lon);
  final double lat;
  final double lon;
}

/// Wraps geolocator. Location is requested only on explicit user action and is never stored
/// as history; callers use it once per request.
class LocationService {
  Future<LocationPermission> permission() => Geolocator.checkPermission();

  Future<bool> openSettings() => Geolocator.openAppSettings();

  Future<LatLon> current({bool requestIfNeeded = true}) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationFailure(LocationFailureReason.serviceDisabled);
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied && requestIfNeeded) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      throw const LocationFailure(LocationFailureReason.denied);
    }
    if (perm == LocationPermission.deniedForever) {
      throw const LocationFailure(LocationFailureReason.deniedForever);
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return LatLon(pos.latitude, pos.longitude);
  }
}
