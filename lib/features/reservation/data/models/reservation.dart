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
      'nama': name,
      'no_telp': phone,
      'tanggal_reservasi': date,
      'jam_reservasi': time,
      'jumlah_orang': pax.toString(),
      'notes': notes,
    };
  }
}
