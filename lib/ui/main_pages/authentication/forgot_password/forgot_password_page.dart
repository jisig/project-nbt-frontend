import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_nbt/apis/providers/auth/forgot_password_provider.dart';
import 'package:project_nbt/ui/components/bottom_sheets/otp_bottom_sheet.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/main_pages/authentication/forgot_password/set_new_password_page.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? initialMobileNumber;
  final String? initialCountryCode;

  const ForgotPasswordPage({
    super.key,
    this.initialMobileNumber,
    this.initialCountryCode,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // late final TextEditingController _mobileController;
  String? _errorText;
  late String _countryCode;
  late final forgotPasswordProvider = context.read<ForgotPasswordProvider>();

  @override
  void initState() {
    super.initState();
    forgotPasswordProvider.mobileNumberController = TextEditingController(
      text: widget.initialMobileNumber,
    );
    _countryCode = widget.initialCountryCode ?? '91';
  }

  @override
  void dispose() {
    forgotPasswordProvider.mobileNumberController.dispose();
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
    // Check for repetitive digits (e.g., 0000000000, 1111111111)
    if (RegExp(r'^(\d)\1{9}$').hasMatch(phone)) return true;
    // Check for sequential digits (e.g., 1234567890, 0123456789)
    const sequential = "01234567890123456789";
    const reversedSequential = "98765432109876543210";
    if (sequential.contains(phone) || reversedSequential.contains(phone))
      return true;
    return false;
  }

  // Future<void> _forgotPasswordValidate() async {
  //   FocusScope.of(context).unfocus();
  //   final forgotPasswordProvider = context.read<ForgotPasswordProvider>();
  //   final mobile = forgotPasswordProvider.mobileNumberController.text;
  //   if (mobile.isEmpty || mobile.length < 10) {
  //     _showErrorNotification(
  //       "Login Unsuccessful",
  //       "Please enter a valid 10-digit mobile number.",
  //     );
  //     return;
  //   }
  //
  //   if (_isGenericNumber(mobile)) {
  //     _showErrorNotification(
  //       "Login Unsuccessful",
  //       "Oops, that number looks fake. Please use a valid one.",
  //     );
  //     return;
  //   }
  //
  //   final success = await forgotPasswordProvider.forgotPasswordSendOtp(mobile);
  //
  //   if (success) {
  //     _showOtpVerification(mobile, _countryCode);
  //   } else {
  //     _showErrorNotification(
  //       "Login Failed",
  //       forgotPasswordProvider.errorMessage ??
  //           "Could not send OTP. Please try again.",
  //     );
  //   }
  //
  //   // _showOtpVerification();
  // }

  Future<void> _forgotPasswordValidate() async {
    FocusScope.of(context).unfocus();

    final forgotPasswordProvider = context.read<ForgotPasswordProvider>();

    final mobile = forgotPasswordProvider.mobileNumberController.text.trim();

    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      _showErrorNotification(
        "Invalid Mobile Number",
        "Please enter a valid 10-digit mobile number.",
      );
      return;
    }

    if (_isGenericNumber(mobile)) {
      _showErrorNotification(
        "Invalid Mobile Number",
        "Please enter a valid mobile number.",
      );
      return;
    }

    final success = await forgotPasswordProvider.forgotPasswordSendOtp(mobile);

    if (success) {
      _showOtpVerification(mobile, _countryCode);
    } else {
      _showErrorNotification(
        "OTP Failed",
        forgotPasswordProvider.errorMessage ??
            "Could not send OTP. Please try again.",
      );
    }
  }

  void _showOtpVerification(String mobile, String countryCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ForgotPasswordProvider>(
        builder: (context, forgotPasswordProvider, child) {
          return OtpBottomSheet(
            mobileNumber: mobile,
            countryCode: countryCode,
            isLoading: forgotPasswordProvider.isLoading,
            onResend: () async {
              return await forgotPasswordProvider.forgotPasswordSendOtp(mobile);
            },
            onVerify: (pin) async {
              final response = await forgotPasswordProvider
                  .verifyForgotPasswordOtp(pin, mobile);
              if (response != null && response.success) {
                if (mounted) {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetNewPasswordPage(),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  _showErrorNotification(
                    "Oops, Wrong Code",
                    forgotPasswordProvider.errorMessage ??
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Consumer<ForgotPasswordProvider>(
            builder: (context, forgotPasswordProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Forgot",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.primary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "Password!",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.tertiary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Text(
                  //   'Don\'t worry! It happens. Please enter the mobile number associated with your account.',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: theme.onSecondary,
                  //     height: 1.4,
                  //   ),
                  // ),
                  Text(
                    "Your space missed you. Your homies probably did too",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Mobile Input Label
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
                    controller: forgotPasswordProvider.mobileNumberController,
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
                  if (_errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        _errorText!,
                        style: TextStyle(color: theme.error, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 48),

                  // Send Code Button
                  PrimaryButton(
                    text: "Send Otp",
                    isLoading: forgotPasswordProvider.isLoading,
                    onPressed: _forgotPasswordValidate,
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
