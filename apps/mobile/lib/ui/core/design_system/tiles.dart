import 'package:flutter/material.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/l10n.dart';

class StopTile extends StatelessWidget {
  const StopTile(this.stop, {this.onTap, this.trailing, super.key});
  final StopSummary stop;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final subtitle = [
      if (stop.isStation) l.transferPoint,
      if (stop.lines.isNotEmpty) stop.lines.take(6).join(' · '),
      if (!stop.hasSchedule) l.noTimetableLive,
    ].where((s) => s.isNotEmpty).join(' — ');
    return ListTile(
      minTileHeight: IzSpace.minTouch + 8,
      leading: ModeIcons(stop.modes),
      title: Text(stop.name),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing:
          trailing ??
          (stop.distanceM == null
              ? null
              : Text(
                  l.metersAway(stop.distanceM!),
                  style: Theme.of(context).textTheme.labelMedium,
                )),
      onTap: onTap,
    );
  }
}

class DepartureRow extends StatelessWidget {
  const DepartureRow(this.departure, {required this.now, this.cached = false, super.key});
  final Departure departure;
  final DateTime now;
  final bool cached;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mins = minutesBetween(now, departure.scheduledDeparture);
    final theme = Theme.of(context);
    return MergeSemantics(
      child: ListTile(
        minTileHeight: IzSpace.minTouch + 8,
        leading: LineBadge.route(departure.route),
        title: Text(
          departure.headsign == null
              ? departure.route.longName ?? ''
              : l.towards(departure.headsign!),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: DataBasisTag(
          cached ? Basis.cached : Basis.scheduled,
          approximate: departure.timesApproximate,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatHm(departure.scheduledDeparture), style: theme.textTheme.titleMedium),
            if (mins <= 60) Text(l.minutesShort(mins), style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.lg, IzSpace.gutter, IzSpace.xs),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
