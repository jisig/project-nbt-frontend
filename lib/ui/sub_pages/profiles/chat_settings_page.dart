import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  bool _enterIsSend = false;
  bool _mediaDownload = true;
  bool _keepArchived = true;
  bool _includeMedia = true;
  bool _backupCellular = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.inversePrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Chat",
          style: GoogleFonts.k2d(
            color: theme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Chat Settings", theme),
            _buildToggleItem(
              Icons.person_outline,
              "Enter is Send",
              "Press Enter key to Send Message",
              _enterIsSend,
              (val) => setState(() => _enterIsSend = val),
              theme,
            ),
            _buildToggleItem(
              Icons.person_outline,
              "Media Download",
              "Automatically Save new media to gallery",
              _mediaDownload,
              (val) => setState(() => _mediaDownload = val),
              theme,
            ),
            _buildNavigationItem(Icons.person_outline, "Font Size", "Medium", theme),
            _buildNavigationItem(Icons.person_outline, "Voice Message Transcript", "Read Message aloud", theme),
            
            const Divider(height: 32),
            
            _buildSectionTitle("Archived Chats", theme),
            _buildToggleItem(
              Icons.person_outline,
              "Keep chats archived",
              "Archived Chats remain Archived when new message arrives",
              _keepArchived,
              (val) => setState(() => _keepArchived = val),
              theme,
            ),

            const Divider(height: 32),

            _buildSectionTitle("Chat Backup", theme),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Backup your chat and media to your Google Account's Storage. You can Restore them for future login.",
                style: GoogleFonts.k2d(color: theme.tertiary, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.tertiary.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text("Backup Now", style: GoogleFonts.k2d(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 16),
            _buildNavigationItem(Icons.person_outline, "Google Account", "testemail1@gmail.com", theme),
            _buildNavigationItem(Icons.person_outline, "Automatic Backup", "Daily", theme),
            _buildToggleItem(
              Icons.person_outline,
              "Include Media",
              "Backup Videos & Photos also",
              _includeMedia,
              (val) => setState(() => _includeMedia = val),
              theme,
            ),
            _buildToggleItem(
              Icons.person_outline,
              "Backup using Cellular",
              "",
              _backupCellular,
              (val) => setState(() => _backupCellular = val),
              theme,
            ),

            const Divider(height: 32),

            _buildNavigationItem(Icons.person_outline, "Transfer Chat", "Transfer Chat to Other Phone", theme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(
        title,
        style: GoogleFonts.k2d(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.tertiary,
        ),
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, ColorScheme theme) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: GoogleFonts.k2d(fontWeight: FontWeight.w500, fontSize: 16)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: GoogleFonts.k2d(fontSize: 12, color: theme.tertiary)) : null,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.primary.withOpacity(0.8),
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, String subtitle, ColorScheme theme) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: GoogleFonts.k2d(fontWeight: FontWeight.w500, fontSize: 16)),
      subtitle: Text(subtitle, style: GoogleFonts.k2d(fontSize: 12, color: theme.tertiary)),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black87),
      onTap: () {},
    );
  }
}
