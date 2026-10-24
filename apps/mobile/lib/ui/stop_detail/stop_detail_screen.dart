import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/stop_detail/stop_detail_view_model.dart';

class StopDetailScreen extends ConsumerWidget {
  const StopDetailScreen({required this.stopId, super.key});
  final String stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stop = ref.watch(stopProvider(stopId));
    final isFav = ref.watch(isFavoriteStopProvider(stopId)).value ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(stop.value?.data.stop.name ?? ''),
        actions: [
          if (stop.value != null)
            IconButton(
              tooltip: isFav ? l.removeFavorite : l.addFavorite,
              icon: Icon(isFav ? Icons.star : Icons.star_border),
              onPressed: () {
                final s = stop.value!.data.stop;
                unawaited(ref.read(favoritesRepositoryProvider).toggleStop(s.id, s.name, s.modes));
              },
            ),
        ],
      ),
      body: stop.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(e, onRetry: () => ref.invalidate(stopProvider(stopId))),
        data: (fresh) {
          final s = fresh.data.stop;
          return RefreshIndicator(
            onRefresh: () async {
              ref
                ..invalidate(departuresProvider(stopId))
                ..invalidate(liveArrivalsProvider(stopId));
              await ref.read(stopProvider(stopId).future);
            },
            child: ListView(
              children: [
                FreshnessBanner(fresh),
                Padding(
                  padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.md, IzSpace.gutter, 0),
                  child: Row(
                    children: [
                      ModeIcons(s.modes),
                      if (s.kind == 'station') ...[
                        const SizedBox(width: IzSpace.sm),
                        Text(l.transferPoint, style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ],
                  ),
                ),
                if (s.liveSupported) _LiveSection(stopId: stopId),
                SectionHeader(l.departures),
                if (s.hasSchedule)
                  _DeparturesSection(stopId: stopId)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                    child: Text(l.noScheduleForStop),
                  ),
                if (s.routes.isNotEmpty || s.lines.isNotEmpty) SectionHeader(l.linesAtStop),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                  child: Wrap(
                    spacing: IzSpace.sm,
                    runSpacing: IzSpace.sm,
                    children: [
                      for (final r in s.routes)
                        InkWell(
                          onTap: () => context.push('/line/${Uri.encodeComponent(r.id)}'),
                          child: LineBadge.route(r),
                        ),
                      for (final line in s.lines) LineBadge(mode: TransitMode.bus, label: line),
                    ],
                  ),
                ),
                if (s.children.isNotEmpty) ...[
                  SectionHeader(l.transferPoint),
                  for (final c in s.children)
                    StopTile(c, onTap: () => context.push('/stop/${Uri.encodeComponent(c.id)}')),
                ],
                NoticeList(fresh.data.meta.notices, include: const {'NO_HOLIDAY_CALENDAR'}),
                const SizedBox(height: IzSpace.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DeparturesSection extends ConsumerWidget {
  const _DeparturesSection({required this.stopId});
  final String stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final now = ref.watch(clockProvider)();
    return ref
        .watch(departuresProvider(stopId))
        .when(
          loading: () => const Padding(padding: EdgeInsets.all(IzSpace.xl), child: LoadingView()),
          error: (e, _) => ErrorView(e, onRetry: () => ref.invalidate(departuresProvider(stopId))),
          data: (fresh) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (fresh.isCached)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                  child: DataBasisTag(Basis.cached, at: fresh.fetchedAt),
                ),
              NoticeList(
                fresh.data.meta.notices,
                include: const {'SOURCE_OUT_OF_VALIDITY', 'TIMES_APPROXIMATE'},
              ),
              if (fresh.data.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IzSpace.gutter,
                    vertical: IzSpace.md,
                  ),
                  child: Text(l.noDepartures),
                ),
              for (final d in fresh.data.items) DepartureRow(d, now: now, cached: fresh.isCached),
            ],
          ),
        );
  }
}

class _LiveSection extends ConsumerWidget {
  const _LiveSection({required this.stopId});
  final String stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final live = ref.watch(liveArrivalsProvider(stopId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          l.approaching,
          trailing: live.value?.fetchedAt == null
              ? null
              : DataBasisTag(Basis.live, at: live.value!.fetchedAt),
        ),
        live.when(
          skipLoadingOnRefresh: true,
          loading: () => const Padding(padding: EdgeInsets.all(IzSpace.lg), child: LoadingView()),
          error: (e, _) =>
              ListTile(leading: const Icon(Icons.sensors_off), title: Text(l.liveUnavailable)),
          data: (res) => Semantics(
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (res.items.isEmpty) ListTile(title: Text(l.liveNone)),
                for (final v in res.items.take(8))
                  MergeSemantics(
                    child: ListTile(
                      leading: LineBadge(
                        mode: TransitMode.bus,
                        label: v.lineNumber,
                        color: v.color,
                      ),
                      title: Text(v.lineName, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text(
                        l.stopsAway(v.remainingStops),
                        style: theme.textTheme.titleSmall,
                      ),
                      subtitle: v.wheelchairAccessible ?? false
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.accessible,
                                size: 16,
                                semanticLabel: l.wheelchairAccessible,
                              ),
                            )
                          : null,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                  child: Text(
                    [
                      l.liveExplain,
                      if (res.fetchedAt != null) l.liveFetchedAt(formatHm(res.fetchedAt!)),
                    ].join(' '),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
