/// Kelas Model untuk Produk (PBO: Encapsulation)
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String? category; // Nullable to handle legacy data

  const Product(
    this.id,
    this.name,
    this.price,
    this.imageUrl, {
    this.description = 'A rich, strong, and intense coffee experience.',
    this.category = 'Coffee',
  });
}
