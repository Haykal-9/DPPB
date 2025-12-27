import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../product/pages/menu_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../reservation/pages/reservation_page.dart';
import '../widgets/nav_bar_item.dart';

// =========================================================================
// MAIN WRAPPER (STATEFUL WIDGET UNTUK NAVIGASI BOTTOM BAR)
// =========================================================================

class MainWrapper extends StatefulWidget {
  final int? initialIndex;
  const MainWrapper({super.key, this.initialIndex});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
  }

  // List halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const HomePage(),
    const MenuPage(),
    ReservationPage(),

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
        padding: EdgeInsets.zero, // Remove default padding
        color: Colors.white,
        elevation: 10,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        height: 60, // Force slimmer height
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                behavior:
                    HitTestBehavior.opaque, // Ensure clicks work everywhere
                onTap: () => _onItemTapped(0),
                child: NavBarItem(
                  icon: Icons.home_filled,
                  label: 'Home',
                  isSelected: _currentIndex == 0,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _onItemTapped(1),
                child: NavBarItem(
                  icon: Icons.menu_book,
                  label: 'Menu',
                  isSelected: _currentIndex == 1,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _onItemTapped(2),
                child: NavBarItem(
                  icon: Icons.event_seat,
                  label: 'Reservation',
                  isSelected: _currentIndex == 2,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _onItemTapped(3),
                child: NavBarItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isSelected: _currentIndex == 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
