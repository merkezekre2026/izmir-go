import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/core/design_system/states.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/journey_search/journey_search_view_model.dart';

final placeQueryProvider = NotifierProvider.autoDispose<_Query, String>(_Query.new);

class _Query extends Notifier<String> {
  @override
  String build() => '';
  // A method reads better than a setter at the call site (`notifier.set(q)`).
  // ignore: use_setters_to_change_properties
  void set(String q) => state = q;
}

/// (results, offline). Debounced by the screen before the query changes.
final placeResultsProvider = FutureProvider.autoDispose<(List<Place>, bool)>((ref) async {
  final q = ref.watch(placeQueryProvider).trim();
  if (q.length < 2) {
    return (const <Place>[], false);
  }
  return await ref.watch(placesRepositoryProvider).search(q);
});

class PlacePickerScreen extends ConsumerStatefulWidget {
  const PlacePickerScreen({required this.isOrigin, super.key});
  final bool isOrigin;

  @override
  ConsumerState<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends ConsumerState<PlacePickerScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => ref.read(placeQueryProvider.notifier).set(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final results = ref.watch(placeResultsProvider);
    final query = ref.watch(placeQueryProvider);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('place-search-field'),
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l.searchPlaceHint,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: _onChanged,
        ),
      ),
      body: ListView(
        children: [
          if (widget.isOrigin)
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(l.myLocation),
              onTap: () => context.pop(currentLocationPlace(l.myLocation)),
            ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: Text(l.pickOnMap),
            onTap: () async {
              final place = await context.push<Place>('/map-pick');
              if (place != null && context.mounted) {
                context.pop(place);
              }
            },
          ),
          const Divider(),
          ...results.when(
            loading: () => [
              if (query.length >= 2)
                const Padding(padding: EdgeInsets.all(IzSpace.xl), child: LoadingView()),
            ],
            error: (e, _) => [ErrorView(e, onRetry: () => ref.invalidate(placeResultsProvider))],
            data: (r) {
              final (items, offline) = r;
              return [
                if (offline)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: IzSpace.gutter,
                      vertical: IzSpace.sm,
                    ),
                    child: Text(
                      '${l.offline}: ${l.errorNetwork}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                for (final p in items)
                  ListTile(
                    leading: Icon(p.isStop ? Icons.directions_transit : Icons.place_outlined),
                    title: Text(p.name),
                    subtitle: p.subtitle == null ? null : Text(p.subtitle!),
                    onTap: () => context.pop(p),
                  ),
                if (items.isEmpty && query.trim().length >= 2)
                  Padding(
                    padding: const EdgeInsets.all(IzSpace.xl),
                    child: Text(l.errorNotFound, textAlign: TextAlign.center),
                  ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
