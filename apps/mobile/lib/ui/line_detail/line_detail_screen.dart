import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/map/transit_map.dart';

final routeDetailProvider = FutureProvider.autoDispose.family<Fresh<RouteResponse>, String>(
  (ref, id) => ref.watch(linesRepositoryProvider).route(id),
);

final routeScheduleProvider = FutureProvider.autoDispose.family<ScheduleResponse, (String, int?)>(
  (ref, arg) => ref.watch(linesRepositoryProvider).schedule(arg.$1, direction: arg.$2),
);

final routeAlertsProvider = FutureProvider.autoDispose.family<List<Alert>, String>(
  (ref, id) => ref.watch(linesRepositoryProvider).alerts(id),
);

final isFavoriteLineProvider = StreamProvider.autoDispose.family<bool, String>(
  (ref, id) => ref.watch(favoritesRepositoryProvider).watchIsFavoriteLine(id),
);

class LineDetailScreen extends ConsumerStatefulWidget {
  const LineDetailScreen({required this.routeId, super.key});
  final String routeId;

  @override
  ConsumerState<LineDetailScreen> createState() => _LineDetailScreenState();
}

class _LineDetailScreenState extends ConsumerState<LineDetailScreen> {
  int _pattern = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final detail = ref.watch(routeDetailProvider(widget.routeId));
    final isFav = ref.watch(isFavoriteLineProvider(widget.routeId)).value ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.data.route.shortName ?? detail.value?.data.route.longName ?? ''),
        actions: [
          if (detail.value != null)
            IconButton(
              tooltip: isFav ? l.removeFavorite : l.addFavorite,
              icon: Icon(isFav ? Icons.star : Icons.star_border),
              onPressed: () {
                final r = detail.value!.data.route;
                unawaited(
                  ref
                      .read(favoritesRepositoryProvider)
                      .toggleLine(
                        RouteSummary(
                          id: r.id,
                          lineKey: r.lineKey,
                          mode: r.mode,
                          source: r.source,
                          timesApproximate: r.timesApproximate,
                          shortName: r.shortName,
                          longName: r.longName,
                          color: r.color,
                          textColor: r.textColor,
                        ),
                      ),
                );
              },
            ),
        ],
      ),
      body: detail.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(e, onRetry: () => ref.invalidate(routeDetailProvider(widget.routeId))),
        data: (fresh) {
          final r = fresh.data.route;
          final patterns = r.patterns;
          final p = patterns.isEmpty ? null : patterns[_pattern.clamp(0, patterns.length - 1)];
          final color = routeColor(r.color, r.mode);
          final geometry =
              p?.geometry ??
              [
                for (final s in p?.stops ?? <StopSummary>[]) [s.lon, s.lat],
              ];
          final schedule = ref.watch(routeScheduleProvider((r.id, p?.directionId)));
          final alerts = ref.watch(routeAlertsProvider(r.id)).value ?? const <Alert>[];
          return ListView(
            children: [
              FreshnessBanner(fresh),
              SizedBox(
                height: 200,
                child: TransitMap(
                  semanticLabel: l.mapLabel,
                  lines: [MapLine(geometry, color: color)],
                  points: [
                    for (final s in p?.stops ?? <StopSummary>[])
                      MapPoint(id: s.id, lat: s.lat, lon: s.lon, color: color, radius: 4),
                  ],
                  onPointTap: (id) => context.push('/stop/${Uri.encodeComponent(id)}'),
                ),
              ),
              if (p?.geometryBasis == 'stop_to_stop')
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IzSpace.gutter,
                    vertical: IzSpace.xs,
                  ),
                  child: Text(l.geometryApproximate, style: Theme.of(context).textTheme.bodySmall),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.md, IzSpace.gutter, 0),
                child: Row(
                  children: [
                    LineBadge(
                      mode: r.mode,
                      label: r.shortName ?? modeLabel(l, r.mode),
                      color: r.color,
                      textColor: r.textColor,
                    ),
                    const SizedBox(width: IzSpace.sm),
                    Expanded(
                      child: Text(r.longName ?? '', style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              if (r.timesApproximate)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IzSpace.gutter,
                    vertical: IzSpace.xs,
                  ),
                  child: Text(l.approxStopTimes, style: Theme.of(context).textTheme.bodySmall),
                ),
              if (patterns.length > 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.md, IzSpace.gutter, 0),
                  child: SegmentedButton<int>(
                    segments: [
                      for (final (i, pt) in patterns.indexed)
                        ButtonSegment(
                          value: i,
                          label: Text(pt.headsign ?? '${l.direction} ${i + 1}', maxLines: 1),
                        ),
                    ],
                    selected: {_pattern},
                    onSelectionChanged: (s) => setState(() => _pattern = s.first),
                  ),
                ),
              if (alerts.isNotEmpty) ...[
                SectionHeader(l.alerts),
                for (final a in alerts)
                  ListTile(
                    leading: const Icon(Icons.campaign_outlined),
                    title: Text(a.title),
                    subtitle: a.endsAt == null ? null : Text('→ ${formatDate(toIzmir(a.endsAt!))}'),
                  ),
              ],
              SectionHeader(l.todaySchedule),
              schedule.when(
                loading: () =>
                    const Padding(padding: EdgeInsets.all(IzSpace.lg), child: LoadingView()),
                error: (e, _) => ErrorView(e),
                data: (sch) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                  child: sch.items.isEmpty
                      ? Text(l.noDepartures)
                      : Wrap(
                          spacing: IzSpace.sm,
                          runSpacing: IzSpace.xs,
                          children: [
                            for (final t in sch.items)
                              Chip(label: Text(formatHm(t.firstDeparture))),
                          ],
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: IzSpace.gutter, vertical: IzSpace.xs),
                child: DataBasisTag(Basis.scheduled),
              ),
              SectionHeader(l.stopsOnLine),
              for (final s in p?.stops ?? <StopSummary>[])
                StopTile(s, onTap: () => context.push('/stop/${Uri.encodeComponent(s.id)}')),
              const SizedBox(height: IzSpace.xl),
            ],
          );
        },
      ),
    );
  }
}
