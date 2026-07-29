import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const FriendItem({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.k2d(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Add",
            style: GoogleFonts.k2d(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.grey, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          "Add",
          style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
