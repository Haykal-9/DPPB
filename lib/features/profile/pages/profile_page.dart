import 'package:flutter/material.dart';
import '../../../core/services/user_session.dart';
import '../../../core/config/api_config.dart';
import '../../auth/data/services/auth_service.dart';
import '../../reservation/pages/reservation_history_page.dart';
import '../../order/pages/order_history_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Light Luxury Theme Constants
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _textPrimary = const Color(0xFF4A3B32);
  final Color _textSecondary = const Color(0xFF8D7B68);

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    await _authService.fetchCurrentUser();
    if (mounted) setState(() {});
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession.instance.currentUser;

    return Scaffold(
      backgroundColor: _bgPage,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Gold Background (behind the content, scrolls with it)
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: _goldPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

            // Main Content (on top of gold background)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Title
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Profile Info Card with Floating Avatar
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // White Card
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 5,
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Name
                              Text(
                                user?.nama ?? 'Guest User',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),

                              // Email
                              _buildInfoRow(
                                Icons.email_outlined,
                                user?.email ?? 'No email',
                              ),

                              // Phone
                              if (user?.noTelp != null &&
                                  user!.noTelp!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  Icons.phone_outlined,
                                  user.noTelp!,
                                ),
                              ],

                              // Address
                              if (user?.alamat != null &&
                                  user!.alamat!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  Icons.location_on_outlined,
                                  user.alamat!,
                                  maxLines: 2,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Avatar Circle
                        Positioned(
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: _buildProfileImage(user),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Menu Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Menu Items
                    _buildModernMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      subtitle: 'Track active and past orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernMenuItem(
                      icon: Icons.event_seat_outlined,
                      title: 'Reservations',
                      subtitle: 'Manage your table bookings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReservationHistoryPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildModernMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        ).then((_) => _refreshUserData());
                      },
                    ),

                    const SizedBox(height: 40),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _handleLogout,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.red.shade50,
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(user) {
    if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
      final String imageUrl = user!.profilePicture!.startsWith('http')
          ? '${user!.profilePicture}?t=${DateTime.now().millisecondsSinceEpoch}'
          : '${ApiConfig.imageBaseUrl}assets/images/profile/${user!.profilePicture}?t=${DateTime.now().millisecondsSinceEpoch}';

      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.white,
            child: _buildInitials(user?.nama ?? 'U'),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    } else {
      return Container(
        color: Colors.white,
        child: _buildInitials(user?.nama ?? 'U'),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _textSecondary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: _textSecondary,
                fontSize: 14,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(String name) {
    final initials = name.isNotEmpty
        ? name
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : 'U';
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _goldPrimary,
        ),
      ),
    );
  }

  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _bgPage,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _goldPrimary, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: _textSecondary.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: _textSecondary.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
