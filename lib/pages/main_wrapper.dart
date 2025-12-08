import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'menu/menu_page.dart';
import 'profile/profile_page.dart';
import '../widgets/app_widgets.dart';

// =========================================================================
// MAIN WRAPPER (STATEFUL WIDGET UNTUK NAVIGASI BOTTOM BAR)
// =========================================================================

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // List halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const HomePage(),
    const MenuPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: NavBarItem(
                icon: Icons.home_filled,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: NavBarItem(
                icon: Icons.menu_book,
                label: 'Menu',
                isSelected: _currentIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: NavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: _currentIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
