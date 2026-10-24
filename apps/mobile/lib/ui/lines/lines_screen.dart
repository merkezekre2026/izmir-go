import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/search_text.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/badges.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/l10n.dart';

final routesProvider = FutureProvider.autoDispose<Fresh<List<RouteSummary>>>(
  (ref) => ref.watch(linesRepositoryProvider).routes(),
);

class LinesScreen extends ConsumerStatefulWidget {
  const LinesScreen({super.key});

  @override
  ConsumerState<LinesScreen> createState() => _LinesScreenState();
}

class _LinesScreenState extends ConsumerState<LinesScreen> {
  String _query = '';
  TransitMode? _mode;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final routes = ref.watch(routesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.linesTitle)),
      body: routes.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(e, onRetry: () => ref.invalidate(routesProvider)),
        data: (fresh) {
          final key = fold(_query);
          final modes = {for (final r in fresh.data) r.mode}.toList()
            ..sort((a, b) => a.index.compareTo(b.index));
          final items = fresh.data
              .where((r) => _mode == null || r.mode == _mode)
              .where(
                (r) =>
                    key.isEmpty || fold('${r.shortName ?? ''} ${r.longName ?? ''}').contains(key),
              )
              .toList();
          return ListView(
            children: [
              FreshnessBanner(fresh),
              Padding(
                padding: const EdgeInsets.fromLTRB(IzSpace.gutter, IzSpace.sm, IzSpace.gutter, 0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l.searchLinesHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              SizedBox(
                height: IzSpace.minTouch + 8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: IzSpace.gutter,
                    vertical: IzSpace.xs,
                  ),
                  children: [
                    for (final m in modes)
                      Padding(
                        padding: const EdgeInsets.only(right: IzSpace.sm),
                        child: FilterChip(
                          avatar: Icon(modeIcon(m), size: 18),
                          label: Text(modeLabel(l, m)),
                          selected: _mode == m,
                          onSelected: (sel) => setState(() => _mode = sel ? m : null),
                        ),
                      ),
                  ],
                ),
              ),
              if (items.isEmpty) MessageView(icon: Icons.search_off, title: l.noLines),
              for (final r in items)
                ListTile(
                  minTileHeight: IzSpace.minTouch + 8,
                  leading: LineBadge.route(r),
                  title: Text(r.longName ?? r.label),
                  onTap: () => context.push('/line/${Uri.encodeComponent(r.id)}'),
                ),
            ],
          );
        },
      ),
    );
  }
}
