import 'package:birdify/bloc/chatbloc_bloc.dart';
import 'package:birdify/pages/about_page.dart';
import 'package:birdify/pages/chat_page.dart';
import 'package:birdify/pages/home_page.dart';
import 'package:birdify/pages/learn_page.dart';
import 'package:birdify/pages/observations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        scrollBehavior: const _NoStretchScrollBehavior(),
        home: BlocProvider(
          create: (_) => ChatblocBloc(),
          child: const MainShell(),
        ),
      ),
    );
  }
}

/// Replaces the platform-default scroll physics with [ClampingScrollPhysics]
/// so scroll views never stretch/warp on overscroll (iOS rubber-band effect).
class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

// ── Main Navigation Shell ─────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    HomePage(),
    ChatPage(),
    ObservationsPage(),
    LearnPage(),
    AboutPage(),
  ];

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search_rounded),
      label: 'Identify',
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_bubble_outline_rounded),
      selectedIcon: Icon(Icons.chat_bubble_rounded),
      label: 'Bird Expert',
    ),
    NavigationDestination(
      icon: Icon(Icons.bookmarks_outlined),
      selectedIcon: Icon(Icons.bookmarks_rounded),
      label: 'Observations',
    ),
    NavigationDestination(
      icon: Icon(Icons.auto_stories_outlined),
      selectedIcon: Icon(Icons.auto_stories_rounded),
      label: 'Learn',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'About',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: cs.primary.withValues(alpha: 0.15),
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _destinations,
      ),
    );
  }
}

