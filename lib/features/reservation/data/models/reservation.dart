class Reservation {
  final String name;
  final String phone;
  final String date;
  final String time;
  final int pax;
  final String notes;

  Reservation({
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.pax,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phone, // Matches typical API naming
      'reservation_date': date,
      'reservation_time': time,
      'pax': pax.toString(),
      'notes': notes,
    };
  }
}
