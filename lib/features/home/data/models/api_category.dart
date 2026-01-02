import 'package:flutter/material.dart';

/// Model Category dari API Laravel
class ApiCategory {
  final int id;
  final String nama;
  final String? deskripsi;
  final IconData icon;

  ApiCategory({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.icon = Icons.category,
  });

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? json['name'] ?? '',
      deskripsi: json['deskripsi'] ?? json['description'],
      icon: _getIconFromName(json['nama'] ?? json['name'] ?? ''),
    );
  }

  /// Map category name to appropriate icon
  static IconData _getIconFromName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('coffee') || lowerName.contains('kopi')) {
      return Icons.coffee;
    } else if (lowerName.contains('non-coffee') ||
        lowerName.contains('non kopi')) {
      return Icons.local_drink;
    } else if (lowerName.contains('food') || lowerName.contains('makanan')) {
      return Icons.restaurant;
    } else if (lowerName.contains('snack')) {
      return Icons.fastfood;
    } else if (lowerName.contains('dessert')) {
      return Icons.cake;
    }
    return Icons.category;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'deskripsi': deskripsi};
  }
}
