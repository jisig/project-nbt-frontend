import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/buttons/secondary_button.dart';
import 'package:project_nbt/ui/main_pages/navigation_bar_pages/circles_page.dart';
import 'package:project_nbt/ui/main_pages/navigation_bar_pages/home_page.dart';
import 'package:project_nbt/ui/main_pages/navigation_bar_pages/memories_page.dart';
import 'package:project_nbt/ui/main_pages/navigation_bar_pages/profile_page.dart';
import 'package:project_nbt/ui/sub_pages/events_creation_form.dart';

import '../buttons/tertiary_button.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MemoriesPage(),
    CirclesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  height: height * 0.46,
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 32,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 7.5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.tertiary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Create New",
                        style: GoogleFonts.k2d(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.inversePrimary,
                        ),
                      ),
                      Text(
                        "What would you like to create?",
                        style: GoogleFonts.k2d(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.tertiary,
                        ),
                      ),
                      Spacer(),
                      TertiaryButton(
                        icon: Icons.event,
                        title: "Create Event",
                        subtitle: "Set up an event with venue, date & details",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventsCreationForm(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      TertiaryButton(
                        icon: Icons.event,
                        title: "Create Club",
                        subtitle: "Start a community around shared interest",
                        onTap: () {},
                      ),
                      // SizedBox(height: 10),
                      SecondaryButton(
                        text: "Cancel",
                        onPressed: () {},
                        borderRadius: 12,
                        height: 50,
                        color: theme.inversePrimary,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, "Home", 0),
            _buildNavItem(CupertinoIcons.camera_on_rectangle, "Memories", 1),
            _buildNavItem(Icons.people_outline_rounded, "Circles", 2),
            _buildNavItem(Icons.person_outline_rounded, "You", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF758E97)
                  : const Color(0xFFB3C0C9),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.k2d(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF758E97),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
