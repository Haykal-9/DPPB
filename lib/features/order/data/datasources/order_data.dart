import 'package:flutter/material.dart';
import '../models/order_status.dart';

/// Order Tracking Steps
final List<OrderStatus> mockOrderSteps = [
  const OrderStatus(
    'Processing Order',
    'Order received and being prepared.',
    Icons.hourglass_empty,
    true,
  ),
  const OrderStatus(
    'Brewing Coffee',
    'Your delicious coffee is being freshly brewed.',
    Icons.coffee,
    true,
  ),
  const OrderStatus(
    'Ready for Pickup',
    'Your order is ready at the counter!',
    Icons.check_circle_outline,
    false,
  ),
];
