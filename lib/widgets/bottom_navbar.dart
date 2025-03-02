// lib/widgets/bottomnavbar.dart
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/navigation_provider.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  static const _kPages = <String, IconData>{
    'Create': Icons.add_circle_outline,
    'Explore': Icons.explore,
    'Profile': Icons.person,
    'Challenges': Icons.flag,
    'Progress': Icons.show_chart,
  };

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return ConvexAppBar.badge(
      const <int, dynamic>{3: ''},
      style: TabStyle.reactCircle,
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: <TabItem>[
        for (final entry in _kPages.entries)
          TabItem(icon: entry.value, title: entry.key),
      ],
      initialActiveIndex: navigationProvider.currentIndex,
      onTap: (int i) => navigationProvider.setIndex(i),
    );
  }
}
