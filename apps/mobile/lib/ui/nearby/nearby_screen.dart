import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/map/transit_map.dart';
import 'package:izmir_go/ui/nearby/nearby_view_model.dart';

class NearbyScreen extends ConsumerStatefulWidget {
  const NearbyScreen({super.key});

  @override
  ConsumerState<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends ConsumerState<NearbyScreen> {
  bool _showMap = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(nearbyProvider);
    final vm = ref.read(nearbyProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.nearbyTitle),
        actions: [
          if (state.value is NearbyLoaded)
            IconButton(
              tooltip: _showMap ? l.list : l.map,
              icon: Icon(_showMap ? Icons.list : Icons.map_outlined),
              onPressed: () => setState(() => _showMap = !_showMap),
            ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(e, onRetry: vm.locate),
        data: (s) => switch (s) {
          NearbyNeedsPermission() => MessageView(
            icon: Icons.my_location,
            title: l.nearbyNeedsLocation,
            message: l.privacyText,
            actionLabel: l.allowLocation,
            onAction: vm.locate,
          ),
          NearbyLocationProblem(reason: LocationFailureReason.deniedForever) => MessageView(
            icon: Icons.location_disabled,
            title: l.locationDeniedForever,
            actionLabel: l.openSettings,
            onAction: () => ref.read(locationServiceProvider).openSettings(),
          ),
          NearbyLocationProblem() => MessageView(
            icon: Icons.location_disabled,
            title: l.locationDenied,
            actionLabel: l.retry,
            onAction: vm.locate,
          ),
          NearbyLoaded(:final position, :final stops) =>
            _showMap
                ? TransitMap(
                    semanticLabel: l.nearbyMapLabel,
                    center: (position.lat, position.lon),
                    zoom: 16,
                    showMyLocation: true,
                    points: [
                      for (final st in stops.data)
                        MapPoint(
                          id: st.id,
                          lat: st.lat,
                          lon: st.lon,
                          color: IzColors
                              .modeColors[st.modes.isEmpty ? TransitMode.other : st.modes.first]!,
                        ),
                    ],
                    onPointTap: (id) => context.push('/stop/${Uri.encodeComponent(id)}'),
                  )
                : RefreshIndicator(
                    onRefresh: vm.locate,
                    child: ListView(
                      children: [
                        FreshnessBanner(stops),
                        if (stops.data.isEmpty)
                          MessageView(icon: Icons.near_me_disabled, title: l.noNearbyStops),
                        for (final st in stops.data)
                          StopTile(
                            st,
                            onTap: () => context.push('/stop/${Uri.encodeComponent(st.id)}'),
                          ),
                      ],
                    ),
                  ),
        },
      ),
    );
  }
}
