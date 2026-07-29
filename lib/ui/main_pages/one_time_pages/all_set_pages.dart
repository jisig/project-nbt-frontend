import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:project_nbt/ui/components/buttons/primary_button.dart';
import 'package:project_nbt/ui/main_pages/navigation_bar_pages/profile_page.dart';
import 'package:project_nbt/ui/sub_pages/clubs_details_page.dart';
import 'package:project_nbt/ui/sub_pages/events_detail_page.dart';

class AllSetPage extends StatelessWidget {
  const AllSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.star_border_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're All Set, Maya!",
                            style: GoogleFonts.k2d(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Your profile is ready to explore",
                            style: GoogleFonts.k2d(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildHeaderButton(Icons.search),
                    const SizedBox(width: 12),
                    _buildHeaderButton(Icons.notifications_none_rounded),
                  ],
                ),
              ),

              // Suggested Clubs
              _buildSectionTitle("Suggested Clubs", "Based on your interests"),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ClubDetailsPage(),
                          ),
                        );
                      },
                      child: _buildClubCard(
                        icon: Icons.terrain_rounded,
                        title: "Trail Seekers",
                        members: "1.2k members",
                        desc: "Weekend hikes, routes, and meetups",
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildClubCard(
                      icon: Icons.camera_alt_outlined,
                      title: "Frame It",
                      members: "860 members",
                      desc: "Photo walks and editing tips",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Add Friends
              _buildSectionTitle("Add Friends", "People you may know"),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddButton(),
                    const SizedBox(width: 20),
                    _buildFriendItem(
                      "Ava",
                      "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20smiling%20woman&aspect=1:1",
                    ),
                    const SizedBox(width: 20),
                    _buildFriendItem(
                      "Leo",
                      "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20young%20man&aspect=1:1",
                    ),
                    const SizedBox(width: 20),
                    _buildFriendItem(
                      "Mia",
                      "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20woman%20outdoors&aspect=1:1",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Events Near You
              _buildSectionTitle("Events Near You", "RSVP to join"),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventDetailsPage(),
                          ),
                        );
                      },
                      child: _buildEventCard(
                        image:
                            "https://api.a0.dev/assets/image?text=crowd%20at%20a%20music%20concert%20with%20colorful%20lights&aspect=4:3",
                        date: "14",
                        month: "JUN",
                        title: "Sunset Live Sessions",
                        location: "Riverside Park",
                        attendees: "32 going",
                        buttonText: "RSVP",
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildEventCard(
                      image:
                          "https://api.a0.dev/assets/image?text=art%20gallery%20interior%20with%20paintings%20on%20white%20walls&aspect=4:3",
                      date: "18",
                      month: "JUN",
                      title: "Modern Art Expo",
                      location: "Downtown Gallery",
                      attendees: "12 going",
                      buttonText: "Join",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Continue when you're ready",
                      style: GoogleFonts.k2d(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 56,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => const ProfilePage()),
                    //             (route) => false,
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF121212),
                    //       foregroundColor: Colors.white,
                    //       elevation: 0,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       "Continue to Home",
                    //       style: GoogleFonts.k2d(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    PrimaryButton(
                      text: "Continue to Home",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomNavigationBar(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.k2d(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.k2d(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildClubCard({
    required IconData icon,
    required String title,
    required String members,
    required String desc,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.k2d(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      members,
                      style: GoogleFonts.k2d(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: GoogleFonts.k2d(
              color: Colors.grey[600],
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Join",
                style: GoogleFonts.k2d(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(Icons.add, color: Colors.grey, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          "Add",
          style: GoogleFonts.k2d(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFriendItem(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(radius: 32, backgroundImage: NetworkImage(imageUrl)),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.k2d(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Add",
            style: GoogleFonts.k2d(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String image,
    required String date,
    required String month,
    required String title,
    required String location,
    required String attendees,
    required String buttonText,
  }) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: GoogleFonts.k2d(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.k2d(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: GoogleFonts.k2d(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      attendees,
                      style: GoogleFonts.k2d(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.k2d(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
