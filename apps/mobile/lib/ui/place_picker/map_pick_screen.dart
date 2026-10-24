import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/core/geo.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/map/transit_map.dart';

/// Pick a point by tapping the map. The label comes from reverse geocoding when available,
/// otherwise the coordinates are used as-is.
class MapPickScreen extends ConsumerStatefulWidget {
  const MapPickScreen({super.key});

  @override
  ConsumerState<MapPickScreen> createState() => _MapPickScreenState();
}

class _MapPickScreenState extends ConsumerState<MapPickScreen> {
  (double, double)? _point;
  bool _busy = false;

  Future<void> _confirm() async {
    final p = _point;
    if (p == null) {
      return;
    }
    setState(() => _busy = true);
    final l = context.l10n;
    Place? label;
    try {
      label = await ref.read(placesRepositoryProvider).reverse(p.$1, p.$2);
    } on AppFailure {
      label = null;
    }
    if (!mounted) {
      return;
    }
    context.pop(
      Place(
        id: 'point:${p.$1.toStringAsFixed(5)},${p.$2.toStringAsFixed(5)}',
        name: label?.name ?? l.selectedPoint,
        subtitle: label?.subtitle ?? '${p.$1.toStringAsFixed(5)}, ${p.$2.toStringAsFixed(5)}',
        lat: p.$1,
        lon: p.$2,
        kind: 'address',
        provider: 'map',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = _point;
    return Scaffold(
      appBar: AppBar(title: Text(l.pickOnMap)),
      body: Column(
        children: [
          Expanded(
            child: TransitMap(
              semanticLabel: l.mapLabel,
              points: [
                if (p != null)
                  MapPoint(id: 'pick', lat: p.$1, lon: p.$2, color: IzColors.korfez, radius: 9),
              ],
              center: p ?? (38.4237, 27.1428),
              onMapTap: (lat, lon) {
                if (inIzmir(lat, lon)) {
                  setState(() => _point = (lat, lon));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l.errorOutsideCoverage)));
                }
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(IzSpace.gutter),
              child: FilledButton(
                onPressed: p == null || _busy ? null : _confirm,
                child: Text(p == null ? l.moveMapToSelect : l.selectThisPoint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
