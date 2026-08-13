import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? counterText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType keyBoardType;
  final EdgeInsets? edgeInsets;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final int? maxLine;
  final bool readOnly;
  final TextAlign textAlign;
  final Color? backGroundColor;
  final double? fontSize;
  final int? maxLength;
  final bool allowSpecialCharacters;
  final bool allowTextOnly;
  final bool allowNumbersOnly;
  final bool obscureText;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? errorText;
  final FocusNode? focusNode;

  const PrimaryTextField({
    super.key,
    this.labelText,
    this.counterText,
    this.inputFormatters,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.textInputAction,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.prefixText,
    this.maxLine = 1,
    this.maxLength,
    this.backGroundColor,
    this.fontSize,
    this.controller,
    this.allowSpecialCharacters = true,
    this.allowTextOnly = false,
    this.allowNumbersOnly = false,
    this.obscureText = false,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.style,
    this.hintStyle,
    this.errorText,
    this.focusNode,
    this.keyBoardType = TextInputType.text,
    this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    TextInputFormatter typeFilter = FilteringTextInputFormatter.allow(
      RegExp('.*'),
    );

    if (allowTextOnly) {
      typeFilter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
    } else if (allowNumbersOnly) {
      typeFilter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
    }

    final specialCharacterFilter = FilteringTextInputFormatter.allow(
      RegExp(allowSpecialCharacters ? '.*' : r'[a-zA-Z0-9\s]'),
    );

    final effectiveInputFormatters = [
      typeFilter,
      if (!allowSpecialCharacters) specialCharacterFilter,
      ...?inputFormatters,
    ];

    final colors = Theme.of(context).colorScheme;

    OutlineInputBorder buildBorder(Color color, {double width = 1.5}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final theme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      cursorColor: colors.primary,
      cursorWidth: 1.5,
      readOnly: readOnly,
      obscureText: obscureText,
      inputFormatters: effectiveInputFormatters,
      keyboardType: keyBoardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style:
          style ??
          GoogleFonts.k2d(
            fontWeight: FontWeight.w500,
            color: colors.inversePrimary,
          ),
      maxLines: maxLine,
      maxLength: maxLength,
      textAlign: textAlign,
      decoration: InputDecoration(
        filled: true,
        fillColor: backGroundColor ?? theme.onInverseSurface,

        contentPadding:
            edgeInsets ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        prefixIcon: prefixIcon,

        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: suffixIcon,
              )
            : null,

        hintStyle:
            hintStyle ??
            GoogleFonts.k2d(
              fontSize: fontSize ?? 15,
              fontWeight: FontWeight.w500,
              color: colors.tertiary,
            ),

        labelStyle: GoogleFonts.k2d(color: colors.tertiary),

        errorText: errorText,

        border: border ?? buildBorder(Colors.transparent),

        enabledBorder: enabledBorder ?? buildBorder(Colors.transparent),

        focusedBorder: focusedBorder ?? buildBorder(colors.primary, width: 2),

        errorBorder: buildBorder(colors.error, width: 1.5),

        focusedErrorBorder: buildBorder(colors.error, width: 2),

        counterText: counterText,
      ),
    );
  }
}
