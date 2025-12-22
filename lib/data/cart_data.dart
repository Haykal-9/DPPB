import '../models/product.dart';
import '../models/cart_item.dart';

/// Cart Items
final List<CartItem> mockCartItems = [
  CartItem(
    const Product(
      'Latte',
      25000.0,
      'assets/images/kopi/Latte.jpg',
      category: 'Coffee',
    ),
    1,
  ),
  CartItem(
    const Product(
      'Cappucino',
      22000.0,
      'assets/images/kopi/CAPPUCINO.jpg',
      category: 'Coffee',
    ),
    2,
  ),
  CartItem(
    const Product(
      'ES Kopi Susu',
      22000.0,
      'assets/images/kopi/ES KOPI SUSU.jpg',
      category: 'Coffee',
    ),
    1,
  ),
];
