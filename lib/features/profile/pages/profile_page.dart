import 'package:flutter/material.dart';
import '../../auth/pages/login_page.dart';
import '../../order/pages/order_history_page.dart';
import '../../order/pages/reservation_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Theme Colors
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _bgPage,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            _buildProfileHeader(),

            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: _textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingTiles(context),
            const SizedBox(height: 40),
            _buildLogoutButton(context),
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _goldPrimary, width: 2),
            boxShadow: [
              BoxShadow(
                color: _goldPrimary.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const AssetImage(
              'assets/logo/logo.png',
            ), // Placeholder or User Image
            // If asset not found, it will just show bg color.
            // Better to handle gracefully or use text fallback if desired,
            // but for "Profile" usually an image is expected.
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Salman Seftaesa Lazuardy',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            color: _textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'salman.seftaesa@tapalkudacoffee.com',
          style: TextStyle(color: _textSecondary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingTiles(BuildContext context) {
    return Column(
      children: [
        _buildSettingTile(
          context,
          'My Orders',
          'Track active and past orders',
          Icons.shopping_bag_outlined,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const OrderHistoryPage()),
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          context,
          'Reservations',
          'Manage your table bookings',
          Icons.calendar_today_outlined,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const ReservationHistoryPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _bgPage,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        // Clear session data if any (e.g., SharedPreferences) here

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
      label: const Text(
        'Log Out',
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
