/// Order History Mock Data
final List<Map<String, dynamic>> mockOrderHistory = [
  {
    'id': '001',
    'date': '2024-12-05',
    'items_summary': '2x Espresso, 1x Cappuccino',
    'total': 'Rp 75.000',
  },
  {
    'id': '002',
    'date': '2024-12-03',
    'items_summary': '1x Latte, 1x Croissant',
    'total': 'Rp 65.000',
  },
  {
    'id': '003',
    'date': '2024-12-01',
    'items_summary': '3x Americano',
    'total': 'Rp 60.000',
  },
];

/// Reservation History Mock Data
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
