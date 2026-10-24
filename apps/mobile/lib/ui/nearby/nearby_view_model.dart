import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/services/location_service.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

sealed class NearbyState {
  const NearbyState();
}

/// Permission not asked yet: show an explanation and a button. Never prompt on screen open.
final class NearbyNeedsPermission extends NearbyState {
  const NearbyNeedsPermission();
}

final class NearbyLocationProblem extends NearbyState {
  const NearbyLocationProblem(this.reason);
  final LocationFailureReason reason;
}

final class NearbyLoaded extends NearbyState {
  const NearbyLoaded(this.position, this.stops);
  final LatLon position;
  final Fresh<List<StopSummary>> stops;
}

class NearbyViewModel extends AsyncNotifier<NearbyState> {
  @override
  Future<NearbyState> build() async {
    final perm = await ref.read(locationServiceProvider).permission();
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
      return await _load(requestIfNeeded: false);
    }
    if (perm == LocationPermission.deniedForever) {
      return const NearbyLocationProblem(LocationFailureReason.deniedForever);
    }
    return const NearbyNeedsPermission();
  }

  Future<NearbyState> _load({required bool requestIfNeeded}) async {
    try {
      final pos = await ref.read(locationServiceProvider).current(requestIfNeeded: requestIfNeeded);
      final stops = await ref.read(stopsRepositoryProvider).nearby(pos.lat, pos.lon);
      return NearbyLoaded(pos, stops);
    } on LocationFailure catch (e) {
      return NearbyLocationProblem(e.reason);
    }
  }

  /// Called from the explicit "Konum izni ver" button or pull-to-refresh.
  Future<void> locate() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(requestIfNeeded: true));
  }
}

final nearbyProvider = AsyncNotifierProvider.autoDispose<NearbyViewModel, NearbyState>(
  NearbyViewModel.new,
);
