import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/apis/providers/auth/forgot_password_provider.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';
import 'package:provider/provider.dart';

class SetNewPasswordPage extends StatefulWidget {
  final String? initialMobileNumber;
  final String? initialCountryCode;

  const SetNewPasswordPage({
    super.key,
    this.initialMobileNumber,
    this.initialCountryCode,
  });

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  late final forgotPasswordProvider = context.read<ForgotPasswordProvider>();
  bool _obscureConfirmPassword = true;
  bool _obscurePassword = true;

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

  @override
  void initState() {
    super.initState();
    forgotPasswordProvider.mobileNumberController = TextEditingController(
      text: widget.initialMobileNumber,
    );
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
                  child: Icon(Icons.info_outline, color: theme.error, size: 28),
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

  Future<void> _setNewPasswordValidate() async {
    FocusScope.of(context).unfocus();

    final provider = context.read<ForgotPasswordProvider>();

    final password = provider.passwordController.text.trim();
    final confirmPassword = provider.confirmPasswordController.text.trim();

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

    final response = await provider.setNewPasswordForgotPassword(
      password,
      confirmPassword,
    );

    if (!mounted) return;

    if (response != null && response.success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } else {
      _showErrorNotification(
        "Password Reset Failed",
        provider.errorMessage ?? "Could not update password. Please try again.",
      );
    }
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
              final strength = _passwordStrength(
                forgotPasswordProvider.passwordController.text,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Set",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.primary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "New Password!",
                    style: GoogleFonts.gorditas(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: theme.tertiary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    "Password",
                    style: GoogleFonts.k2d(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryTextField(
                    controller: forgotPasswordProvider.passwordController,
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
                    controller:
                        forgotPasswordProvider.confirmPasswordController,
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

                  // Send Code Button
                  PrimaryButton(
                    text: "Update Password",
                    isLoading: forgotPasswordProvider.isLoading,
                    onPressed: _setNewPasswordValidate,
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
