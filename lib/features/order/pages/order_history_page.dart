import 'package:flutter/material.dart';
import '../data/datasources/history_data.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Constants
    const Color bgPage = Color(0xFFF9F5F0);
    const Color textPrimary = Color(0xFF2C2219);
    const Color textSecondary = Color(0xFF8D7B68);
    const Color goldPrimary = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: bgPage,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: bgPage,
            elevation: 0,
            pinned: true,
            leading: const BackButton(color: textPrimary),
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(60, 0, 24, 16),
              title: const Text(
                'My Orders',
                style: TextStyle(
                  fontFamily: 'Serif',
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final order = mockOrderHistory[index];
                return _buildOrderCard(
                  order,
                  textPrimary,
                  textSecondary,
                  goldPrimary,
                  context,
                );
              }, childCount: mockOrderHistory.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
    Color textPrimary,
    Color textSecondary,
    Color goldPrimary,
    BuildContext context,
  ) {
    final status = (order['status'] as String?) ?? 'Processing';
    final isCompleted = status == 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['date'] ?? '',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Content
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: goldPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long, color: goldPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['id'] ?? '',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['items_summary'] ?? '',
                      style: TextStyle(color: textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Footer: Total & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Payment',
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['total'] ?? '',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reorder functionality coming soon!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minimumSize: const Size(0, 40),
                ),
                child: const Text(
                  'Reorder',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
