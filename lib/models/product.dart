/// Kelas Model untuk Produk (PBO: Encapsulation)
class Product {
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String? category; // Nullable to handle legacy data

  const Product(
    this.name,
    this.price,
    this.imagePath, {
    this.description = 'A rich, strong, and intense coffee experience.',
    this.category = 'Coffee',
  });
}
