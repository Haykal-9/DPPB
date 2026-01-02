import 'package:flutter/material.dart';
import '../../home/data/models/api_product.dart';
import 'comments_page.dart';
import '../../../../core/utils/formatter.dart';
import '../../cart/data/datasources/cart_data.dart';
import '../../cart/data/models/cart_item.dart';
import '../../cart/pages/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final ApiProduct product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _selectedSize = 'Medium';
  String _selectedMilk = 'Whole Milk';
  String _selectedSugar = 'Regular Sugar';

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nama.split(' ')[0]),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Image.network(
                product.gambar ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading image: ${product.gambar}');
                  debugPrint('Error: $error');
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Error loading image',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nama,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(product.harga),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Colors.brown),
                  ),
                  const SizedBox(height: 16),
                  Text(product.deskripsi ?? 'Deskripsi tidak tersedia'),
                  const SizedBox(height: 20),
                  _buildCommentSection(context),
                  const SizedBox(height: 20),
                  _buildOptionSelection(
                    'Size',
                    ['Small', 'Medium', 'Large'],
                    _selectedSize,
                    (value) {
                      setState(() {
                        _selectedSize = value;
                      });
                    },
                  ),
                  _buildOptionSelection(
                    'Milk Type',
                    ['Whole Milk', 'Almond Milk', 'Oat Milk', 'Soy Milk'],
                    _selectedMilk,
                    (value) {
                      setState(() {
                        _selectedMilk = value;
                      });
                    },
                  ),
                  _buildOptionSelection(
                    'Sugar Level',
                    ['No Sugar', 'Light Sugar', 'Regular Sugar', 'Extra Sugar'],
                    _selectedSugar,
                    (value) {
                      setState(() {
                        _selectedSugar = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Create options string
            final options = '$_selectedSize, $_selectedMilk, $_selectedSugar';

            // Check if item already exists in cart
            final existingIndex = mockCartItems.indexWhere(
              (item) =>
                  item.product.nama == product.nama && item.options == options,
            );

            if (existingIndex != -1) {
              // Item exists, increase quantity
              mockCartItems[existingIndex].quantity++;
            } else {
              // Add new item to cart
              mockCartItems.add(CartItem(product, 1, options: options));
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.nama} added to cart!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'VIEW CART',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < widget.product.rating
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CommentsPage(productName: widget.product.nama),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('See Comment..'),
        ),
      ],
    );
  }

  Widget _buildOptionSelection(
    String title,
    List<String> options,
    String selectedOption,
    ValueChanged<String> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 10.0,
          runSpacing: 8.0,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
              selectedColor: Colors.brown,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              side: BorderSide(
                color: isSelected ? Colors.brown : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
