// lib/pages/profile/reservation_history_page.dart
import 'package:flutter/material.dart';

// Mock data untuk reservation history
final List<Map<String, dynamic>> mockReservationHistory = [
  {
    'id': 'RES001',
    'date': '2024-12-10',
    'time': '14:30',
    'people': 2,
    'status': 'confirmed',
  },
  {
    'id': 'RES002',
    'date': '2024-12-08',
    'time': '19:00',
    'people': 4,
    'status': 'confirmed',
  },
  {
    'id': 'RES003',
    'date': '2024-12-05',
    'time': '15:45',
    'people': 3,
    'status': 'cancelled',
  },
];

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockReservationHistory.length,
        itemBuilder: (context, index) {
          final reservation = mockReservationHistory[index];
          return _buildReservationCard(reservation);
        },
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    Color statusColor;
    switch (reservation['status']) {
      case 'confirmed':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.amber;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reservation['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text('Booking ID: ${reservation['id']}'),
              ],
            ),
            const Divider(),
            _buildDetailRow(Icons.calendar_today, reservation['date']),
            _buildDetailRow(Icons.access_time, reservation['time']),
            _buildDetailRow(Icons.people, '${reservation['people']} People'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
