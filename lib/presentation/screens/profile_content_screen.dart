// profile_content_screen.dart
import 'package:flutter/material.dart';
import '../../appconstants.dart';

class ProfileContentScreen extends StatelessWidget {
  const ProfileContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Perfil',
        style: TextStyle(fontSize: 24, color: AppConstants.colorText),
      ),
    );
  }
}
