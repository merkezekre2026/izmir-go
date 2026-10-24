import 'package:flutter/material.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/l10n.dart';

IconData modeIcon(TransitMode mode) => switch (mode) {
  TransitMode.bus => Icons.directions_bus_filled,
  TransitMode.metro => Icons.subway,
  TransitMode.tram => Icons.tram,
  TransitMode.rail => Icons.train,
  TransitMode.ferry => Icons.directions_boat_filled,
  TransitMode.walk => Icons.directions_walk,
  TransitMode.other => Icons.commute,
};

/// Coloured badge for a line: icon + short name. Colour is never the only signal.
class LineBadge extends StatelessWidget {
  const LineBadge({required this.mode, required this.label, this.color, this.textColor, super.key});

  factory LineBadge.route(RouteSummary r, {Key? key}) =>
      LineBadge(mode: r.mode, label: r.label, color: r.color, textColor: r.textColor, key: key);

  final TransitMode mode;
  final String label;
  final String? color;
  final String? textColor;

  @override
  Widget build(BuildContext context) {
    final bg = routeColor(color, mode);
    final fg = onColor(bg, hex: textColor);
    return Semantics(
      label: '${modeLabel(context.l10n, mode)} $label',
      excludeSemantics: true,
      child: Container(
        // Tram lines have no short name, so the label can be long: cap the width.
        constraints: const BoxConstraints(minHeight: 28, maxWidth: 136),
        padding: const EdgeInsets.symmetric(horizontal: IzSpace.sm, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(IzRadius.sm)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(modeIcon(mode), size: 16, color: fg),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: fg, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModeIcons extends StatelessWidget {
  const ModeIcons(this.modes, {super.key});
  final List<TransitMode> modes;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      label: modes.map((m) => modeLabel(l, m)).join(', '),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in modes)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(modeIcon(m), size: 18, color: IzColors.modeColors[m]),
            ),
        ],
      ),
    );
  }
}

enum Basis { scheduled, live, cached }

/// Says where a time comes from: timetable, live feed, or the device cache.
class DataBasisTag extends StatelessWidget {
  const DataBasisTag(this.basis, {this.at, this.approximate = false, super.key});

  final Basis basis;
  final DateTime? at;
  final bool approximate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (icon, color, text) = switch (basis) {
      Basis.scheduled => (Icons.schedule, IzColors.scheduled, l.scheduledBasis),
      Basis.live => (Icons.sensors, IzColors.live, l.liveBasis),
      Basis.cached => (Icons.cloud_off, IzColors.cached, l.cachedBasis),
    };
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = dark ? Theme.of(context).colorScheme.onSurface : color;
    final label = [
      text,
      if (at != null) formatHm(at!),
      if (approximate) l.approximateTimes.toLowerCase(),
    ].join(' · ');
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }
}
