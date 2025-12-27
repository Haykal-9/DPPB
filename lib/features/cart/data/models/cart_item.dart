import '../../../product/data/models/product.dart';

/// Model untuk Item di Keranjang
class CartItem {
  final Product product;
  int quantity;
  final String options;
  double get total => product.price * quantity;

  CartItem(
    this.product,
    this.quantity, {
    this.options = 'Reg Size, Whole Milk',
  });
}
