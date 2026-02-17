import 'package:flutter/material.dart';
import '../models/user_state.dart';
import 'dashboard_page.dart';
import 'leaderboard_page.dart';
import 'awards_page.dart';
import 'notifications_page.dart';

class MainNavigation extends StatefulWidget {
  final UserStateModel user;
  const MainNavigation({super.key, required this.user});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  void _changeTab(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardPage(user: widget.user, onTabRequest: _changeTab),
      const LeaderboardPage(),
      AwardsPage(userId: widget.user.userId),
      NotificationsPage(userId: widget.user.userId),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _changeTab,
        selectedItemColor: const Color(0xFF0038A8),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // 4 eleman olduğu için zorunlu
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "İzle"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Sıralama"),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "Ödüller"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "BiP"),
        ],
      ),
    );
  }
}