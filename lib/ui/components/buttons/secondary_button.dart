import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? weight;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.height,
    this.weight,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: height ?? 60,
        width: weight ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          border: Border.all(
            color: borderColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.k2d(
              color: textColor ?? Theme.of(context).colorScheme.surface,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
