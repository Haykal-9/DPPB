import 'package:flutter/material.dart';

/// Model untuk Status Pesanan
class OrderStatus {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;

  const OrderStatus(this.title, this.subtitle, this.icon, this.isCompleted);
}
