import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/router.dart';
import 'package:izmir_go/app/theme/theme.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/l10n/gen/app_localizations.dart';

class IzmirGoApp extends ConsumerStatefulWidget {
  const IzmirGoApp({this.router, super.key});
  final GoRouter? router;

  @override
  ConsumerState<IzmirGoApp> createState() => _IzmirGoAppState();
}

class _IzmirGoAppState extends ConsumerState<IzmirGoApp> {
  late final GoRouter _router = widget.router ?? buildRouter();

  @override
  void initState() {
    super.initState();
    unawaited(_syncCatalog());
  }

  /// Background refresh of the offline catalog (at most daily). Failures are silent: the app
  /// keeps the previous copy and labels it with its timestamp.
  Future<void> _syncCatalog() async {
    final catalog = ref.read(catalogRepositoryProvider);
    try {
      if (await catalog.needsSync()) {
        await catalog.sync();
      }
    } on AppFailure {
      // offline or server unavailable
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
    debugShowCheckedModeBanner: false,
    theme: buildTheme(Brightness.light),
    darkTheme: buildTheme(Brightness.dark),
    locale: const Locale('tr', 'TR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    routerConfig: _router,
  );
}
