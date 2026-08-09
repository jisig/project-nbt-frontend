// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:project_nbt/apis/providers/auth/signin_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';
// import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(const Duration(seconds: 3), () {
//       if (mounted) {
//         _checkLogin();
//       }
//     });
//   }
//
//   Future<void> _checkLogin() async {
//     final signInProvider = context.read<SignInProvider>();
//     final isLoggedIn = await signInProvider.checkAuthStatus();
//
//     if (!mounted) return;
//
//     if (isLoggedIn) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const CustomNavigationBar()),
//       );
//     } else {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF050714),
//       body: SizedBox.expand(
//         child: Image.asset(
//           'lib/assets/splash_screen/splash_screen_image.png',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_nbt/apis/providers/auth/signin_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Show splash for a fixed 3 seconds, then decide where to go.
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _checkLogin();
      }
    });
  }

  Future<void> _checkLogin() async {
    final signInProvider = context.read<SignInProvider>();

    // checkAuthStatus() reads accessToken/refreshToken from
    // SharedPreferences AND, if a valid session is found, also loads
    // the saved user info into signInProvider.currentUser as a side
    // effect — so by the time we navigate, currentUser is ready for
    // the home screen to read immediately.
    final isLoggedIn = await signInProvider.checkAuthStatus();

    if (kDebugMode) {
      debugPrint('SPLASH — isLoggedIn: $isLoggedIn');
      debugPrint(
        'SPLASH — currentUser after check: '
        '${signInProvider.currentUser?.mobileNumber}',
      );
    }

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomNavigationBar()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050714),
      body: SizedBox.expand(
        child: Image.asset(
          'lib/assets/splash_screen/splash_screen_image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
