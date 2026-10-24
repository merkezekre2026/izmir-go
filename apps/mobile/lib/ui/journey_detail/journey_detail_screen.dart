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
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/map/transit_map.dart';

final rememberedJourneyProvider = FutureProvider.autoDispose.family<Fresh<Journey>?, String>(
  (ref, id) => ref.watch(journeysRepositoryProvider).remembered(id),
);

class JourneyDetailScreen extends ConsumerWidget {
  const JourneyDetailScreen({required this.journeyId, this.journey, super.key});
  final String journeyId;
  final Journey? journey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (journey != null) {
      return _JourneyDetailBody(journey!);
    }
    return ref
        .watch(rememberedJourneyProvider(journeyId))
        .when(
          loading: () => const Scaffold(body: LoadingView()),
          error: (e, _) => Scaffold(appBar: AppBar(), body: ErrorView(e)),
          data: (fresh) => fresh == null
              ? Scaffold(
                  appBar: AppBar(),
                  body: MessageView(icon: Icons.search_off, title: l.errorNotFound),
                )
              : _JourneyDetailBody(fresh.data),
        );
  }
}

class _JourneyDetailBody extends StatelessWidget {
  const _JourneyDetailBody(this.journey);
  final Journey journey;

  List<MapLine> get _lines => [
    for (final leg in journey.legs)
      MapLine(
        leg.geometry,
        color: leg.isWalk
            ? IzColors.modeColors[TransitMode.walk]!
            : routeColor(leg.route?.color, leg.mode),
        dashed: leg.isWalk,
        width: leg.isWalk ? 3 : 6,
      ),
  ];

  List<MapPoint> get _points => [
    for (final leg in journey.transitLegs) ...[
      MapPoint(
        id: 'b-${leg.tripId}',
        lat: leg.origin.lat,
        lon: leg.origin.lon,
        color: routeColor(leg.route?.color, leg.mode),
      ),
      MapPoint(
        id: 'a-${leg.tripId}',
        lat: leg.destination.lat,
        lon: leg.destination.lon,
        color: routeColor(leg.route?.color, leg.mode),
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final approxGeometry = journey.legs.any(
      (leg) => leg.geometryBasis == 'stop_to_stop' || leg.geometryBasis == 'straight_line',
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.journeyDetail)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapHeight = (constraints.maxHeight * 0.38).clamp(160.0, 360.0);
          return Column(
            children: [
              SizedBox(
                height: mapHeight,
                child: TransitMap(semanticLabel: l.journeyMapLabel, lines: _lines, points: _points),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: IzSpace.xl),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        IzSpace.gutter,
                        IzSpace.md,
                        IzSpace.gutter,
                        0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${formatHm(journey.start)} – ${formatHm(journey.end)}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Text(l.minutesShort((journey.durationS / 60).round())),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IzSpace.gutter,
                        vertical: IzSpace.xs,
                      ),
                      child: DataBasisTag(
                        Basis.scheduled,
                        approximate: journey.legs.any((x) => x.timesApproximate),
                      ),
                    ),
                    for (final (i, leg) in journey.legs.indexed)
                      _LegTile(leg: leg, isLast: i == journey.legs.length - 1),
                    if (approxGeometry)
                      Padding(
                        padding: const EdgeInsets.all(IzSpace.gutter),
                        child: Text(
                          l.geometryApproximate,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
                      child: Text(
                        l.scheduledBasisExplain,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LegTile extends StatelessWidget {
  const _LegTile({required this.leg, required this.isLast});
  final JourneyLeg leg;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final color = leg.isWalk
        ? IzColors.modeColors[TransitMode.walk]!
        : routeColor(leg.route?.color, leg.mode);
    final String title;
    final List<String> lines;
    if (leg.isWalk) {
      title = leg.isTransfer ? l.transferWalk(leg.distanceM) : l.walkTo(leg.destination.name);
      lines = [l.minutesShort((leg.durationS / 60).ceil())];
    } else {
      title = l.boardAt(leg.origin.name);
      lines = [
        if (leg.headsign != null) l.towards(leg.headsign!),
        l.intermediateStops(leg.intermediateStops.length),
        l.alightAt(leg.destination.name),
      ];
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: IzSpace.md, left: IzSpace.gutter),
              child: Column(
                children: [
                  Text(formatHm(leg.start), style: theme.textTheme.labelLarge),
                  if (!leg.isWalk) ...[
                    const Spacer(),
                    Text(formatHm(leg.end), style: theme.textTheme.labelLarge),
                    const SizedBox(height: IzSpace.md),
                  ],
                ],
              ),
            ),
          ),
          Container(
            width: leg.isWalk ? 2 : 6,
            margin: const EdgeInsets.symmetric(horizontal: IzSpace.md),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, IzSpace.md, IzSpace.gutter, IzSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!leg.isWalk && leg.route != null) ...[
                    InkWell(
                      onTap: () => context.push('/line/${Uri.encodeComponent(leg.route!.id)}'),
                      child: LineBadge.route(leg.route!),
                    ),
                    const SizedBox(height: IzSpace.xs),
                  ],
                  Text(title, style: theme.textTheme.bodyLarge),
                  for (final s in lines) Text(s, style: theme.textTheme.bodySmall),
                  if (leg.timesApproximate)
                    Text(l.approxStopTimes, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
