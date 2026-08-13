import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';

class NoInternetAccess extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetAccess({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon Container
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: theme.error,
                ),
              ),
              const SizedBox(height: 40),
              // Title
              Text(
                "No Internet Connection",
                textAlign: TextAlign.center,
                style: GoogleFonts.k2d(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.inversePrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                "It seems you're not connected to the internet. Please check your settings and try again.",
                textAlign: TextAlign.center,
                style: GoogleFonts.k2d(
                  fontSize: 16,
                  color: theme.tertiary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Retry Button
              PrimaryButton(
                text: "Try Again",
                onPressed: onRetry ?? () {},
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
