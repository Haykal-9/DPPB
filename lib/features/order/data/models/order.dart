class Order {
  final int? id;
  final String? kode; // Order code from backend
  final String? tanggal; // Date and time from backend (Y-m-d H:i:s)
  final double? totalHarga; // Total price
  final String? itemsSummary; // Summary of items ordered
  final int? jumlahItem; // Number of items
  final String
  status; // Order status: 'pending', 'processing', 'completed', 'cancelled'

  Order({
    this.id,
    this.kode,
    this.tanggal,
    this.totalHarga,
    this.itemsSummary,
    this.jumlahItem,
    this.status = 'pending',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? json['order_id'],
      kode: json['invoice'] ?? json['invoice_number'] ?? json['kode'],
      tanggal: json['tanggal'] ?? json['order_date'] ?? json['created_at'],
      totalHarga: json['total'] != null
          ? double.tryParse(json['total'].toString())
          : (json['total_harga'] != null
                ? double.tryParse(json['total_harga'].toString())
                : null),
      itemsSummary: json['items_summary'],
      jumlahItem: json['jumlah_item'] ?? json['item_count'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'tanggal': tanggal,
      'total_harga': totalHarga,
      'items_summary': itemsSummary,
      'jumlah_item': jumlahItem,
      'status': status,
    };
  }
}
