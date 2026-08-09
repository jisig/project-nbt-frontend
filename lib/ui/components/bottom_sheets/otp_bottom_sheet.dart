import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';

class OtpBottomSheet extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;
  final bool isLoading;
  final Future<bool> Function() onResend;
  final Function(String) onVerify;

  const OtpBottomSheet({
    super.key,
    required this.mobileNumber,
    required this.countryCode,
    this.isLoading = false,
    required this.onResend,
    required this.onVerify,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _start = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_start == 0) {
            timer.cancel();
          } else {
            _start--;
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                  text: "${widget.countryCode}${widget.mobileNumber}",
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
                widget.onVerify(pin);
              },
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: _start == 0
                  ? () async {
                      final success = await widget.onResend();
                      if (success) {
                        _startTimer();
                      }
                    }
                  : null,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.k2d(fontSize: 14, color: theme.tertiary),
                  children: [
                    const TextSpan(text: "Didn't receive code? "),
                    TextSpan(
                      text: "Resend",
                      style: GoogleFonts.k2d(
                        fontWeight: FontWeight.bold,
                        color: _start == 0 ? theme.primary : theme.tertiary,
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
              Icon(Icons.access_time_rounded, size: 20, color: theme.outline),
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
          PrimaryButton(
            text: "That's Me",
            isLoading: widget.isLoading,
            onPressed: () {
              widget.onVerify(_otpController.text);
            },
          ),
        ],
      ),
    );
  }
}
