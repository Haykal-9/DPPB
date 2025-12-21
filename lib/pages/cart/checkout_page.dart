import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../utils/formatter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Credit/Debit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummary(),
              const Divider(height: 30),
              _buildPaymentMethod(),
              if (selectedPaymentMethod == 'QR Pay') ...[
                const SizedBox(height: 20),
                Center(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Scan QRIS untuk pembayaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          QrImageView(
                            data:
                                'https://contoh-qris.com/1234567890', // Ganti dengan data QRIS asli jika ada
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const Divider(height: 30),
              _buildFulfillmentOptions(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildTotalAndPlaceOrder(context),
    );
  }

  Widget _buildRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildRow('Subtotal', formatRupiah(91000.0)),
        _buildRow(
          'Discounts',
          '-${formatRupiah(5000.0)}',
          valueColor: Colors.red,
        ),
        _buildRow('Fulfillment', 'Gratis'),
        _buildRow('Estimated Taxes', formatRupiah(0.0)),
        const Divider(height: 20, thickness: 1.5),
        _buildRow('Total', formatRupiah(86000.0), valueColor: Colors.brown),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildOptionCard(
          Icons.credit_card,
          'Credit/Debit Card',
          isSelected: selectedPaymentMethod == 'Credit/Debit Card',
          onTap: () =>
              setState(() => selectedPaymentMethod = 'Credit/Debit Card'),
        ),
        _buildOptionCard(
          Icons.wallet,
          'E-Wallet',
          isSelected: selectedPaymentMethod == 'E-Wallet',
          onTap: () => setState(() => selectedPaymentMethod = 'E-Wallet'),
        ),
        _buildOptionCard(
          Icons.qr_code,
          'QR Pay',
          isSelected: selectedPaymentMethod == 'QR Pay',
          onTap: () => setState(() => selectedPaymentMethod = 'QR Pay'),
        ),
      ],
    );
  }

  Widget _buildFulfillmentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fulfillment Options',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildOptionCard(
          Icons.delivery_dining,
          'Delivery',
          isSelected: true,
          onTap: () {},
        ),
        _buildOptionCard(
          Icons.location_on,
          '123 Coffee Lane, Central City, 1000',
          isSelected: false,
          onTap: () {},
        ),
        _buildOptionCard(
          Icons.store,
          'Pickup',
          isSelected: false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    IconData icon,
    String title, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? Colors.brown : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.brown : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.brown : Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTotalAndPlaceOrder(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total: (3 items)',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                formatRupiah(86000.0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to Order Tracking
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Place Order', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
