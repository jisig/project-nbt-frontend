import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPostCard extends StatelessWidget {
  final String userAvatar;
  final String userName;
  final String tag;
  final String time;
  final String content;
  final String? postImage;
  final String likes;
  final String comments;

  const FeedPostCard({
    super.key,
    required this.userAvatar,
    required this.userName,
    required this.tag,
    required this.time,
    required this.content,
    this.postImage,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7.5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.k2d(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        tag,
                        style: GoogleFonts.k2d(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("•", style: TextStyle(color: Colors.grey[400])),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: GoogleFonts.k2d(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: GoogleFonts.k2d(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.k2d(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          if (postImage != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                postImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 6),
              Text(
                likes,
                style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 6),
              Text(
                comments,
                style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500]),
              ),
              const Spacer(),
              Icon(Icons.share_outlined, size: 20, color: Colors.grey[400]),
            ],
          ),
        ],
      ),
    );
  }
}
