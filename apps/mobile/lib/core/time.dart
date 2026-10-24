/// Time display helpers for İzmir.
///
/// The API always sends explicit offsets (e.g. `2026-10-28T08:00:00+03:00`); Dart parses them to
/// UTC instants. Europe/Istanbul has been UTC+3 all year since 2016, so wall-clock time in İzmir
/// is UTC+3. If that ever changes, this is the single place to update.
const izmirUtcOffset = Duration(hours: 3);

DateTime toIzmir(DateTime instant) => instant.toUtc().add(izmirUtcOffset);

DateTime izmirNow([DateTime? now]) => toIzmir(now ?? DateTime.now());

String two(int v) => v.toString().padLeft(2, '0');

/// "08:05"
String formatHm(DateTime instant) {
  final t = toIzmir(instant);
  return '${two(t.hour)}:${two(t.minute)}';
}

/// "24.10.2026"
String formatDate(DateTime date) => '${two(date.day)}.${two(date.month)}.${date.year}';

/// "24.10.2026 14:05" in İzmir time.
String formatDateTime(DateTime instant) {
  final t = toIzmir(instant);
  return '${formatDate(t)} ${two(t.hour)}:${two(t.minute)}';
}

/// Whole minutes between two instants, rounded up (never shows 0 for a pending departure).
int minutesBetween(DateTime from, DateTime to) {
  final seconds = to.difference(from).inSeconds;
  return seconds <= 0 ? 0 : (seconds / 60).ceil();
}

/// ISO-8601 with the İzmir offset for API queries.
String isoIzmir(DateTime instant) {
  final t = toIzmir(instant);
  return '${t.year}-${two(t.month)}-${two(t.day)}T${two(t.hour)}:${two(t.minute)}:00+03:00';
}
