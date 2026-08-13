import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/apis/providers/profile/create_profile_provider.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/main_pages/one_time_pages/all_set_pages.dart';
import 'package:provider/provider.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class CreateProfilePage extends StatefulWidget {
  CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _interestController = TextEditingController();
  final FocusNode _interestFocusNode = FocusNode();

  final List<String> _interests = [];
  String? _selectedPronoun;
  final List<String> _pronouns = ['He/Him', 'She/Her', 'They/Them', 'Other'];

  @override
  void initState() {
    super.initState();
    // Backspace on an empty interest field removes the last chip.
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
  }

  @override
  void dispose() {
    _interestController.dispose();
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
    final createProfileProvider = context.read<CreateProfileProvider>();
    final now = DateTime.now();
    // Must be at least 13 years old — was previously hardcoded to a fixed
    // 2012 cutoff, which would have silently gone stale over time.
    final minAgeDate = DateTime(now.year - 13, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minAgeDate,
      firstDate: DateTime(1900),
      lastDate: minAgeDate,
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
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        // FIX: this used to write to a separate, unused `_dobController`
        // while the visible TextField was bound to
        // createProfileProvider.dateOfBirthController — so the picked date
        // never showed up on screen and validation always saw an empty
        // string. Now it writes to the same controller the field displays.
        createProfileProvider.dateOfBirthController.text = "$day/$month/$year";
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline, color: Colors.red, size: 28),
                ),
                SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.outline.withOpacity(0.3),
                ),
                SizedBox(width: 16),
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
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  Future<void> _validateAndProceed() async {
    final createProfileProvider = context.read<CreateProfileProvider>();

    final username = createProfileProvider.userNameController.text.trim();

    final displayName = createProfileProvider.displayNameController.text.trim();

    final dateOfBirth = createProfileProvider.dateOfBirthController.text.trim();

    if (username.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Please choose a unique username.",
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

    if (dateOfBirth.isEmpty) {
      _showErrorNotification(
        "Profile Setup",
        "Please enter your date of birth.",
      );
      return;
    }

    final success = await createProfileProvider.createProfile(
      context: context,
      username: username,
      displayName: displayName,
      fullName: 'Irfan Shaikh',
      dateOfBirth: dateOfBirth,
    );

    if (!mounted) return;

    if (success) {
      _showSuccessNotification(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllSetPage()),
      );
    } else {
      _showErrorNotification(
        "Profile Creation Failed",
        createProfileProvider.errorMessage ??
            "Could not create profile. Please try again.",
      );
    }
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.inverseSurface.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: theme.inverseSurface,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.outline.withOpacity(0.3),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Profile Created",
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.inverseSurface,
                        ),
                      ),
                      Text(
                        "Your profile is created successfully.",
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
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 24),
        child: Consumer<CreateProfileProvider>(
          builder: (context, createProfileProvider, child) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.onInverseSurface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ShapeOfView(
                        height: height * 0.2,
                        width: double.infinity,
                        elevation: 0,
                        shape: DiagonalShape(
                          direction: DiagonalDirection.Right,
                        ),
                        child: Stack(
                          children: [
                            const Image(
                              image: NetworkImage(
                                'https://api.a0.dev/assets/image?text=beautiful%20fairytale%20forest%20illustration%20with%20rainbow%20valley&aspect=16:9',
                              ),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                            Positioned(
                              right: 15,
                              top: 40,
                              child: _buildOverlayIcon(Icons.photo),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 97,
                          left: 15,
                          bottom: 5,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: theme.onInverseSurface,
                                  width: 5,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  'https://api.a0.dev/assets/image?text=cute%20pink%20bunny%20rabbit%20portrait&aspect=1:1',
                                ),
                              ),
                            ),
                            _buildOverlayIcon(Icons.photo),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 30),
                      // Text(
                      //   "Create",
                      //   style: GoogleFonts.k2d(
                      //     fontSize: 48,
                      //     fontWeight: FontWeight.bold,
                      //     color: theme.secondary,
                      //     height: 1.1,
                      //   ),
                      // ),
                      // Text(
                      //   "Profile!",
                      //   style: GoogleFonts.k2d(
                      //     fontSize: 48,
                      //     fontWeight: FontWeight.bold,
                      //     color: theme.outline,
                      //     height: 1.1,
                      //   ),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   "Tell us a bit about yourself to find your people.",
                      //   style: GoogleFonts.k2d(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w500,
                      //     color: theme.tertiary,
                      //   ),
                      // ),
                      // SizedBox(height: 25),
                      _buildLabel("Username", theme),
                      PrimaryTextField(
                        controller: createProfileProvider.userNameController,
                        hintText: "Choose a unique username",
                      ),
                      SizedBox(height: 20),

                      _buildLabel("Display Name", theme),
                      PrimaryTextField(
                        controller: createProfileProvider.displayNameController,
                        hintText: "Enter the name that you want display",
                      ),
                      SizedBox(height: 20),

                      _buildLabel("Your Interest/Vibe", theme),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_interests.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: _interests.asMap().entries.map((
                                    entry,
                                  ) {
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
                                      onDeleted: () =>
                                          _removeInterest(entry.key),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      labelPadding: EdgeInsets.symmetric(
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
                                contentPadding: EdgeInsets.symmetric(
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
                                  // splashRadius:   Box raints(),
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
                      SizedBox(height: 20),

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
                          contentPadding: EdgeInsets.symmetric(
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
                      SizedBox(height: 20),

                      _buildLabel("Date of Birth", theme),
                      PrimaryTextField(
                        controller: createProfileProvider.dateOfBirthController,
                        hintText: "DD/MM/YYYY",
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      SizedBox(height: 20),

                      PrimaryButton(
                        text: "Create Profile",
                        onPressed: _validateAndProceed,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverlayIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildLabel(String text, ColorScheme theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
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
