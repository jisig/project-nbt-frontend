import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_nbt/apis/providers/auth/forgot_password_provider.dart';
import 'package:project_nbt/apis/providers/auth/register_provider.dart';
import 'package:project_nbt/apis/providers/auth/signin_provider.dart';
import 'package:project_nbt/ui/main_pages/splash_screen/splash_screen.dart';
import 'package:project_nbt/ui/theme/light_theme.dart';
import 'package:project_nbt/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationSendOtpProvider()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
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
