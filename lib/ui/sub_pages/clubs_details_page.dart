import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClubDetailsPage extends StatelessWidget {
  const ClubDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trailblazers",
                    style: GoogleFonts.k2d(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Adventure club for hikers, cyclists...",
                    style: GoogleFonts.k2d(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: Colors.grey[600]),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_border_rounded, color: Colors.grey[600]),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      "https://api.a0.dev/assets/image?text=beautiful%20green%20mountain%20slope%20with%20hiking%20trail&aspect=16:9",
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Outdoor • Active",
                        style: GoogleFonts.k2d(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: _buildInfoBadge("Members", "248"),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _buildInfoBadge("Founded", "2019"),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "About this club",
                    style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "A welcoming community for people who love trails, fresh air, and shared adventures. We organize weekly hikes, sunrise walks, cycling meetups, and occasional camping trips.",
                    style: GoogleFonts.k2d(fontSize: 14, color: Colors.grey[600], height: 1.6),
                  ),

                  const SizedBox(height: 24),

                  // Info Cards
                  Row(
                    children: [
                      _buildDetailCard(Icons.location_on_outlined, "Base", "Riverside Park"),
                      const SizedBox(width: 12),
                      _buildDetailCard(Icons.calendar_month_outlined, "Meetups", "Weekly"),
                      const SizedBox(width: 12),
                      _buildDetailCard(Icons.favorite_border_rounded, "Vibe", "Friendly"),
                    ],
                  ),

                  const SizedBox(height: 32),

                  _buildSectionTitle("Interests", "Matched to you"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInterestTag("Hiking"),
                      _buildInterestTag("Cycling"),
                      _buildInterestTag("Camping"),
                      _buildInterestTag("Nature"),
                      _buildInterestTag("Sunrise"),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Next club event
                  _buildEventSection(),

                  const SizedBox(height: 24),

                  // Club leaders
                  _buildLeadersSection(),

                  const SizedBox(height: 24),

                  // Recent activity
                  _buildActivitySection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.k2d(fontSize: 10, color: Colors.grey[600])),
          Text(value, style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey[500]),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.k2d(fontSize: 11, color: Colors.grey[500])),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.k2d(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: GoogleFonts.k2d(fontSize: 13, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildInterestTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Text(text, style: GoogleFonts.k2d(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildEventSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Next club event", style: GoogleFonts.k2d(fontSize: 15, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("RSVP Open", style: GoogleFonts.k2d(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text("Sunrise Ridge Hike • Saturday, 6:30 AM", style: GoogleFonts.k2d(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.confirmation_num_outlined, size: 20, color: Colors.black54),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("8 spots left", style: GoogleFonts.k2d(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("Meet at the trailhead, bring water and comfortable shoes.", style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Club leaders", style: GoogleFonts.k2d(fontSize: 15, fontWeight: FontWeight.bold)),
              Text("3 admins", style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 18, backgroundImage: NetworkImage("https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20smiling%20woman&aspect=1:1")),
                    Positioned(left: 20, child: const CircleAvatar(radius: 18, backgroundImage: NetworkImage("https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20young%20man&aspect=1:1"))),
                    Positioned(left: 40, child: const CircleAvatar(radius: 18, backgroundImage: NetworkImage("https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20woman%20with%20dark%20hair&aspect=1:1"))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Maya, Leo, and Priya", style: GoogleFonts.k2d(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("Organize routes, approve members, and host events", style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent activity", style: GoogleFonts.k2d(fontSize: 15, fontWeight: FontWeight.bold)),
              Text("Latest from the club", style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivityItem(Icons.route_outlined, "New trail added", "Blue Ridge Loop was voted in for next weekend's hike."),
          const SizedBox(height: 16),
          _buildActivityItem(Icons.chat_bubble_outline_rounded, "Member chat is active", "42 messages today about gear, carpooling, and weather."),
          const SizedBox(height: 16),
          _buildActivityItem(Icons.camera_alt_outlined, "Photo album updated", "New sunrise shots from last Sunday's summit are live."),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Colors.black54),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.k2d(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(desc, style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[600], height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}