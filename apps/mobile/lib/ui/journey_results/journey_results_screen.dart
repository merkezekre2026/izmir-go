import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/journey_search/journey_search_view_model.dart';

final journeyResultsProvider = FutureProvider.autoDispose.family<JourneysResponse, JourneyQuery>(
  (ref, q) => ref
      .watch(journeysRepositoryProvider)
      .plan(from: q.from, to: q.to, at: q.at, arriveBy: q.arriveBy),
);

class JourneyResultsScreen extends ConsumerWidget {
  const JourneyResultsScreen({required this.query, super.key});
  final JourneyQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final result = ref.watch(journeyResultsProvider(query));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.results),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
              left: IzSpace.gutter,
              right: IzSpace.gutter,
              bottom: IzSpace.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${query.from.name} → ${query.to.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
      body: result.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(e, onRetry: () => ref.invalidate(journeyResultsProvider(query))),
        data: (res) {
          final transit = res.items.where((j) => !j.isWalkOnly).toList();
          final walk = res.items.where((j) => j.isWalkOnly).toList();
          return RefreshIndicator(
            onRefresh: () => ref.refresh(journeyResultsProvider(query).future),
            child: ListView(
              children: [
                NoticeList(
                  res.meta.notices,
                  include: const {
                    'SOURCE_EXCLUDED',
                    'SOURCE_OUT_OF_VALIDITY',
                    'NO_HOLIDAY_CALENDAR',
                  },
                ),
                for (final e in res.routingErrors)
                  if (e.code != 'WALKING_BETTER_THAN_TRANSIT' || transit.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: IzSpace.gutter,
                        vertical: IzSpace.xs,
                      ),
                      child: Text(e.message, style: Theme.of(context).textTheme.bodyMedium),
                    ),
                if (res.items.isEmpty)
                  MessageView(
                    icon: Icons.directions_off,
                    title: l.noJourneys,
                    message: l.noJourneysHint,
                  ),
                for (final j in transit) _JourneyCard(j),
                if (walk.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      IzSpace.gutter,
                      IzSpace.lg,
                      IzSpace.gutter,
                      IzSpace.xs,
                    ),
                    child: Text(l.walkAlternative, style: Theme.of(context).textTheme.titleSmall),
                  ),
                  for (final j in walk) _JourneyCard(j),
                ],
                Padding(
                  padding: const EdgeInsets.all(IzSpace.gutter),
                  child: Text(
                    l.scheduledBasisExplain,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _JourneyCard extends ConsumerWidget {
  const _JourneyCard(this.journey);
  final Journey journey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final minutes = (journey.durationS / 60).round();
    final approx = journey.legs.any((leg) => leg.timesApproximate);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter, vertical: IzSpace.xs),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            await ref.read(journeysRepositoryProvider).remember(journey);
            if (context.mounted) {
              await context.push('/journey/${journey.id}', extra: journey);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(IzSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${formatHm(journey.start)} – ${formatHm(journey.end)}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      l.minutesShort(minutes),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: IzSpace.sm),
                Wrap(
                  spacing: IzSpace.xs,
                  runSpacing: IzSpace.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final (i, leg) in journey.legs.indexed) ...[
                      if (i > 0) const ExcludeSemantics(child: Icon(Icons.chevron_right, size: 16)),
                      if (leg.isWalk)
                        Semantics(
                          label: '${l.modeWalk} ${leg.distanceM} m',
                          excludeSemantics: true,
                          child: const Icon(Icons.directions_walk, size: 20),
                        )
                      else if (leg.route != null)
                        LineBadge.route(leg.route!)
                      else
                        LineBadge(mode: leg.mode, label: modeLabel(l, leg.mode)),
                    ],
                  ],
                ),
                const SizedBox(height: IzSpace.sm),
                Text(
                  [
                    if (journey.isWalkOnly) l.walkOnly else l.transfers(journey.transfers),
                    l.walkMeters(journey.walkDistanceM),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: IzSpace.xs),
                DataBasisTag(Basis.scheduled, approximate: approx),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
