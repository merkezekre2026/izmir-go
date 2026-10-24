import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';

enum TimeMode { now, departAt, arriveBy }

/// Special place meaning "wherever the device is when the search runs". Never stored.
const currentLocationId = 'current-location';

Place currentLocationPlace(String label) =>
    Place(id: currentLocationId, name: label, lat: 0, lon: 0, kind: 'address', provider: 'device');

@immutable
class JourneySearchState {
  const JourneySearchState({this.origin, this.destination, this.mode = TimeMode.now, this.time});

  final Place? origin;
  final Place? destination;
  final TimeMode mode;
  final DateTime? time;

  bool get canSearch => origin != null && destination != null && origin != destination;

  JourneySearchState copyWith({
    Place? origin,
    Place? destination,
    TimeMode? mode,
    DateTime? time,
    bool clearOrigin = false,
    bool clearDestination = false,
  }) => JourneySearchState(
    origin: clearOrigin ? null : origin ?? this.origin,
    destination: clearDestination ? null : destination ?? this.destination,
    mode: mode ?? this.mode,
    time: time ?? this.time,
  );
}

/// A fully resolved search: both ends have coordinates or stop ids.
typedef JourneyQuery = ({Place from, Place to, String? at, bool arriveBy});

class JourneySearchViewModel extends Notifier<JourneySearchState> {
  @override
  JourneySearchState build() => const JourneySearchState();

  void setOrigin(Place p) => state = state.copyWith(origin: p);
  void setDestination(Place p) => state = state.copyWith(destination: p);

  void swap() => state = JourneySearchState(
    origin: state.destination,
    destination: state.origin,
    mode: state.mode,
    time: state.time,
  );

  void setMode(TimeMode mode, {DateTime? time}) =>
      state = state.copyWith(mode: mode, time: time ?? state.time ?? ref.read(clockProvider)());

  /// Resolves "Konumum" to coordinates (asking for permission only now) and records recent places.
  Future<JourneyQuery> buildQuery() async {
    final s = state;
    Future<Place> resolve(Place p) async {
      if (p.id != currentLocationId) {
        await ref.read(placesRepositoryProvider).addRecent(p);
        return p;
      }
      final pos = await ref.read(locationServiceProvider).current();
      return p.copyWith(lat: pos.lat, lon: pos.lon);
    }

    final from = await resolve(s.origin!);
    final to = await resolve(s.destination!);
    final at = s.mode == TimeMode.now ? null : isoIzmir(s.time ?? ref.read(clockProvider)());
    return (from: from, to: to, at: at, arriveBy: s.mode == TimeMode.arriveBy);
  }
}

final journeySearchProvider = NotifierProvider<JourneySearchViewModel, JourneySearchState>(
  JourneySearchViewModel.new,
);

final recentPlacesProvider = FutureProvider.autoDispose<List<Place>>(
  (ref) => ref.watch(placesRepositoryProvider).recent(),
);
