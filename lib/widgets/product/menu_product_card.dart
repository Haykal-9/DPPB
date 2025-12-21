import 'package:flutter/material.dart';
import '../../models/data.dart';
import '../../pages/menu/product_detail_page.dart';
import '../../pages/cart/checkout_page.dart';
import '../../utils/formatter.dart';

class MenuProductCard extends StatelessWidget {
  final Product product;

  const MenuProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
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
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ...info produk lain di sini (nama, harga, dst)...
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            final snackBar = SnackBar(
                              content: Text(
                                '${product.name} ditambahkan ke keranjang.',
                              ),
                              duration: const Duration(milliseconds: 1500),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color.fromRGBO(121, 85, 72, 1),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 145, 94, 71),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
