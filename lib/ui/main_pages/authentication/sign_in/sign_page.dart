import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';

import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/authentication/registration/registration_page.dart';
import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';

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

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(StateSetter setModalState) {
    _timer?.cancel();
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setModalState(() {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
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

  void _validateAndSignIn() {
    FocusScope.of(context).unfocus();
    final mobile = _mobileController.text;
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

    if (_passwordController.text.isEmpty) {
      _showErrorNotification(
        "Login Unsuccessful",
        "Please enter your password.",
      );
      return;
    }

    _showOtpVerification();
  }

  void _showOtpVerification() {
    final theme = Theme.of(context).colorScheme;
    _otpController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "OTP sent to $_countryCode${_mobileController.text}",
          style: GoogleFonts.k2d(),
        ),
        backgroundColor: theme.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          if (_timer == null || !_timer!.isActive) {
            _startTimer(setModalState);
          }
          return Container(
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 32,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick Number Check",
                  style: GoogleFonts.k2d(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.k2d(
                      fontSize: 14,
                      color: theme.tertiary,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: "Code sent to "),
                      TextSpan(
                        text: "$_countryCode${_mobileController.text}",
                        style: GoogleFonts.k2d(
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                      const TextSpan(text: " Drop it here to keep going"),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // OTP Input Row
                // Stack(
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: List.generate(4, (index) {
                //         String char = "";
                //         if (_otpController.text.length > index) {
                //           char = _otpController.text[index];
                //         }
                //         return Container(
                //           width: 64,
                //           height: 64,
                //           decoration: BoxDecoration(
                //             color: theme.surfaceContainerHighest,
                //             borderRadius: BorderRadius.circular(12),
                //             border: _otpController.text.length == index
                //                 ? Border.all(color: theme.primary, width: 2)
                //                 : null,
                //           ),
                //           child: Center(
                //             child: Text(
                //               char,
                //               style: GoogleFonts.k2d(
                //                 fontSize: 24,
                //                 fontWeight: FontWeight.bold,
                //                 color: theme.onSurface,
                //               ),
                //             ),
                //           ),
                //         );
                //       }),
                //     ),
                //     Opacity(
                //       opacity: 0,
                //       child: TextField(
                //         controller: _otpController,
                //         keyboardType: TextInputType.number,
                //         maxLength: 4,
                //         autofocus: true,
                //         onChanged: (value) {
                //           setModalState(() {});
                //         },
                //         decoration: const InputDecoration(counterText: ""),
                //       ),
                //     ),
                //   ],
                // ),
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 4,
                    autofocus: true,
                    keyboardType: TextInputType.number,

                    defaultPinTheme: PinTheme(
                      width: 64,
                      height: 64,
                      textStyle: GoogleFonts.k2d(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.inversePrimary,
                      ),
                      decoration: BoxDecoration(
                        color: theme.onInverseSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    focusedPinTheme: PinTheme(
                      width: 64,
                      height: 64,
                      textStyle: GoogleFonts.k2d(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.inversePrimary,
                      ),
                      decoration: BoxDecoration(
                        color: theme.onInverseSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.primary, width: 2),
                      ),
                    ),

                    submittedPinTheme: PinTheme(
                      width: 64,
                      height: 64,
                      textStyle: GoogleFonts.k2d(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.inversePrimary,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    errorPinTheme: PinTheme(
                      width: 64,
                      height: 64,
                      textStyle: GoogleFonts.k2d(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.error,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.error, width: 2),
                      ),
                    ),

                    onCompleted: (pin) {
                      debugPrint(pin);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: _start == 0
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "OTP resent successfully",
                                  style: GoogleFonts.k2d(),
                                ),
                                backgroundColor: theme.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            _startTimer(setModalState);
                          }
                        : null,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.k2d(
                          fontSize: 14,
                          color: theme.tertiary,
                        ),
                        children: [
                          const TextSpan(text: "Didn't receive code? "),
                          TextSpan(
                            text: "Resend",
                            style: GoogleFonts.k2d(
                              fontWeight: FontWeight.bold,
                              color: _start == 0
                                  ? theme.primary
                                  : theme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: theme.outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(_start),
                      style: GoogleFonts.k2d(
                        fontSize: 14,
                        color: theme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_otpController.text == "1234") {
                        _timer?.cancel();
                        _timer = null;
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomNavigationBar(),
                          ),
                        );
                      } else {
                        _showErrorNotification(
                          "Oops, Wrong Code",
                          "That code ain't it. Try again!",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: theme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "That's Me",
                      style: GoogleFonts.k2d(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      _timer?.cancel();
      _timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Looks",
                style: GoogleFonts.k2d(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                  height: 1.1,
                ),
              ),
              Text(
                "Who's Back!",
                style: GoogleFonts.k2d(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.tertiary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your space missed you. Your homies probably did too ✨",
                style: GoogleFonts.k2d(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.tertiary,
                ),
              ),
              const SizedBox(height: 40),

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
                controller: _mobileController,
                initialCountryCode: 'IN',
                showCountryFlag: true,
                cursorColor: theme.primary,
                showDropdownIcon: true,
                dropdownIcon: Icon(Icons.arrow_drop_down, color: theme.primary),
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
                controller: _passwordController,
                obscureText: _obscurePassword,
                hintText: "Enter password",
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
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "forgot password?",
                  style: GoogleFonts.k2d(
                    color: theme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sign In Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: ElevatedButton(
              //     onPressed: _validateAndSignIn,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: theme.primary,
              //       foregroundColor: theme.onPrimary,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //     child: Text(
              //       "Sign In", // Image shows "Sign Up" even for welcome back
              //       style: GoogleFonts.k2d(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              PrimaryButton(text: "Sign In", onPressed: _validateAndSignIn),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Or Continue With",
                  style: GoogleFonts.k2d(color: theme.tertiary, fontSize: 14),
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
        ),
      ),
    );
  }
}
