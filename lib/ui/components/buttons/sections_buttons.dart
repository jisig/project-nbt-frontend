import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionsButtons extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const SectionsButtons({
    super.key,
    required this.icon,
    required this.title,
    this.textColor,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        // borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          height: 40,
          decoration: BoxDecoration(
            color: theme.onInverseSurface,
            // borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  scale: 25,
                  color: iconColor ?? theme.inversePrimary,
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.k2d(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? theme.inversePrimary,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 25,
                  color: theme.inversePrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
