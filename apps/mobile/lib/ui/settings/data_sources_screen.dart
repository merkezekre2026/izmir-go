import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/design_system/tiles.dart';
import 'package:izmir_go/ui/core/l10n.dart';

final transitStatusProvider = FutureProvider.autoDispose<Fresh<TransitStatus>>(
  (ref) => ref.watch(statusRepositoryProvider).status(),
);

const _attributionText =
    'Atıf 4.0 Uluslararası (CC BY 4.0) kapsamında lisanslanan kamu sektörü bilgilerini içerir. '
    'Kaynak: İzmir Büyükşehir Belediyesi Açık Veri Portalı (acikveri.bizizmir.com). '
    'Harita ve yol verisi © OpenStreetMap katkıcıları (ODbL).';

class DataSourcesScreen extends ConsumerWidget {
  const DataSourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final status = ref.watch(transitStatusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.dataSources)),
      body: status.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(e, onRetry: () => ref.invalidate(transitStatusProvider)),
        data: (fresh) => ListView(
          children: [
            FreshnessBanner(fresh),
            Padding(padding: const EdgeInsets.all(IzSpace.gutter), child: Text(l.dataSourcesIntro)),
            for (final s in fresh.data.sources)
              ListTile(
                isThreeLine: true,
                leading: Icon(
                  modeIcon(s.mode ?? TransitMode.other),
                  color: IzColors.modeColors[s.mode ?? TransitMode.other],
                ),
                title: Text(s.operator ?? s.source),
                subtitle: Text(
                  [
                    if (s.status == 'included') l.sourceIncluded else l.sourceExcluded,
                    if (s.validTo != null) l.validUntil(formatDate(s.validTo!)),
                    if (s.fetchedAt != null) l.lastUpdated(formatDateTime(s.fetchedAt!)),
                    if (s.liveData) l.liveAvailable,
                    if (s.timesApproximate) l.approximateTimes,
                  ].join(' · '),
                ),
                trailing: Icon(
                  s.status == 'included' ? Icons.check_circle_outline : Icons.remove_circle_outline,
                  semanticLabel: s.status == 'included' ? l.sourceIncluded : l.sourceExcluded,
                ),
              ),
            SectionHeader(l.attribution),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: IzSpace.gutter),
              child: Text(_attributionText),
            ),
            Padding(
              padding: const EdgeInsets.all(IzSpace.gutter),
              child: Text(l.notOfficial, style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
