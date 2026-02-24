import 'package:birdify/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // dotenv reads from the asset bundle — requires a full restart after changes.
  await dotenv.load(fileName: '.env');
  runApp(const BirdifyApp());
}

class BirdifyApp extends StatelessWidget {
  const BirdifyApp({super.key});

  static const _seed = Color(0xFF52B788);

  static final _light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F9F6),
  );

  static final _dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1614),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Birdify',
        themeMode: mode,
        theme: _light,
        darkTheme: _dark,
        home: const HomePage(),
      ),
    );
  }
}
