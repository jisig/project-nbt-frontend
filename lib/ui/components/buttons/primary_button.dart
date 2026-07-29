import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? weight;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.text,
    this.height,
    this.weight,
    this.color,
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
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       Theme.of(context).colorScheme.inversePrimary,
          //       Theme.of(context).colorScheme.inverseSurface,
          //     ]),
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
