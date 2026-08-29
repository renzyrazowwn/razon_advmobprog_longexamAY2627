import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../widgets/custom_font.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId;

  const HomeScreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController =
      PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getTitle(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return 'Peacebook';
      case 1:
        return 'Notifications';
      case 2:
        return widget.username;
      default:
        return 'Peacebook';
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      NewsFeedScreen(
        userId: widget.userId,
        username: widget.username,
      ),
      const NotificationScreen(),
      ProfileScreen(
        username: widget.username,
        userId: widget.userId,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: CustomFont(
          text: _getTitle(context),
          fontSize: 22.sp,
          color: _selectedIndex == 0
              ? PEACE_PRIMARY
              : Theme.of(context)
                  .appBarTheme
                  .foregroundColor ??
                  Theme.of(context)
                      .colorScheme
                      .onSurface,
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: _openSettings,
            tooltip: 'Settings',
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: pages,
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}