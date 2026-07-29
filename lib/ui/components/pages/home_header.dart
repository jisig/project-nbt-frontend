import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:project_nbt/ui/sub_pages/chat_pages/chat_listing_page.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.hub_rounded, color: theme.inversePrimary),
            SizedBox(width: 10),
            Text(
              "Kindred",
              style: GoogleFonts.k2d(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.inversePrimary,
              ),
            ),
            Spacer(),
            _HeaderButton(icon: Icons.search, onTap: () {}),
            SizedBox(width: 5),
            _HeaderButton(
              icon: CupertinoIcons.bell,
              hasNotification: true,
              onTap: () {},
            ),
            _HeaderButton(
              icon: CupertinoIcons.chat_bubble_fill,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListingPage()),
                );
              },
            ),
          ],
        ),
        Text(
          "Good morning, $userName",
          style: GoogleFonts.k2d(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final VoidCallback onTap;

  _HeaderButton({
    required this.icon,
    this.hasNotification = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: Colors.black87),
          ),
          if (hasNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
