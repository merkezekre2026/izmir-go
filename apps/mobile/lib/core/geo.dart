import 'dart:math' as math;

/// Great-circle distance in metres.
double haversineM(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371008.8;
  final p1 = lat1 * math.pi / 180;
  final p2 = lat2 * math.pi / 180;
  final dp = (lat2 - lat1) * math.pi / 180;
  final dl = (lon2 - lon1) * math.pi / 180;
  final h =
      math.pow(math.sin(dp / 2), 2) + math.cos(p1) * math.cos(p2) * math.pow(math.sin(dl / 2), 2);
  return 2 * r * math.asin(math.sqrt(h));
}

/// İzmir province bounding box (matches the backend coverage area).
bool inIzmir(double lat, double lon) => lat >= 37.8 && lat <= 39.4 && lon >= 26.2 && lon <= 28.5;
