import 'package:flutter/material.dart';
import 'package:project_nbt/apis/providers/auth/signin_provider.dart';
import 'package:project_nbt/ui/components/pages/club_card.dart';
import 'package:project_nbt/ui/components/pages/event_card.dart';
import 'package:project_nbt/ui/components/pages/feed_post_card.dart';
import 'package:project_nbt/ui/components/pages/friend_item.dart';
import 'package:project_nbt/ui/components/pages/home_header.dart';
import 'package:project_nbt/ui/components/pages/section_header.dart';
import 'package:project_nbt/ui/sub_pages/clubs_details_page.dart';
import 'package:project_nbt/ui/sub_pages/events_detail_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SignInProvider>().currentUser;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(userName: user?.displayName ?? ""),
                const SizedBox(height: 15),
                SectionHeader(
                  title: "Suggested Clubs",
                  subtitle: "Based on your interests",
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ClubCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClubDetailsPage(),
                            ),
                          );
                        },
                        image:
                            "https://api.a0.dev/assets/image?text=group%20of%20people%20cycling%20on%20a%20road&aspect=16:9",
                        tag: "Hiking",
                        title: "Trailblazers",
                        members: "248 members",
                      ),
                      const SizedBox(width: 16),
                      const ClubCard(
                        image:
                            "https://api.a0.dev/assets/image?text=close%20up%20of%20a%20professional%20camera%20lens&aspect=16:9",
                        tag: "Photography",
                        title: "Shutter Club",
                        members: "132 members",
                        isJoined: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                SectionHeader(
                  title: "Add Friends",
                  subtitle: "People you may know",
                ),
                const SizedBox(height: 16),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddFriendButton(),
                      SizedBox(width: 20),
                      FriendItem(
                        name: "Ava",
                        imageUrl:
                            "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20smiling%20woman&aspect=1:1",
                      ),
                      SizedBox(width: 20),
                      FriendItem(
                        name: "Leo",
                        imageUrl:
                            "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20young%20man&aspect=1:1",
                      ),
                      SizedBox(width: 20),
                      FriendItem(
                        name: "Nora",
                        imageUrl:
                            "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20woman%20with%20dark%20hair&aspect=1:1",
                      ),
                      SizedBox(width: 20),
                      FriendItem(
                        name: "Sam",
                        imageUrl:
                            "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20man%20with%20beard&aspect=1:1",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                SectionHeader(
                  title: "Upcoming Events",
                  subtitle: "Related to your interests",
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      EventCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EventDetailsPage(),
                            ),
                          );
                        },
                        image:
                            "https://api.a0.dev/assets/image?text=crowd%20at%20a%20music%20concert%20with%20colorful%20lights&aspect=16:9",
                        date: "14",
                        month: "JUN",
                        title: "Sunset Live Sessions",
                        location: "Riverside Park",
                        attendees: "32 going",
                      ),
                      const SizedBox(width: 16),
                      const EventCard(
                        image:
                            "https://api.a0.dev/assets/image?text=art%20gallery%20interior%20with%20paintings%20on%20white%20walls&aspect=16:9",
                        date: "18",
                        month: "JUN",
                        title: "Modern Art Expo",
                        location: "Downtown Gallery",
                        attendees: "18 going",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                SectionHeader(
                  title: "Memories",
                  subtitle: "Latest from your circles",
                ),
                const SizedBox(height: 16),
                const FeedPostCard(
                  userAvatar:
                      "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20young%20man&aspect=1:1",
                  userName: "Leo Martins",
                  tag: "Hiking",
                  time: "2h ago",
                  content:
                      "Reached the summit just before sunrise. Absolutely worth the 4am wake up call!",
                  postImage:
                      "https://api.a0.dev/assets/image?text=beautiful%20mountain%20landscape%20view%20from%20the%20top&aspect=16:9",
                  likes: "24",
                  comments: "6",
                ),
                const FeedPostCard(
                  userAvatar:
                      "https://api.a0.dev/assets/image?text=profile%20portrait%20of%20a%20smiling%20woman&aspect=1:1",
                  userName: "Ava Chen",
                  tag: "Photography",
                  time: "5h ago",
                  content:
                      "Playing with long exposure downtown tonight. City lights hit different.",
                  likes: "41",
                  comments: "12",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
