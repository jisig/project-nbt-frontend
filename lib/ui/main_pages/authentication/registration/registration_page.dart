import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_nbt/apis/providers/auth/register_provider.dart';
import 'package:project_nbt/ui/components/bottom_sheets/otp_bottom_sheet.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';
import 'package:project_nbt/ui/main_pages/one_time_pages/create_profile_page.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _countryCode = "+91";

  bool _hasMinLength(String password) => password.length >= 11;

  bool _hasNumber(String password) => password.contains(RegExp(r'[0-9]'));

  bool _hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  bool _hasCapitalLetter(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  double _passwordStrength(String password) {
    int met = 0;
    if (_hasMinLength(password)) met++;
    if (_hasNumber(password)) met++;
    if (_hasSpecialChar(password)) met++;
    if (_hasCapitalLetter(password)) met++;
    return met / 4;
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.25) return Theme.of(context).colorScheme.error;
    if (strength <= 0.5) return Colors.orange;
    if (strength <= 0.75) return Colors.yellow;
    return Theme.of(context).colorScheme.inverseSurface;
  }

  void _showErrorNotification(String title, String subtitle) {
    final theme = Theme.of(context).colorScheme;
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.outline.withOpacity(0.3),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.k2d(
                          fontSize: 12,
                          color: theme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  bool _isGenericNumber(String phone) {
    if (phone.length < 10) return false;
    if (RegExp(r'^(\d)\1{9}$').hasMatch(phone)) return true;
    const sequential = "01234567890123456789";
    const reversedSequential = "98765432109876543210";
    if (sequential.contains(phone) || reversedSequential.contains(phone)) {
      return true;
    }
    return false;
  }

  Future<void> _validateAndSignUp() async {
    FocusScope.of(context).unfocus();
    final registerOtpProvider = context.read<RegistrationSendOtpProvider>();
    final mobile = registerOtpProvider.mobileNumberController.text;
    final password = registerOtpProvider.passwordController.text;
    final confirmPassword = registerOtpProvider.confirmPasswordController.text;

    if (mobile.isEmpty || mobile.length < 10) {
      _showErrorNotification(
        "Oops, Check That Number",
        "Drop a valid 10-digit mobile number.",
      );
      return;
    }

    if (_isGenericNumber(mobile)) {
      _showErrorNotification(
        "Registration Unsuccessful",
        "Oops, that number looks fake. Please use a valid one.",
      );
      return;
    }

    if (!_hasMinLength(password) ||
        !_hasNumber(password) ||
        !_hasSpecialChar(password) ||
        !_hasCapitalLetter(password)) {
      _showErrorNotification(
        "Password's Too Weak",
        "Give it a little more power 💪",
      );
      return;
    }

    if (password != confirmPassword) {
      _showErrorNotification(
        "Passwords Don't Match",
        "Make 'em twins. Try again!",
      );
      return;
    }
    if (!_agreeToTerms) {
      _showErrorNotification(
        "One More Thing",
        "Agree to the terms to keep going.",
      );
      return;
    }

    final success = await registerOtpProvider.registerSendOtp(
      mobile,
      password,
      confirmPassword,
    );

    if (success) {
      _showOtpVerification(mobile, _countryCode);
    } else {
      _showErrorNotification(
        "Registration Failed",
        registerOtpProvider.errorMessage ??
            "Could not send OTP. Please try again.",
      );
    }
  }

  void _showOtpVerification(String mobile, String countryCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<RegistrationSendOtpProvider>(
        builder: (context, provider, child) {
          return OtpBottomSheet(
            mobileNumber: mobile,
            countryCode: countryCode,
            isLoading: provider.isLoading,
            onResend: () async {
              return await provider.registerSendOtp(
                mobile,
                provider.passwordController.text,
                provider.confirmPasswordController.text,
              );
            },
            onVerify: (pin) async {
              final response = await provider.verifyRegisterOtp(pin, mobile);
              if (response != null && response.success) {
                if (mounted) {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProfilePage(),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  _showErrorNotification(
                    "Oops, Wrong Code",
                    provider.errorMessage ?? "That code ain't it. Try again!",
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Consumer<RegistrationSendOtpProvider>(
            builder: (context, registerOtpProvider, child) {
              final strength = _passwordStrength(
                registerOtpProvider.passwordController.text,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Hey",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.primary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "You!",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.tertiary,
                      height: 1.1,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    "Your space is waiting. Let's make it yours",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mobile Field
                  Text(
                    "Mobile",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IntlPhoneField(
                    controller: registerOtpProvider.mobileNumberController,
                    disableLengthCheck: true,
                    initialCountryCode: 'IN',
                    showCountryFlag: true,
                    cursorColor: theme.primary,
                    showDropdownIcon: true,
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.primary,
                    ),
                    dropdownIconPosition: IconPosition.trailing,
                    flagsButtonPadding: const EdgeInsets.only(left: 16),
                    style: GoogleFonts.k2d(
                      fontWeight: FontWeight.w500,
                      color: theme.inversePrimary,
                    ),
                    dropdownTextStyle: GoogleFonts.k2d(
                      color: theme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter your mobile number",
                      hintStyle: GoogleFonts.k2d(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: theme.tertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.primary, width: 2),
                      ),
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    onChanged: (phone) {
                      setState(() {
                        _countryCode = phone.countryCode;
                      });
                    },
                    pickerDialogStyle: PickerDialogStyle(
                      backgroundColor: theme.surface,
                      countryNameStyle: GoogleFonts.k2d(
                        color: theme.inversePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      countryCodeStyle: GoogleFonts.k2d(
                        color: theme.inversePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      searchFieldInputDecoration: InputDecoration(
                        hintText: 'Search Country',
                        hintStyle: GoogleFonts.k2d(color: theme.tertiary),
                        suffixIcon: Icon(Icons.search, color: theme.primary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.outline.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: theme.primary),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  Text(
                    "Password",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextField(
                    controller: registerOtpProvider.passwordController,
                    obscureText: _obscurePassword,
                    hintText: "Choose password",
                    onChanged: (_) => setState(() {}),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: theme.outline,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Password Strength Indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: strength,
                      backgroundColor: theme.outline.withOpacity(0.2),
                      color: _getStrengthColor(strength),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Password must be at least 11 characters long and include a capital letter, a number, and a special character.",
                    style: GoogleFonts.k2d(fontSize: 12, color: theme.tertiary),
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Text(
                    "Confirm Password",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextField(
                    controller: registerOtpProvider.confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    hintText: "Confirm password",
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: theme.outline,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms and Conditions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(color: theme.outline, width: 1.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.k2d(
                              color: theme.tertiary,
                              fontSize: 13,
                            ),
                            children: [
                              const TextSpan(
                                text: "By singing up you agree to our ",
                              ),
                              TextSpan(
                                text: "Privacy Policy ",
                                style: GoogleFonts.k2d(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: "and "),
                              TextSpan(
                                text: "Terms of Services",
                                style: GoogleFonts.k2d(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Sign Up Button
                  PrimaryButton(
                    text: "Sign Up",
                    isLoading: registerOtpProvider.isLoading,
                    onPressed: _validateAndSignUp,
                  ),
                  Center(
                    child: Text(
                      "Or Continue With",
                      style: GoogleFonts.k2d(
                        color: theme.tertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.k2d(
                            color: theme.tertiary,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Sign In",
                              style: GoogleFonts.k2d(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
