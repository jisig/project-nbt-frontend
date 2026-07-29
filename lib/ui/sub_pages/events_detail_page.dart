import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sunset Live Sessions",
              style: GoogleFonts.k2d(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Event details and everything you need to know",
              style: GoogleFonts.k2d(
                fontSize: 12,
                color: Colors.grey[500],
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          "https://api.a0.dev/assets/image?text=crowd%20at%20a%20music%20concert%20with%20colorful%20lights&aspect=16:9",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text("JUN", style: GoogleFonts.k2d(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                              Text("14", style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.black87),
                              const SizedBox(width: 4),
                              Text("Riverside Park", style: GoogleFonts.k2d(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunset Live Sessions",
                                  style: GoogleFonts.k2d(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Saturday, June 14 · 6:30 PM - 10:00 PM",
                                      style: GoogleFonts.k2d(fontSize: 13, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text("Price", style: GoogleFonts.k2d(fontSize: 10, color: Colors.grey[500])),
                                Text("\$18", style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Stats Row
                      Row(
                        children: [
                          _buildStatItem("Going", "32"),
                          const SizedBox(width: 12),
                          _buildStatItem("Spots left", "18"),
                          const SizedBox(width: 12),
                          _buildStatItem("Distance", "2.4 mi"),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // About Section
                      _buildInfoContainer(
                        icon: Icons.info_outline,
                        title: "About this event",
                        content: "An open-air evening of live music, food trucks, and community vibes by the river. Bring a blanket, invite friends, and enjoy the sunset set with local artists and a relaxed crowd.",
                      ),

                      const SizedBox(height: 24),

                      // Location/Map
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Riverside Park Amphitheater, 1200 River Walk Ave, Downtown",
                            style: GoogleFonts.k2d(fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://api.a0.dev/assets/image?text=minimalist%20city%20map%20with%20a%20large%20green%20park%20and%20river&aspect=16:9",
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // What to expect
                      _buildInfoContainer(
                        icon: Icons.checklist_rtl_rounded,
                        title: "What to expect",
                        child: Column(
                          children: [
                            _buildCheckItem("Live performances from local bands"),
                            _buildCheckItem("Food and drinks available on site"),
                            _buildCheckItem("Outdoor seating and sunset views"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Organizer Note
                      _buildInfoContainer(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: "Organizer note",
                        content: "Doors open at 5:30 PM. Arrive early for the best seats near the stage. This event is family-friendly and accessible.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[100]!),
                          backgroundColor: Colors.grey[50],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: Text(
                          "Save for Later",
                          style: GoogleFonts.k2d(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: Text(
                          "RSVP Now",
                          style: GoogleFonts.k2d(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.k2d(fontSize: 11, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.k2d(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer({required IconData icon, required String title, String? content, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Icon(icon, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.k2d(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: GoogleFonts.k2d(fontSize: 13, height: 1.6, color: Colors.grey[600]),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.k2d(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}