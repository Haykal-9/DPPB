import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/formatter.dart';
import 'payment_success_page.dart';
import '../data/services/cart_service.dart';
import '../data/datasources/cart_data.dart';
import '../data/models/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Theme Constants
  final Color _bgPage = const Color(0xFFF9F5F0);
  final Color _textPrimary = const Color(0xFF2C2219);
  final Color _textSecondary = const Color(0xFF8D7B68);
  final Color _goldPrimary = const Color(0xFFD4AF37);

  String selectedPaymentMethod = 'QRIS';
  String selectedDiningMode = 'Pickup'; // 'Pickup' or 'Dine In'

  final TextEditingController _tableController = TextEditingController();
  final CartService _cartService = CartService();
  bool _isSubmitting = false;

  // Calculate total from cart
  double get totalAmount {
    return mockCartItems.fold(0, (sum, item) => sum + item.total);
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Header
                  SliverAppBar(
                    backgroundColor: _bgPage,
                    elevation: 0,
                    pinned: true,
                    leading: const BackButton(color: Color(0xFF2C2219)),
                    centerTitle: true,
                    title: Text(
                      'Checkout',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  // 2. Dining Mode Selector
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: _buildDiningModeSelector(),
                    ),
                  ),

                  // 3. Fulfillment Details
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: selectedDiningMode == 'Pickup'
                          ? _buildStoreLocation()
                          : _buildTableInput(),
                    ),
                  ),

                  // 4. Payment Method
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontFamily: 'Serif',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentSelector(),
                          const SizedBox(height: 24),

                          // QRIS Display
                          if (selectedPaymentMethod == 'QRIS')
                            _buildQRISSection(),
                          // Cashier Display
                          if (selectedPaymentMethod == 'Cashier')
                            _buildCashierSection(),
                        ],
                      ),
                    ),
                  ),

                  // 5. Order Summary
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                      child: _buildOrderSummary(),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Bottom Action
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDiningModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _textSecondary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          _buildModeButton('Pickup', Icons.storefront_rounded),
          _buildModeButton('Dine In', Icons.table_restaurant_rounded),
        ],
      ),
    );
  }

  Widget _buildModeButton(String mode, IconData icon) {
    final isSelected = selectedDiningMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDiningMode = mode;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? _goldPrimary : _textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                mode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick Up at',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _textPrimary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: _goldPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Morning Roast Coffee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jl. Telekomunikasi No. 1, Bandung Tech Park',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Table Number',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _goldPrimary.withValues(alpha: 0.5)),
          ),
          child: TextField(
            controller: _tableController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              icon: Icon(Icons.table_bar, color: _goldPrimary),
              hintText: 'Enter table number (e.g. 12)',
              hintStyle: TextStyle(
                color: _textSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSelector() {
    final methods = [
      {'icon': Icons.qr_code_2, 'label': 'QRIS'},
      {'icon': Icons.point_of_sale, 'label': 'Cashier'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: methods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final method = methods[index];
          final isSelected = selectedPaymentMethod == method['label'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPaymentMethod = method['label'] as String;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? _textPrimary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? _textPrimary
                      : Colors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _textPrimary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    method['icon'] as IconData,
                    color: isSelected ? _goldPrimary : _textSecondary,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    method['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQRISSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _goldPrimary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner, color: _goldPrimary),
                const SizedBox(width: 8),
                Text(
                  'Scan to Pay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: 'https://example.com/payment',
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              'Waiting for payment...',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashierSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _goldPrimary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.storefront_rounded, color: _goldPrimary, size: 48),
            const SizedBox(height: 16),
            Text(
              'Pay at Cashier',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textPrimary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please show your order details to the cashier to complete payment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payment',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              Text(
                formatRupiah(totalAmount),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Display actual cart items
          ...mockCartItems.map(
            (item) => _buildSummaryItem(
              item.product.nama,
              item.quantity,
              item.product.harga,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: _textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedDiningMode == 'Pickup'
                      ? 'Please pick up at counter when ready.'
                      : 'We will serve to your table.',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String name, int qty, double price) {
    final subtotal = price * qty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${qty}x $name',
            style: TextStyle(color: _textSecondary, fontSize: 14),
          ),
          Text(
            formatRupiah(subtotal),
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmitOrder() async {
    // Validate table number for Dine In
    if (selectedDiningMode == 'Dine In' &&
        _tableController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter table number'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Submit order to backend
      final result = await _cartService.submitOrder(
        items: mockCartItems,
        totalAmount: totalAmount,
        paymentMethod: selectedPaymentMethod,
        diningMode: selectedDiningMode,
        tableNumber: selectedDiningMode == 'Dine In'
            ? _tableController.text.trim()
            : null,
      );

      if (!mounted) return;

      if (result != null) {
        // Success - Save order data before clearing cart
        final List<CartItem> orderItems = List<CartItem>.from(mockCartItems);
        final orderTotal = totalAmount;
        final orderPayment = selectedPaymentMethod;
        final orderMode = selectedDiningMode;
        final orderTable = selectedDiningMode == 'Dine In'
            ? _tableController.text.trim()
            : null;

        // Clear cart
        mockCartItems.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              totalAmount: orderTotal,
              paymentMethod: orderPayment,
              orderId: result['orderCode'] ?? 'N/A',
              items: orderItems,
              diningMode: orderMode,
              tableNumber: orderTable,
            ),
          ),
        );
      } else {
        // Error - Show detailed error message
        print('❌ Order submission failed - result is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to create order. Check console for details.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildBottomBar(BuildContext context) {
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
            onPressed: _isSubmitting ? null : _handleSubmitOrder,
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
                if (_isSubmitting) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Processing...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.lock_outline, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Pay ${formatRupiah(totalAmount)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
