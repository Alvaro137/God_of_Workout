// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/bottom_navbar.dart';
import '../providers/navigation_provider.dart';
import 'create_screen.dart';
import 'explore_screen.dart';
import 'challenges_screen.dart';
import 'progress_screen.dart';
import 'profile_content_screen.dart'; // nuevo widget

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: const [
          CreateScreen(),
          ExploreScreen(),
          ProfileContentScreen(),
          ChallengesScreen(),
          ProgressScreen(),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
