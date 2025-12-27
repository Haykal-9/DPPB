/// Model untuk menyimpan data user yang sedang login
class User {
  final int id;
  final String username;
  final String nama;
  final String email;
  final String? role;
  final String? noTelp;
  final String? gender;
  final String? alamat;
  final String? profilePicture;

  User({
    required this.id,
    required this.username,
    required this.nama,
    required this.email,
    this.role,
    this.noTelp,
    this.gender,
    this.alamat,
    this.profilePicture,
  });

  /// Factory dari JSON response API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      noTelp: json['no_telp'],
      gender: json['gender'],
      alamat: json['alamat'],
      profilePicture: json['profile_picture'],
    );
  }

  /// Convert ke Map untuk disimpan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nama': nama,
      'email': email,
      'role': role,
      'no_telp': noTelp,
      'gender': gender,
      'alamat': alamat,
      'profile_picture': profilePicture,
    };
  }
}
