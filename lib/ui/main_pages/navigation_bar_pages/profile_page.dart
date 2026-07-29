import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/buttons/sections_buttons.dart';
import 'package:project_nbt/ui/components/dialogs/logout_dialog.dart';
import 'package:project_nbt/ui/sub_pages/profiles/chat_settings_page.dart';
import 'package:project_nbt/ui/sub_pages/profiles/profile_edit_page.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              borderRadius: BorderRadius.only(
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
                  child: Image(
                    image: NetworkImage(
                      'https://api.a0.dev/assets/image?text=beautiful%20fairytale%20forest%20illustration%20with%20rainbow%20valley&aspect=16:9',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 97, left: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: theme.onInverseSurface,
                        width: 5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        'https://api.a0.dev/assets/image?text=cute%20pink%20bunny%20rabbit%20portrait&aspect=1:1',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, top: 155),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Victoria Andres",
                            style: GoogleFonts.k2d(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: theme.inversePrimary,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(CupertinoIcons.checkmark_seal_fill, size: 20),
                        ],
                      ),
                      Text(
                        "@victoria",
                        style: GoogleFonts.k2d(color: theme.tertiary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 205,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: weight * 0.75,
                                child: Text(
                                  "I know who I am, I know what I bring to the table. So GOAT",
                                  style: GoogleFonts.k2d(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: theme.tertiary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "100 Bonds",
                                    style: GoogleFonts.k2d(
                                      color: theme.inversePrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "20 Pending",
                                    style: GoogleFonts.k2d(
                                      color: theme.inversePrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(CupertinoIcons.qrcode, size: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "Account",
              style: GoogleFonts.k2d(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.tertiary,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SectionsButtons(
                  icon: "lib/assets/icons/profile.png",
                  title: "Account Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditPage(),
                      ),
                    );
                  },
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/notification.png",
                  title: "Notification Settings",
                  onTap: () {},
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/privacy.png",
                  title: "Privacy",
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "Preference",
              style: GoogleFonts.k2d(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.tertiary,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SectionsButtons(
                  icon: "lib/assets/icons/chats.png",
                  title: "Chats Settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatSettingsPage(),
                      ),
                    );
                  },
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/profile.png",
                  title: "Avatar",
                  onTap: () {},
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/language.png",
                  title: "Language",
                  onTap: () {},
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/theme_settings.png",
                  title: "Theme Settings",
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "Support & Additional Options",
              style: GoogleFonts.k2d(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.tertiary,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SectionsButtons(
                  icon: "lib/assets/icons/help_center.png",
                  title: "Help Center",
                  onTap: () {},
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/groups.png",
                  title: "Invite Friends",
                  onTap: () {},
                ),
                SectionsButtons(
                  icon: "lib/assets/icons/logout.png",
                  title: "Logout",
                  textColor: theme.error,
                  iconColor: theme.error,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LogoutDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
