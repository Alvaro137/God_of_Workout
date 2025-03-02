// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../appconstants.dart';
import '../providers/theme_provider.dart';
import 'profile_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _selectTheme(BuildContext context, AppTheme theme) async {
    // Actualiza el tema en el provider.
    Provider.of<ThemeProvider>(context, listen: false).setTheme(theme);
    // Persistir la elección en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', theme.toString());
    // Luego, navega al contenido principal.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Elige tu deidad',
              style: TextStyle(fontSize: 28, color: AppConstants.colorText),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorHefesto,
              ),
              onPressed: () => _selectTheme(context, AppTheme.hefestus),
              child: const Text('Hefesto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorHermes,
              ),
              onPressed: () => _selectTheme(context, AppTheme.hermes),
              child: const Text('Hermes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorHercules,
              ),
              onPressed: () => _selectTheme(context, AppTheme.hercules),
              child: const Text('Hercules'),
            ),
          ],
        ),
      ),
    );
  }
}
