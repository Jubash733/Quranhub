import 'package:flutter/material.dart';
import 'package:resources/widgets/glass_box.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "My Library",
          style: kHeading6.copyWith(
            color: isDark ? kGoldPrimary : kDarkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : kPurplePrimary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GlassBox(
              isDark: isDark,
              borderRadius: 12,
              padding: const EdgeInsets.all(4),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: isDark ? kGoldPrimary : kPurplePrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.white70 : kGrey,
                tabs: const [
                  Tab(
                      text: "Bookmarks",
                      icon: Icon(Icons.bookmark_border_rounded, size: 20)),
                  Tab(
                      text: "Notes",
                      icon: Icon(Icons.edit_note_rounded, size: 20)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF0B1220),
                  ]
                : [
                    const Color(0xFFF8F9FA),
                    const Color(0xFFE9ECEF),
                  ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBookmarksTab(context, isDark),
            _buildNotesTab(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarksTab(BuildContext context, bool isDark) {
    // Placeholder content
    return ListView.builder(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ShowUpAnimation(
          delayStart: Duration(milliseconds: index * 50),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassBox(
              isDark: isDark,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isDark ? kGoldDark.withOpacity(0.2) : kLinearPurple1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: kHeading6.copyWith(
                          color: isDark ? kGoldPrimary : kPurplePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Surah Al-Fatiha",
                        style: kHeading6.copyWith(
                          color: isDark ? Colors.white : kBlackPurple,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Ayah ${index + 5}",
                        style: kSubtitle.copyWith(
                          color: isDark ? kGreyLight : kGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: isDark ? Colors.white54 : kGrey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined,
              size: 60, color: isDark ? kGreyLight : kGrey),
          const SizedBox(height: 16),
          Text(
            "No notes yet",
            style:
                kHeading6.copyWith(color: isDark ? Colors.white : kBlackPurple),
          ),
        ],
      ),
    );
  }
}
