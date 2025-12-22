import 'package:flutter/material.dart';
import '../../utils/formatter.dart';
import '../main_wrapper.dart';

class PaymentSuccessPage extends StatelessWidget {
  final double totalAmount;
  final String paymentMethod;
  final String orderId;

  const PaymentSuccessPage({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    this.orderId = 'ORD-2023-8891',
  });

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color bgPage = Color(0xFFF9F5F0);
    const Color textPrimary = Color(0xFF2C2219);
    const Color textSecondary = Color(0xFF8D7B68);
    const Color goldPrimary = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: bgPage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: goldPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: goldPrimary,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textSecondary),
              ),
              const SizedBox(height: 32),

              // Receipt Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'TOTAL PAYMENT',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(totalAmount),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildReceiptRow(
                      'Payment Method',
                      paymentMethod,
                      textPrimary,
                      textSecondary,
                    ),
                    const SizedBox(height: 12),
                    _buildReceiptRow(
                      'Date',
                      'Dec 22, 2024 - 12:45 PM',
                      textPrimary,
                      textSecondary,
                    ),
                    const SizedBox(height: 12),
                    _buildReceiptRow(
                      'Transaction ID',
                      orderId,
                      textPrimary,
                      textSecondary,
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Back to Menu Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to MainWrapper -> Menu (Index 1)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MainWrapper(initialIndex: 1),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    Color primary,
    Color secondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
