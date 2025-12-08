/// Kelas Model untuk Produk (PBO: Encapsulation)
class Product {
  final String name;
  final double price;
  final String imagePath;
  final String description;

  const Product(
    this.name,
    this.price,
    this.imagePath, {
    this.description = 'A rich, strong, and intense coffee experience.',
  });
}
