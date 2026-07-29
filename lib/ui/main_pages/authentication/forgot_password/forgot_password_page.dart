import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _mobileController = TextEditingController();
  String? _errorText;

  void _validate() {
    setState(() {
      final text = _mobileController.text;
      if (text.isEmpty) {
        _errorText = 'Mobile number cannot be empty';
      } else if (text.length != 10) {
        _errorText = 'Enter a valid 10-digit mobile number';
      } else {
        _errorText = null;
        // Proceed with sending code
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent!')),
        );
      }
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Forgot\nPassword?',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary.withOpacity(0.8),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Don\'t worry! It happens. Please enter the mobile number associated with your account.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),

              // Mobile Input Label
              Text(
                'Mobile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: _errorText != null
                      ? Border.all(color: colorScheme.error, width: 1)
                      : null,
                ),
                child: IntlPhoneField(
                  controller: _mobileController,
                  initialCountryCode: 'IN',
                  style: TextStyle(color: colorScheme.onPrimary),
                  dropdownTextStyle: TextStyle(color: colorScheme.onPrimary),
                  showCountryFlag: true,
                  showDropdownIcon: true,
                  dropdownIconPosition: IconPosition.trailing,
                  flagsButtonPadding: const EdgeInsets.only(left: 8),
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
                    hintStyle: TextStyle(
                      color: colorScheme.onSecondary.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  onChanged: (phone) {
                    // Handle logic if needed
                  },
                ),
              ),
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    _errorText!,
                    style: TextStyle(color: colorScheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 48),

              // Send Code Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _validate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
