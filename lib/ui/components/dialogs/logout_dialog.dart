import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          // Info Icon
          Icon(Icons.info_outline_rounded, color: theme.error, size: 40),
          const SizedBox(height: 10),
          // Title
          Text(
            "Logout Account",
            style: GoogleFonts.k2d(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Are you sure you want to logout “Account”?",
              textAlign: TextAlign.center,
              style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 20),
          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EBED),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      "No, Keep Logged In",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.k2d(
                        color: const Color(0xFF7A8D99),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Handle Logout Logic
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.error,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Yes, Proceed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.k2d(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
