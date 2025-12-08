import '../models/product.dart';
import '../models/cart_item.dart';

/// Cart Items
final List<CartItem> mockCartItems = [
  CartItem(const Product('Classic Caffe Latte', 5.50, 'latte.jpg'), 1),
  CartItem(
    const Product('Iced Caramel Macchiato', 6.25, 'iced_caramel.jpg'),
    2,
  ),
  CartItem(const Product('Avocado & Egg Sandwich', 7.00, 'sandwich.jpg'), 1),
];
