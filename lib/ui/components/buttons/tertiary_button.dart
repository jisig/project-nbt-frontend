import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TertiaryButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const TertiaryButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          height: 85,
          decoration: BoxDecoration(
            color: theme.onInverseSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.tertiary),
            // boxShadow: [
            //   BoxShadow(
            //     color: theme.inversePrimary,
            //     blurRadius: 18,
            //     offset: Offset(0, 8),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.inversePrimary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: theme.onInverseSurface, size: 25),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.k2d(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.inversePrimary,
                        ),
                      ),
                      // const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          color: theme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 25,
                  color: theme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
