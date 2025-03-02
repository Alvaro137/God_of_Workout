// presentation/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../appconstants.dart';

enum AppTheme { hefestus, hercules, hermes }

class ThemeProvider with ChangeNotifier {
  AppTheme? _selectedTheme;

  AppTheme? get selectedTheme => _selectedTheme;

  // Constructor: se carga la preferencia almacenada
  ThemeProvider() {
    _loadTheme();
  }

  // Método para cargar la preferencia almacenada
  Future<void> _loadTheme() async {
    print("Llamada a loadtheme");
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('selected_theme');
    if (themeStr != null) {
      if (themeStr.contains('hefestus')) {
        _selectedTheme = AppTheme.hefestus;
      } else if (themeStr.contains('hercules')) {
        _selectedTheme = AppTheme.hercules;
      } else if (themeStr.contains('hermes')) {
        _selectedTheme = AppTheme.hermes;
      }
      notifyListeners();
    }
  }

  // Al cambiar el tema, se persiste la elección
  Future<void> setTheme(AppTheme theme) async {
    _selectedTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', theme.toString());
  }

  ThemeData get themeData {
    final theme = _selectedTheme ?? AppTheme.hefestus;
    ThemeData baseTheme;

    switch (theme) {
      case AppTheme.hefestus:
        baseTheme = ThemeData.from(
          colorScheme: ColorScheme.dark(
            primary: AppConstants.colorHefesto,
            secondary: AppConstants.colorHefestoBackground,
            surface: AppConstants.colorBackgroundLighter,
            onPrimary: AppConstants.colorText,
            onSecondary: AppConstants.colorText,
            onSurface: AppConstants.colorText,
          ),
        );
        break;
      case AppTheme.hercules:
        baseTheme = ThemeData.from(
          colorScheme: ColorScheme.dark(
            primary: AppConstants.colorHercules,
            secondary: AppConstants.colorHerculesBackground,
            surface: AppConstants.colorBackgroundLighter,
            onPrimary: AppConstants.colorText,
            onSecondary: AppConstants.colorText,
            onSurface: AppConstants.colorText,
          ),
        );
        break;
      case AppTheme.hermes:
        baseTheme = ThemeData.from(
          colorScheme: ColorScheme.dark(
            primary: AppConstants.colorHermes,
            secondary: AppConstants.colorHermesBackground,
            surface: AppConstants.colorBackgroundLighter,
            onPrimary: AppConstants.colorText,
            onSecondary: AppConstants.colorText,
            onSurface: AppConstants.colorText,
          ),
        );
        break;
    }

    // Aquí defines el TabBarTheme usando los colores del ColorScheme
    return baseTheme.copyWith(
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        labelColor: baseTheme.colorScheme.onPrimary,
        unselectedLabelColor: baseTheme.colorScheme.onPrimary,
        indicatorColor: baseTheme.colorScheme.onPrimary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ), // Negrita en la seleccionada
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ), // Normal en las no seleccionadas
      ),
    );
  }
}
