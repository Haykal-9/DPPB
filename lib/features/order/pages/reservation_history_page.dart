import 'package:flutter/material.dart';
import '../../reservation/data/datasources/reservation_data.dart';

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Constants
    const Color bgPage = Color(0xFFF9F5F0);
    const Color textPrimary = Color(0xFF2C2219);
    const Color textSecondary = Color(0xFF8D7B68);
    const Color goldPrimary = Color(0xFFD4AF37);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgPage,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: bgPage,
                elevation: 0,
                pinned: true,
                leading: const BackButton(color: textPrimary),
                expandedHeight: 160,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(60, 0, 24, 60),
                  title: const Text(
                    'Reservations',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: goldPrimary,
                  labelColor: textPrimary,
                  unselectedLabelColor: textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildReservationList(
                mockUpcomingReservations,
                textPrimary,
                textSecondary,
                goldPrimary,
              ),
              _buildReservationList(
                mockHistoryReservations,
                textPrimary,
                textSecondary,
                goldPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationList(
    List<Map<String, dynamic>> reservations,
    Color textPrimary,
    Color textSecondary,
    Color goldPrimary,
  ) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No reservations found',
              style: TextStyle(color: textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final res = reservations[index];
        final status = (res['status'] as String?) ?? 'Pending';

        Color statusColor;
        Color statusBg;

        switch (status) {
          case 'Confirmed':
            statusColor = Colors.green;
            statusBg = Colors.green.withValues(alpha: 0.1);
            break;
          case 'Pending':
            statusColor = Colors.orange;
            statusBg = Colors.orange.withValues(alpha: 0.1);
            break;
          case 'Cancelled':
            statusColor = Colors.red;
            statusBg = Colors.red.withValues(alpha: 0.1);
            break;
          default: // Completed
            statusColor = Colors.grey;
            statusBg = Colors.black.withValues(alpha: 0.05);
        }

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    res['id'] ?? '',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Date Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: goldPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          (res['date'] as String).split(' ')[0], // Date num
                          style: TextStyle(
                            color: goldPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          (res['date'] as String).split(' ')[1], // Month
                          style: TextStyle(color: goldPrimary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          res['location'] ?? 'Table',
                          style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              res['time'] ?? '',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.people, size: 14, color: textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${res['pax']} People',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
