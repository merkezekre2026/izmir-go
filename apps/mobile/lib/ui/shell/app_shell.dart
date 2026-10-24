import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:izmir_go/ui/core/l10n.dart';

/// Bottom navigation with platform conventions: Cupertino tab bar on iOS, Material 3
/// navigation bar elsewhere. Each tab keeps its own navigation stack.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});
  final StatefulNavigationShell shell;

  void _go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.directions_outlined, Icons.directions, l.tabRoute),
      (Icons.near_me_outlined, Icons.near_me, l.tabNearby),
      (Icons.route_outlined, Icons.route, l.tabLines),
      (Icons.star_border, Icons.star, l.tabSaved),
    ];
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    return Scaffold(
      body: shell,
      bottomNavigationBar: isIos
          ? CupertinoTabBar(
              currentIndex: shell.currentIndex,
              onTap: _go,
              items: [
                for (final (icon, active, label) in items)
                  BottomNavigationBarItem(icon: Icon(icon), activeIcon: Icon(active), label: label),
              ],
            )
          : NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _go,
              destinations: [
                for (final (icon, active, label) in items)
                  NavigationDestination(icon: Icon(icon), selectedIcon: Icon(active), label: label),
              ],
            ),
    );
  }
}
