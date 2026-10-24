import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/ui/core/l10n.dart';
import 'package:izmir_go/ui/journey_search/journey_search_view_model.dart';

final lastCatalogSyncProvider = FutureProvider.autoDispose<DateTime?>(
  (ref) => ref.watch(catalogRepositoryProvider).lastSync(),
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final synced = ref.watch(lastCatalogSyncProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dataset_outlined),
            title: Text(l.dataSources),
            subtitle: synced == null ? null : Text(l.lastUpdated(formatDateTime(synced))),
            onTap: () => context.push('/settings/sources'),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: Text(l.refreshData),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref.read(catalogRepositoryProvider).sync();
                ref.invalidate(lastCatalogSyncProvider);
              } on Exception catch (e) {
                if (context.mounted) {
                  messenger.showSnackBar(SnackBar(content: Text(failureMessage(l, e))));
                }
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacy),
            subtitle: Text(l.privacyText),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l.clearLocalData),
            onTap: () async {
              await ref.read(databaseProvider).clearAll();
              ref
                ..invalidate(lastCatalogSyncProvider)
                ..invalidate(recentPlacesProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l.localDataCleared)));
              }
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(IzSpace.gutter),
            child: Text(l.notOfficial, style: Theme.of(context).textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: IzSpace.gutter),
            child: Text(
              l.appVersion('0.1.0 (${ref.watch(appConfigProvider).flavor})'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
