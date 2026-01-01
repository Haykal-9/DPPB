class Reservation {
  final int? id;
  final String? kode; // Reservation code from backend
  final String? tanggal; // Combined date+time from backend (Y-m-d H:i)
  final int? jumlahOrang; // Number of people from backend
  final String? pesan; // Message from backend

  // Legacy fields for create reservation
  final String? name;
  final String? phone;
  final String? date;
  final String? time;
  final int? pax;
  final String? notes;

  final String status;

  Reservation({
    this.id,
    this.kode,
    this.tanggal,
    this.jumlahOrang,
    this.pesan,
    this.name,
    this.phone,
    this.date,
    this.time,
    this.pax,
    this.notes,
    this.status = 'pending',
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      kode: json['kode'],
      tanggal: json['tanggal'],
      jumlahOrang: json['jumlah_orang'],
      pesan: json['pesan'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': name,
      'no_telp': phone,
      'tanggal_reservasi': date,
      'jam_reservasi': time,
      'jumlah_orang': pax?.toString() ?? jumlahOrang?.toString(),
      'message': notes ?? pesan,
    };
  }
}
