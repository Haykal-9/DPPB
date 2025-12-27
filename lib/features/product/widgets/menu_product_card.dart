import 'package:flutter/material.dart';
import '../../../../core/models/data.dart';
import '../pages/product_detail_page.dart';
import '../../../../core/utils/formatter.dart';

class MenuProductCard extends StatelessWidget {
  final Product product;

  const MenuProductCard({super.key, required this.product});

  // Theme Colors
  final Color _goldPrimary = const Color(0xFFD4AF37);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);

  @override
  Widget build(BuildContext context) {
    // Generate safe values for missing model fields
    final String heroTag = 'product_${product.name.replaceAll(' ', '_')}';
    const String rating = "4.8"; // Mock rating

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _textPrimary.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Hero(
                      tag: heroTag,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: _textSecondary.withValues(alpha: 0.1),
                          child: Icon(Icons.coffee, color: _textSecondary),
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge (Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: _goldPrimary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category ?? 'Coffee',
                          style: TextStyle(
                            fontSize: 11,
                            color: _textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatRupiah(product.price),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _goldPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _textPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
