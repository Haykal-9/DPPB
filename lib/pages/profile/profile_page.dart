import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildLoyaltyRewards(),
            const SizedBox(height: 20),
            const Text(
              'Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSettingTiles(context),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(radius: 30, child: Text('JD')),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'john.doe@tapalkudacoffee.com',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoyaltyRewards() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loyalty Rewards',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re only 3 orders away from a free coffee!',
              style: TextStyle(color: Colors.brown.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTiles(BuildContext context) {
    return Column(
      children: [
        _buildSettingTile(
          context,
          'Edit Profile',
          'Update your personal details',
          Icons.person_outline,
        ),
        _buildSettingTile(
          context,
          'Vouchers',
          'You have 3 active vouchers',
          Icons.card_giftcard,
        ),
        _buildSettingTile(
          context,
          'Favorites',
          'Your 5 favorite coffee items',
          Icons.favorite_border,
        ),
        _buildSettingTile(
          context,
          'Order History',
          'See order History',
          Icons.history,
        ),
        _buildSettingTile(
          context,
          'Reservation History',
          'See Reservations History',
          Icons.table_chart_outlined,
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to respective pages
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigate to $title')));
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Logged Out!')));
        },
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
