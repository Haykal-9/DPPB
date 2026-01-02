import '../../../home/data/models/api_product.dart';

/// Model untuk Item di Keranjang
class CartItem {
  final ApiProduct product;
  int quantity;
  final String options;
  double get total => product.harga * quantity;

  CartItem(
    this.product,
    this.quantity, {
    this.options = 'Reg Size, Whole Milk',
  });
}
