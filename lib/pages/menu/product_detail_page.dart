import 'package:flutter/material.dart';
import '../../models/data.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

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
        title: Text(product.name.split(' ')[0]),
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
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: ${product.imagePath}');
                  print('Error: $error');
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
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Colors.brown),
                  ),
                  const SizedBox(height: 16),
                  Text(product.description),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Ditambahkan: ${product.name} (Size: $_selectedSize, Milk: $_selectedMilk, Sugar: $_selectedSugar)',
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
                  index < 4.5 ? Icons.star : Icons.star_border,
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
            // TODO: Navigate to ProductCommentsPage
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
