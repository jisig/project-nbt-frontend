import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/one_time_pages/all_set_pages.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final FocusNode _interestFocusNode = FocusNode();

  final List<String> _interests = [];
  String? _selectedPronoun;
  final List<String> _pronouns = ['He/Him', 'She/Her', 'They/Them', 'Other'];

  @override
  void initState() {
    super.initState();
    // Initialize focus node key handler
    _interestFocusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          _interestController.text.isEmpty &&
          _interests.isNotEmpty) {
        _removeInterest(_interests.length - 1);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };

    // Show success notification after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessNotification(context);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _interestController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _interestFocusNode.dispose();
    super.dispose();
  }

  void _addInterest(String interest) {
    if (interest.trim().isNotEmpty && !_interests.contains(interest.trim())) {
      setState(() {
        _interests.add(interest.trim());
        _interestController.clear();
      });
      // Use microtask to avoid race conditions with system context menu
      Future.microtask(() {
        if (mounted) {
          _interestFocusNode.requestFocus();
        }
      });
    }
  }

  void _removeInterest(int index) {
    setState(() {
      _interests.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2012),
      firstDate: DateTime(1900),
      lastDate: DateTime(2012, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();
        _dobController.text = "$day/$month/$year";
      });
    }
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

  bool _isGenericNumber(String text) {
    // Only check if the text looks like a 10-digit number
    final clean = text.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 10) return false;

    // Check for repetitive digits (e.g., 0000000000)
    if (RegExp(r'^(\d)\1{9}$').hasMatch(clean)) return true;
    // Check for sequential digits
    const sequential = "01234567890123456789";
    const reversedSequential = "98765432109876543210";
    if (sequential.contains(clean) || reversedSequential.contains(clean))
      return true;
    return false;
  }

  void _validateAndProceed() {
    final username = _usernameController.text.trim();
    final displayName = _displayNameController.text.trim();

    if (username.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Please choose a unique username.",
      );
      return;
    }
    if (_isGenericNumber(username)) {
      _showErrorNotification(
        "Profile Setup",
        "Username cannot be a generic phone number.",
      );
      return;
    }

    if (displayName.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Please enter your display name.",
      );
      return;
    }
    if (_isGenericNumber(displayName)) {
      _showErrorNotification(
        "Profile Setup",
        "Display name cannot be a generic phone number.",
      );
      return;
    }

    if (_interests.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Add at least one interest or vibe.",
      );
      return;
    }
    if (_selectedPronoun == null) {
      _showErrorNotification("Profile Setup", "Please select your pronouns.");
      return;
    }
    if (_dobController.text.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Please enter your date of birth.",
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllSetPage()),
    );
  }

  void _showSuccessNotification(BuildContext context) {
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
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
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
                        "Registration Successful",
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Your account is registered successfully.",
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Create",
                style: GoogleFonts.k2d(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.secondary,
                  height: 1.1,
                ),
              ),
              Text(
                "Profile!",
                style: GoogleFonts.k2d(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: theme.outline,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Set Up Your Profile for Delicious Deliveries!",
                style: GoogleFonts.k2d(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.tertiary,
                ),
              ),
              const SizedBox(height: 25),

              _buildLabel("Username", theme),
              PrimaryTextField(
                controller: _usernameController,
                hintText: "Choose a unique username",
              ),
              const SizedBox(height: 20),

              _buildLabel("Display Name", theme),
              PrimaryTextField(
                controller: _displayNameController,
                hintText: "Enter the name that you want display",
              ),
              const SizedBox(height: 20),

              _buildLabel("Your Interest/Vibe", theme),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_interests.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _interests.asMap().entries.map((entry) {
                            return Chip(
                              label: Text(
                                entry.value,
                                style: GoogleFonts.k2d(
                                  fontSize: 12,
                                  color: theme.onSurface,
                                ),
                              ),
                              backgroundColor: theme.surface,
                              deleteIcon: Icon(
                                Icons.close,
                                size: 16,
                                color: theme.outline,
                              ),
                              onDeleted: () => _removeInterest(entry.key),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(4),
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    TextField(
                      controller: _interestController,
                      focusNode: _interestFocusNode,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: _interests.isEmpty
                            ? "Type to add interest"
                            : "Add more...",
                        hintStyle: GoogleFonts.k2d(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: theme.tertiary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              _addInterest(_interestController.text),
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: theme.primary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      style: GoogleFonts.k2d(
                        fontWeight: FontWeight.w500,
                        color: theme.onSurface,
                      ),
                      onSubmitted: _addInterest,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildLabel("Pronouns", theme),
              DropdownButtonFormField<String>(
                value: _selectedPronoun,
                hint: Text(
                  "Choose pronouns",
                  style: GoogleFonts.k2d(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.tertiary,
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: theme.outline),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: GoogleFonts.k2d(
                  fontWeight: FontWeight.w500,
                  color: theme.onSurface,
                ),
                items: _pronouns.map((String pronoun) {
                  return DropdownMenuItem<String>(
                    value: pronoun,
                    child: Text(pronoun),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPronoun = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildLabel("Date of Birth", theme),
              PrimaryTextField(
                controller: _dobController,
                hintText: "DD/MM/YYYY",
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),

              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: ElevatedButton(
              //     onPressed: _validateAndProceed,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: theme.primary,
              //       foregroundColor: theme.onPrimary,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //     ),
              //     child: Text(
              //       "Create Profile",
              //       style: GoogleFonts.k2d(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              PrimaryButton(
                text: "Create Profile",
                onPressed: _validateAndProceed,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.k2d(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: theme.onSurface,
        ),
      ),
    );
  }
}
