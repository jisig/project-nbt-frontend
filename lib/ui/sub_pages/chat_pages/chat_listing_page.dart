import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:project_nbt/ui/components/text_feild/secondary_text_feild.dart';
import 'package:project_nbt/ui/sub_pages/chat_pages/chatting_page.dart';

class ChatListingPage extends StatefulWidget {
  const ChatListingPage({super.key});

  @override
  State<ChatListingPage> createState() => _ChatListingPageState();
}

class _ChatListingPageState extends State<ChatListingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "lib/assets/icons/chats.png",
                      scale: 25,
                      color: theme.inversePrimary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Conversations",
                      style: GoogleFonts.k2d(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.inversePrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SecondaryTextFelid(
                  controller: searchController,
                  keyBoardType: TextInputType.text,
                  edgeInsets: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search conversations",
                  filledColor: theme.tertiary.withOpacity(0.2),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.tertiary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      labelStyle: TextStyle(color: theme.surface),
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "Pending"),
                        Tab(text: "Pending"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: theme.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://api.a0.dev/assets/image?text=cute%20pink%20bunny%20rabbit%20portrait&aspect=1:1",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            "Sofia",
                            style: GoogleFonts.k2d(color: theme.inversePrimary),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 10);
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: height * 0.5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChattingPage()),
                      );
                    },
                    child: ListView.separated(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: height * 0.055,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  "https://api.a0.dev/assets/image?text=cute%20pink%20bunny%20rabbit%20portrait&aspect=1:1",
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sofia Ramirez",
                                    style: GoogleFonts.k2d(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: theme.inversePrimary,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Sounds good",
                                    style: GoogleFonts.k2d(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: theme.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Today",
                                    style: GoogleFonts.k2d(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: theme.tertiary,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      color: theme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "20",
                                        style: GoogleFonts.k2d(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: theme.surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: height * 0.015);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
