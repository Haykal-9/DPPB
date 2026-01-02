/// Model Product/Menu dari API Laravel
/// Response format dari GET /api/menus:
/// {
///   "id": 1,
///   "nama": "Cappuccino",
///   "harga": 25000,
///   "kategori": "Kopi",
///   "deskripsi": "Kopi dengan foam susu",
///   "status": "tersedia",
///   "image_url": "http://localhost:8000/foto/cappuccino.jpg",
///   "rating": 4.5,
///   "is_favorited": false
/// }
class ApiProduct {
  final int id;
  final String nama;
  final double harga;
  final String? kategoriNama;
  final String? deskripsi;
  final String? status;
  final String? gambar; // image_url from API
  final double rating;
  final bool isFavorited;

  ApiProduct({
    required this.id,
    required this.nama,
    required this.harga,
    this.kategoriNama,
    this.deskripsi,
    this.status,
    this.gambar,
    this.rating = 0.0,
    this.isFavorited = false,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    // Handle harga as String or number
    double parseHarga(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ApiProduct(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      harga: parseHarga(json['harga'] ?? json['price']),
      kategoriNama: json['kategori'],
      deskripsi: json['deskripsi'],
      status: json['status'],
      gambar: json['image_url'],
      rating: parseHarga(json['rating']),
      isFavorited: json['is_favorited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'kategori': kategoriNama,
      'deskripsi': deskripsi,
      'status': status,
      'image_url': gambar,
      'rating': rating,
      'is_favorited': isFavorited,
    };
  }

  /// Check if product is available
  bool get isAvailable => status?.toLowerCase() == 'tersedia';
}
