import '../models/product.dart';

/// Menu Products
final List<Product> menuProducts = [
  const Product('Classic Espresso', 3.50, 'espresso.jpg'),
  const Product(
    'Creamy Cappuccino',
    4.25,
    'cappuccino.jpg',
    description:
        'A rich shot of espresso "stained" with a dollop of steamed milk foam. Strong and intense, yet incredibly smooth, offering a bold coffee experience with a creamy finish.',
  ),
  const Product('Vanilla Latte', 4.75, 'vanilla_latte.jpg'),
  const Product('Iced Caramel Macchiato', 5.50, 'iced_caramel.jpg'),
  const Product('Matcha Green Tea Latte', 5.00, 'matcha.jpg'),
  const Product('Blueberry Muffin', 3.00, 'muffin.jpg'),
  const Product('Americano', 3.00, 'americano.jpg'),
  const Product('Hot Chocolate', 4.00, 'hot_chocolate.jpg'),
];

/// Home Screen Products
const List<Product> mockProducts = [
  Product('Classic Espresso', 3.50, 'espresso.jpg'),
  Product('Creamy Latte', 4.20, 'latte.jpg'),
  Product('Rich Cappuccino', 4.00, 'cappuccino.jpg'),
  Product('Chocolate Mocha', 4.80, 'mocha.jpg'),
  Product('Bold Americano', 3.80, 'americano.jpg'),
  Product('Iced Caramel Frappe', 5.50, 'frappe.jpg'),
];
