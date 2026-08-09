import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_nbt/apis/providers/auth/signin_provider.dart';
import 'package:project_nbt/ui/components/bottom_sheets/otp_bottom_sheet.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/authentication/registration/registration_page.dart';
import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../forgot_password/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  String _countryCode = "+91";

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  Timer? _timer;
  int _start = 60;
  late final signInProvider = context.read<SignInProvider>();

  @override
  void dispose() {
    signInProvider.mobileNumberController.dispose();
    signInProvider.passwordController.dispose();
    super.dispose();
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
                  color: Colors.black.withOpacity(0.1),
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
    // Check for repetitive digits (e.g., 0000000000, 1111111111)
    if (RegExp(r'^(\d)\1{9}$').hasMatch(phone)) return true;
    // Check for sequential digits (e.g., 1234567890, 0123456789)
    const sequential = "01234567890123456789";
    const reversedSequential = "98765432109876543210";
    if (sequential.contains(phone) || reversedSequential.contains(phone))
      return true;
    return false;
  }

  Future<void> _validateAndSignIn() async {
    FocusScope.of(context).unfocus();
    final signInProvider = context.read<SignInProvider>();
    final mobile = signInProvider.mobileNumberController.text;
    final password = signInProvider.passwordController.text;
    if (mobile.isEmpty || mobile.length < 10) {
      _showErrorNotification(
        "Login Unsuccessful",
        "Please enter a valid 10-digit mobile number.",
      );
      return;
    }

    if (_isGenericNumber(mobile)) {
      _showErrorNotification(
        "Login Unsuccessful",
        "Oops, that number looks fake. Please use a valid one.",
      );
      return;
    }

    if (password.isEmpty) {
      _showErrorNotification(
        "Login Unsuccessful",
        "Please enter your password.",
      );
      return;
    }
    final success = await signInProvider.signInSendOtp(mobile, password);

    if (success) {
      _showOtpVerification(mobile, _countryCode);
    } else {
      _showErrorNotification(
        "Login Failed",
        signInProvider.errorMessage ?? "Could not send OTP. Please try again.",
      );
    }

    // _showOtpVerification();
  }

  void _showOtpVerification(String mobile, String countryCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<SignInProvider>(
        builder: (context, signInProvider, child) {
          return OtpBottomSheet(
            mobileNumber: mobile,
            countryCode: countryCode,
            isLoading: signInProvider.isLoading,
            onResend: () async {
              return await signInProvider.signInSendOtp(
                mobile,
                signInProvider.passwordController.text,
              );
            },
            onVerify: (pin) async {
              final response = await signInProvider.verifySignInOtp(
                pin,
                mobile,
              );
              if (response != null && response.success) {
                if (mounted) {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomNavigationBar(),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  _showErrorNotification(
                    "Oops, Wrong Code",
                    signInProvider.errorMessage ??
                        "That code ain't it. Try again!",
                  );
                }
              }
            },
          );
        },
        // child: OtpBottomSheet(
        //   mobileNumber: mobile,
        //   countryCode: _countryCode,
        //   onResend: () async {
        //     // Logic for resending OTP
        //     return true;
        //   },
        //   onVerify: (pin) {
        //     if (pin == "1234") {
        //       Navigator.pop(context);
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const CustomNavigationBar(),
        //         ),
        //       );
        //     } else {
        //       _showErrorNotification(
        //         "Oops, Wrong Code",
        //         "That code ain't it. Try again!",
        //       );
        //     }
        //   },
        // ),
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
          child: Consumer<SignInProvider>(
            builder: (context, signInProvider, child) {
              return Stack(
                children: [
                  // Container(
                  //   color: theme.surface.withOpacity(0.9),
                  //   height: double.infinity,
                  //   width: double.infinity,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Look",
                        style: GoogleFonts.gorditas(
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          color: theme.primary,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        "Who's Back!",
                        style: GoogleFonts.gorditas(
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          color: theme.tertiary,
                          height: 1.1,
                        ),
                      ),
                      // const SizedBox(height: 8),
                      Text(
                        "Your space missed you. Your homies probably did too",
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
                        controller: signInProvider.mobileNumberController,
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
                            borderSide: BorderSide(
                              color: theme.primary,
                              width: 2,
                            ),
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
                            suffixIcon: Icon(
                              Icons.search,
                              color: theme.primary,
                            ),
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
                        controller: signInProvider.passwordController,
                        obscureText: _obscurePassword,
                        hintText: "Enter password",
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(
                                  initialMobileNumber: signInProvider
                                      .mobileNumberController
                                      .text,
                                  initialCountryCode: _countryCode.replaceAll(
                                    '+',
                                    '',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "forgot password?",
                            style: GoogleFonts.k2d(
                              color: theme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Sign In Button
                      PrimaryButton(
                        text: "Sign In",
                        isLoading: signInProvider.isLoading,
                        onPressed: _validateAndSignIn,
                      ),

                      const SizedBox(height: 20),
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
                                builder: (context) => const RegistrationPage(),
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
                                const TextSpan(text: "Not have an account? "),
                                TextSpan(
                                  text: "Sign up",
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
