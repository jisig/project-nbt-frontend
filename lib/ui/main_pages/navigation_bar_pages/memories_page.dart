import 'package:flutter/material.dart';
import 'package:project_nbt/ui/components/pages/club_card.dart';
import 'package:project_nbt/ui/components/pages/home_header.dart';

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(userName: "Maya"),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
