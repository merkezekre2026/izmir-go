import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/data/repositories/favorites_repository.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';

final favoriteStopsProvider = StreamProvider.autoDispose<List<FavoriteStop>>(
  (ref) => ref.watch(favoritesRepositoryProvider).watchStops(),
);
final favoriteLinesProvider = StreamProvider.autoDispose<List<RouteSummary>>(
  (ref) => ref.watch(favoritesRepositoryProvider).watchLines(),
);

/// Ids of favourite stops still present in the offline catalog (null = catalog not synced).
final existingStopIdsProvider = FutureProvider.autoDispose<Set<String>?>((ref) async {
  final favs = await ref.watch(favoriteStopsProvider.future);
  final catalog = ref.watch(catalogRepositoryProvider);
  if (await catalog.lastSync() == null) {
    return null;
  }
  final present = <String>{};
  for (final f in favs) {
    if (await catalog.stopById(f.stopId) != null) {
      present.add(f.stopId);
    }
  }
  return present;
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stops = ref.watch(favoriteStopsProvider).value ?? const [];
    final lines = ref.watch(favoriteLinesProvider).value ?? const [];
    final existing = ref.watch(existingStopIdsProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.savedTitle)),
      body: stops.isEmpty && lines.isEmpty
          ? MessageView(icon: Icons.star_border, title: l.savedEmpty)
          : ListView(
              children: [
                if (stops.isNotEmpty) SectionHeader(l.favoriteStops),
                for (final s in stops)
                  ListTile(
                    leading: ModeIcons(s.modes),
                    title: Text(s.name),
                    subtitle: existing != null && !existing.contains(s.stopId)
                        ? Text(l.stopNoLongerExists)
                        : null,
                    trailing: IconButton(
                      tooltip: l.removeFavorite,
                      icon: const Icon(Icons.star),
                      onPressed: () => ref
                          .read(favoritesRepositoryProvider)
                          .toggleStop(s.stopId, s.name, s.modes),
                    ),
                    onTap: () => context.push('/stop/${Uri.encodeComponent(s.stopId)}'),
                  ),
                if (lines.isNotEmpty) SectionHeader(l.favoriteLines),
                for (final r in lines)
                  ListTile(
                    leading: LineBadge.route(r),
                    title: Text(r.longName ?? r.label),
                    trailing: IconButton(
                      tooltip: l.removeFavorite,
                      icon: const Icon(Icons.star),
                      onPressed: () => ref.read(favoritesRepositoryProvider).toggleLine(r),
                    ),
                    onTap: () => context.push('/line/${Uri.encodeComponent(r.id)}'),
                  ),
              ],
            ),
    );
  }
}
