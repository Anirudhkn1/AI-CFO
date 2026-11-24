import 'package:flutter/material.dart';

import 'app/app_shell.dart';
import 'core/app_theme.dart';
import 'landing/landing_page.dart';

void main() => runApp(const AiCfoApp());

class AiCfoApp extends StatelessWidget {
  const AiCfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obsid-finance',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const LandingPage(),
        '/app': (_) => const AppShell(),
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const LandingPage()),
    );
  }
}
