// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Asegura que el binding está inicializado antes de llamar a funciones asíncronas
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI
  //TODO: Esto solo para usar en WIN o LINUX, BORRAR PARA ANDROID
  sqfliteFfiInit();
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  // Obtén y muestra la ruta de la base de datos para depuración
  //final dbPath = await getDatabasesPath();
  //print('Database path: $dbPath');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'GOW_V3',
          theme: themeProvider.themeData,
          home:
              themeProvider.selectedTheme == null
                  ? const SplashScreen()
                  : const ProfileScreen(),
        );
      },
    );
  }
}
