import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/journey_search/journey_search_view_model.dart';

class JourneySearchScreen extends ConsumerWidget {
  const JourneySearchScreen({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref, {required bool origin}) async {
    final place = await context.push<Place>(
      '/place-picker?field=${origin ? 'origin' : 'destination'}',
    );
    if (place == null) {
      return;
    }
    final vm = ref.read(journeySearchProvider.notifier);
    origin ? vm.setOrigin(place) : vm.setDestination(place);
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, TimeMode mode) async {
    final vm = ref.read(journeySearchProvider.notifier);
    if (mode == TimeMode.now) {
      vm.setMode(TimeMode.now);
      return;
    }
    final now = izmirNow(ref.read(clockProvider)());
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
    if (picked == null) {
      return;
    }
    // Build the instant from İzmir wall-clock time (UTC+3).
    final utc = DateTime.utc(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    ).subtract(izmirUtcOffset);
    vm.setMode(mode, time: utc);
  }

  Future<void> _search(BuildContext context, WidgetRef ref) async {
    try {
      final query = await ref.read(journeySearchProvider.notifier).buildQuery();
      if (context.mounted) {
        await context.push('/results', extra: query);
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failureMessage(context.l10n, e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(journeySearchProvider);
    final recent = ref.watch(recentPlacesProvider).value ?? const <Place>[];
    final favorites = ref.watch(_favoriteStopsProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: IzSpace.sm),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(IzSpace.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _PlaceField(
                            key: const Key('origin-field'),
                            icon: Icons.trip_origin,
                            label: l.from,
                            place: state.origin,
                            onTap: () => _pick(context, ref, origin: true),
                          ),
                          const Divider(height: IzSpace.md),
                          _PlaceField(
                            key: const Key('destination-field'),
                            icon: Icons.place,
                            label: l.to,
                            place: state.destination,
                            onTap: () => _pick(context, ref, origin: false),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l.swap,
                      icon: const Icon(Icons.swap_vert),
                      onPressed: ref.read(journeySearchProvider.notifier).swap,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.md, IzSpace.gutter, 0),
            child: SegmentedButton<TimeMode>(
              segments: [
                ButtonSegment(value: TimeMode.now, label: Text(l.departNow)),
                ButtonSegment(
                  value: TimeMode.departAt,
                  label: Text(
                    state.mode == TimeMode.departAt && state.time != null
                        ? '${l.departAt} ${formatHm(state.time!)}'
                        : l.departAt,
                  ),
                ),
                ButtonSegment(
                  value: TimeMode.arriveBy,
                  label: Text(
                    state.mode == TimeMode.arriveBy && state.time != null
                        ? '${l.arriveBy} ${formatHm(state.time!)}'
                        : l.arriveBy,
                  ),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: (s) => _pickTime(context, ref, s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.md, IzSpace.gutter, 0),
            child: FilledButton.icon(
              key: const Key('search-button'),
              onPressed: state.canSearch ? () => _search(context, ref) : null,
              icon: const Icon(Icons.directions),
              label: Text(l.findRoutes),
            ),
          ),
          if (!state.canSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.sm, IzSpace.gutter, 0),
              child: Text(
                l.chooseOriginAndDestination,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (favorites.isNotEmpty) ...[
            SectionHeader(l.savedTitle),
            SizedBox(
              height: IzSpace.minTouch + 8,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                children: [
                  for (final f in favorites)
                    Padding(
                      padding: const EdgeInsets.only(right: IzSpace.sm),
                      child: ActionChip(
                        avatar: Icon(
                          modeIcon(f.modes.isEmpty ? TransitMode.other : f.modes.first),
                          size: 18,
                        ),
                        label: Text(f.name),
                        onPressed: () => context.push('/stop/${Uri.encodeComponent(f.stopId)}'),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (recent.isNotEmpty) ...[
            SectionHeader(
              l.recentPlaces,
              trailing: TextButton(
                onPressed: () async {
                  await ref.read(placesRepositoryProvider).clearRecent();
                  ref.invalidate(recentPlacesProvider);
                },
                child: Text(l.clearRecent),
              ),
            ),
            for (final p in recent)
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(p.name),
                subtitle: p.subtitle == null ? null : Text(p.subtitle!),
                onTap: () {
                  final vm = ref.read(journeySearchProvider.notifier);
                  state.origin == null ? vm.setOrigin(p) : vm.setDestination(p);
                },
              ),
          ],
        ],
      ),
    );
  }
}

final _favoriteStopsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(favoritesRepositoryProvider).watchStops(),
);

class _PlaceField extends StatelessWidget {
  const _PlaceField({
    required this.icon,
    required this.label,
    required this.place,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String label;
  final Place? place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '$label: ${place?.name ?? context.l10n.searchPlaceHint}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(IzRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: IzSpace.minTouch),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: IzSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: theme.textTheme.labelSmall),
                    Text(
                      place?.name ?? context.l10n.searchPlaceHint,
                      style: place == null
                          ? theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )
                          : theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
