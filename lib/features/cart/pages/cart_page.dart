import 'package:flutter/material.dart';
import '../data/datasources/cart_data.dart';
import '../data/models/cart_item.dart';
import './checkout_page.dart';
import '../../../../core/utils/formatter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Theme Constants
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);
  final Color _goldPrimary = const Color(0xFFD4AF37);

  // Constants
  double get subtotal {
    return mockCartItems.fold(0, (sum, item) => sum + item.total);
  }

  final double deliveryFee = 0.00; // No delivery fee for pickup
  final double discount = 0.00;
  double get total => subtotal + deliveryFee + discount;

  @override
  void initState() {
    super.initState();
    // Force rebuild when returning to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if cart is empty
    final bool isCartEmpty = mockCartItems.isEmpty;

    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        bottom: false,
        child: isCartEmpty
            ? _buildEmptyCart()
            : Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // 1. Large Header
                        SliverAppBar(
                          backgroundColor: _bgPage,
                          expandedHeight: 120,
                          pinned: true,
                          elevation: 0,
                          leading: const BackButton(color: Color(0xFF2C2219)),
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: const EdgeInsets.only(
                              left: 60, // Increased to avoid BackButton overlap
                              bottom: 16,
                            ),
                            title: Text(
                              'My Order',
                              style: TextStyle(
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.bold,
                                color: _textPrimary,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),

                        // 2. Cart Items List with Swipe-to-Remove
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final item =
                                  mockCartItems[index]; // Use mock data
                              return _buildDismissibleItem(item);
                            }, childCount: mockCartItems.length),
                          ),
                        ),

                        // 3. Promo Code Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                            child: _buildPromoSection(),
                          ),
                        ),

                        // 3.5 Order Note
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: _buildNoteSection(),
                          ),
                        ),

                        // 4. Receipt Summary
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                            child: _buildReceiptSection(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 5. Bottom Checkout Area
                  _buildBottomBar(),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const BackButton(color: Color(0xFF2C2219)),
              Expanded(
                child: Text(
                  'My Order',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        // Empty state content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: _textSecondary.withOpacity(0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your Cart is Empty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add items to get started',
                  style: TextStyle(fontSize: 16, color: _textSecondary),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _goldPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Browse Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDismissibleItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key('${item.product.nama}_${item.options}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            mockCartItems.remove(item);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.product.nama} removed from cart'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _textPrimary.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item.product.gambar ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.nama,
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.options,
                      style: TextStyle(color: _textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatRupiah(item.product.harga),
                          style: TextStyle(
                            color: _goldPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        // Quantity Stepper
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F5F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildQtyIcon(Icons.remove, () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  } else {
                                    // Remove item if quantity becomes 0
                                    mockCartItems.remove(item);
                                  }
                                });
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _buildQtyIcon(Icons.add, () {
                                setState(() {
                                  item.quantity++;
                                });
                              }),
                            ],
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
      ),
    );
  }

  Widget _buildQtyIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 16, color: _textPrimary),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _goldPrimary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            color: _goldPrimary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add Promo Code',
                hintStyle: TextStyle(
                  color: _textSecondary.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(color: _textPrimary),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Apply',
              style: TextStyle(
                color: _goldPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _textSecondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note_rounded, color: _textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Order Notes',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 2,
            style: TextStyle(color: _textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Add a note for the barista (e.g. Less Sugar)...',
              hintStyle: TextStyle(
                color: _textSecondary.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildReceiptRow('Subtotal', formatRupiah(subtotal)),
        const SizedBox(height: 12),
        _buildReceiptRow('Delivery Fee', formatRupiah(deliveryFee)),
        const SizedBox(height: 12),
        _buildReceiptRow('Discount', formatRupiah(discount), isDiscount: true),
        const SizedBox(height: 20),
        // Dashed Divider
        Row(
          children: List.generate(
            30,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: 1,
                  color: _textSecondary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            Text(
              formatRupiah(total),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _goldPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: _textSecondary, fontSize: 15)),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red[400] : _textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Checkout Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_right_alt_rounded,
                  color: _goldPrimary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
