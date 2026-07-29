import 'package:flutter/material.dart';

import 'package:project_nbt/ui/main_pages/splash_screen/splash_screen.dart';
import 'package:project_nbt/ui/theme/light_theme.dart';
import 'package:project_nbt/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
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
          theme: lightMode,
          home: const SplashScreen(),
          // darkTheme: darkMode,
          debugShowCheckedModeBanner: false,
          // home: BeamBorder(),
        );
      },
    );
  }
}