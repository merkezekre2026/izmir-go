import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/ui/favorites/favorites_screen.dart';
import 'package:izmir_go/ui/journey_detail/journey_detail_screen.dart';
import 'package:izmir_go/ui/journey_results/journey_results_screen.dart';
import 'package:izmir_go/ui/journey_search/journey_search_screen.dart';
import 'package:izmir_go/ui/journey_search/journey_search_view_model.dart';
import 'package:izmir_go/ui/line_detail/line_detail_screen.dart';
import 'package:izmir_go/ui/lines/lines_screen.dart';
import 'package:izmir_go/ui/nearby/nearby_screen.dart';
import 'package:izmir_go/ui/place_picker/map_pick_screen.dart';
import 'package:izmir_go/ui/place_picker/place_picker_screen.dart';
import 'package:izmir_go/ui/settings/data_sources_screen.dart';
import 'package:izmir_go/ui/settings/settings_screen.dart';
import 'package:izmir_go/ui/shell/app_shell.dart';
import 'package:izmir_go/ui/stop_detail/stop_detail_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Deep links: izmirgo://stop/{id}, izmirgo://line/{id} map onto /stop/:id and /line/:id.
GoRouter buildRouter({String initialLocation = '/'}) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: initialLocation,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (_, _) => const JourneySearchScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/nearby', builder: (_, _) => const NearbyScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/lines', builder: (_, _) => const LinesScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/saved', builder: (_, _) => const FavoritesScreen())],
        ),
      ],
    ),
    GoRoute(
      path: '/place-picker',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, state) => MaterialPage(
        fullscreenDialog: true,
        child: PlacePickerScreen(isOrigin: state.uri.queryParameters['field'] != 'destination'),
      ),
    ),
    GoRoute(
      path: '/map-pick',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, _) => const MapPickScreen(),
    ),
    GoRoute(
      path: '/results',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => JourneyResultsScreen(query: state.extra! as JourneyQuery),
    ),
    GoRoute(
      path: '/journey/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => JourneyDetailScreen(
        journeyId: state.pathParameters['id']!,
        journey: state.extra is Journey ? state.extra! as Journey : null,
      ),
    ),
    GoRoute(
      path: '/stop/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => StopDetailScreen(stopId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/line/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => LineDetailScreen(routeId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, _) => const SettingsScreen(),
      routes: [GoRoute(path: 'sources', builder: (_, _) => const DataSourcesScreen())],
    ),
  ],
);
