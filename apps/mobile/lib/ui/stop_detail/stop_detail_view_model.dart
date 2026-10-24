import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

final stopProvider = FutureProvider.autoDispose.family<Fresh<StopResponse>, String>(
  (ref, id) => ref.watch(stopsRepositoryProvider).stop(id),
);

final departuresProvider = FutureProvider.autoDispose.family<Fresh<DeparturesResponse>, String>(
  (ref, id) => ref.watch(stopsRepositoryProvider).departures(id),
);

final isFavoriteStopProvider = StreamProvider.autoDispose.family<bool, String>(
  (ref, id) => ref.watch(favoritesRepositoryProvider).watchIsFavoriteStop(id),
);

/// Live approaching vehicles, refreshed every [interval] while the screen is visible and the
/// app is in the foreground. Results are never cached.
class LiveArrivalsViewModel extends AsyncNotifier<LiveResponse> {
  LiveArrivalsViewModel(this.stopId);
  final String stopId;
  static const interval = Duration(seconds: 20);
  Timer? _timer;
  AppLifecycleListener? _lifecycle;

  @override
  Future<LiveResponse> build() async {
    _lifecycle ??= AppLifecycleListener(
      onHide: () => _timer?.cancel(),
      onShow: () {
        _schedule();
        unawaited(refresh());
      },
    );
    ref.onDispose(() {
      _timer?.cancel();
      _lifecycle?.dispose();
    });
    _schedule();
    return await ref.read(stopsRepositoryProvider).live(stopId);
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => refresh());
  }

  Future<void> refresh() async {
    final next = await AsyncValue.guard(() => ref.read(stopsRepositoryProvider).live(stopId));
    // Keep showing the previous result's absence of data as an error state; never replay old
    // live data as if it were current.
    state = next;
  }
}

final liveArrivalsProvider = AsyncNotifierProvider.autoDispose
    .family<LiveArrivalsViewModel, LiveResponse, String>(LiveArrivalsViewModel.new);
