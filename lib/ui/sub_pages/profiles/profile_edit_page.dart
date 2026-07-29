import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _usernameController = TextEditingController(text: "@victoria_08");
  final TextEditingController _displayNameController = TextEditingController(text: "Victoria Andres");
  final TextEditingController _mobileController = TextEditingController(text: "+91 1234567891");
  final TextEditingController _pronounsController = TextEditingController(text: "Choose pronouns");
  final TextEditingController _dobController = TextEditingController(text: "01/01/1999");
  final TextEditingController _passwordController = TextEditingController(text: "****************");
  final TextEditingController _bioController = TextEditingController(text: "I know who I am, I know what I bring to the table. So trust...");

  // Focus Nodes
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _displayNameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _pronounsFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  // Edit States
  bool _isUsernameEditing = false;
  bool _isDisplayNameEditing = false;
  bool _isMobileEditing = false;
  bool _isPronounsEditing = false;
  bool _isDobEditing = false;
  bool _isPasswordEditing = false;
  bool _isBioEditing = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _mobileController.dispose();
    _pronounsController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _bioController.dispose();

    _usernameFocus.dispose();
    _displayNameFocus.dispose();
    _mobileFocus.dispose();
    _pronounsFocus.dispose();
    _dobFocus.dispose();
    _passwordFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  void _toggleEdit(String field) {
    setState(() {
      switch (field) {
        case 'username':
          _isUsernameEditing = !_isUsernameEditing;
          if (_isUsernameEditing) _usernameFocus.requestFocus();
          break;
        case 'displayName':
          _isDisplayNameEditing = !_isDisplayNameEditing;
          if (_isDisplayNameEditing) _displayNameFocus.requestFocus();
          break;
        case 'mobile':
          _isMobileEditing = !_isMobileEditing;
          if (_isMobileEditing) _mobileFocus.requestFocus();
          break;
        case 'pronouns':
          _isPronounsEditing = !_isPronounsEditing;
          if (_isPronounsEditing) _pronounsFocus.requestFocus();
          break;
        case 'dob':
          _isDobEditing = !_isDobEditing;
          if (_isDobEditing) _dobFocus.requestFocus();
          break;
        case 'password':
          _isPasswordEditing = !_isPasswordEditing;
          if (_isPasswordEditing) _passwordFocus.requestFocus();
          break;
        case 'bio':
          _isBioEditing = !_isBioEditing;
          if (_isBioEditing) _bioFocus.requestFocus();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with overlays
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
                    shape: DiagonalShape(direction: DiagonalDirection.Right),
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
                          child: _buildOverlayIcon(Icons.edit_outlined),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 97, left: 15),
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
                        _buildOverlayIcon(Icons.edit_outlined),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120, top: 155),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Victoria Andres",
                          style: GoogleFonts.k2d(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: theme.inversePrimary,
                          ),
                        ),
                        Text(
                          "@username",
                          style: GoogleFonts.k2d(color: theme.tertiary),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 205, right: 15, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _bioController,
                            focusNode: _bioFocus,
                            readOnly: !_isBioEditing,
                            style: GoogleFonts.k2d(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: theme.tertiary,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _toggleEdit('bio'),
                          child: Icon(
                            _isBioEditing ? Icons.check : Icons.edit_outlined,
                            size: 20,
                            color: theme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildEditField("Username", _usernameController, _isUsernameEditing, _usernameFocus, () => _toggleEdit('username')),
                  const SizedBox(height: 15),
                  _buildEditField("Display Name", _displayNameController, _isDisplayNameEditing, _displayNameFocus, () => _toggleEdit('displayName')),
                  const SizedBox(height: 15),
                  _buildEditField("Mobile", _mobileController, _isMobileEditing, _mobileFocus, () => _toggleEdit('mobile')),
                  const SizedBox(height: 15),
                  _buildEditField("Pronouns", _pronounsController, _isPronounsEditing, _pronounsFocus, () => _toggleEdit('pronouns')),
                  const SizedBox(height: 15),
                  _buildEditField("Date of Birth", _dobController, _isDobEditing, _dobFocus, () => _toggleEdit('dob')),
                  const SizedBox(height: 15),
                  _buildEditField("Password", _passwordController, _isPasswordEditing, _passwordFocus, () => _toggleEdit('password'), obscure: true),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
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

  Widget _buildEditField(String label, TextEditingController controller, bool isEditing, FocusNode focusNode, VoidCallback onToggle, {bool obscure = false}) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.k2d(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.onSurface,
            ),
          ),
        ),
        PrimaryTextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: !isEditing,
          obscureText: obscure,
          suffixIcon: GestureDetector(
            onTap: onToggle,
            child: Icon(
              isEditing ? Icons.check : Icons.edit_outlined,
              color: theme.tertiary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
