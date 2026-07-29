import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryTextFelid extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final Color? filledColor;
  final EdgeInsets edgeInsets;
  final ValueChanged? onSubmitted;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final int? maxLine;

  const SecondaryTextFelid({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.filledColor,
    this.onSubmitted,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.maxLine,
    required this.controller,
    required this.keyBoardType,
    required this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder buildBorder(Color color, {double width = 1.5}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      cursorWidth: 1,
      keyboardType: keyBoardType,
      onSubmitted: onSubmitted,
      style: GoogleFonts.fredoka(
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      maxLines: maxLine,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            filledColor ?? Theme.of(context).colorScheme.onInverseSurface,
        contentPadding: edgeInsets,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        labelStyle: labelText != null
            ? TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
            : null,

        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        // ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Theme.of(context).colorScheme.inversePrimary,
        //   ),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Theme.of(context).colorScheme.inversePrimary,
        //   ),
        // ),
        border: border ?? buildBorder(Colors.transparent),

        enabledBorder: enabledBorder ?? buildBorder(Colors.transparent),

        focusedBorder: focusedBorder ?? buildBorder(colors.primary, width: 2),

        errorBorder: buildBorder(colors.error, width: 1.5),

        focusedErrorBorder: buildBorder(colors.error, width: 2),
      ),
    );
  }
}
