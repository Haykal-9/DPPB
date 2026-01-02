import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_session.dart';
import '../models/cart_item.dart';

class CartService {
  final String baseUrl = ApiConfig.baseUrl;

  /// Submit order to backend
  /// Returns: Map with 'orderId' and 'orderCode' if success, null if error
  Future<Map<String, dynamic>?> submitOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
    required String diningMode,
    String? tableNumber,
  }) async {
    try {
      final token = UserSession.instance.token;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Prepare items for API
      final orderItems = items.map((item) {
        return {
          'menu_id': item.product.id, // Use product ID
          'quantity': item.quantity,
          'price': item.product.harga,
          'subtotal': item.total,
          'notes': item.options, // Options as notes
        };
      }).toList();

      // Map payment method to ID (QRIS=1, Cashier=2)
      final paymentMethodId = paymentMethod == 'QRIS' ? 1 : 2;

      // Map dining mode to order type ID (Pickup=1, Dine In=2)
      final orderTypeId = diningMode == 'Pickup' ? 1 : 2;

      final requestBody = {
        'items': orderItems,
        'total_harga': totalAmount,
        'payment_method_id': paymentMethodId,
        'order_type_id': orderTypeId,
        if (tableNumber != null && tableNumber.isNotEmpty)
          'table_number': tableNumber,
      };

      print('📤 Submitting order to: ${baseUrl}checkout');
      print('📦 Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('${baseUrl}checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('📊 Parsed data: $data');

        // Handle different response structures
        if (data['data'] != null) {
          final orderData = data['data'];
          print('✅ Found data object: $orderData');
          return {
            'orderId': orderData['order_id'] ?? orderData['id'] ?? 0,
            'orderCode':
                orderData['invoice_number'] ??
                orderData['kode'] ??
                orderData['code'] ??
                'ORD-${DateTime.now().millisecondsSinceEpoch}',
            'message': data['message'] ?? 'Order created successfully',
          };
        } else if (data['order_id'] != null || data['id'] != null) {
          print('✅ Found direct id: ${data['order_id'] ?? data['id']}');
          return {
            'orderId': data['order_id'] ?? data['id'] ?? 0,
            'orderCode':
                data['invoice_number'] ??
                data['kode'] ??
                data['code'] ??
                'ORD-${DateTime.now().millisecondsSinceEpoch}',
            'message': data['message'] ?? 'Order created successfully',
          };
        }

        print('⚠️ No id found in response, generating fallback code');
        return {
          'orderId': 0,
          'orderCode': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
          'message': 'Order created',
        };
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      print('❌ Error submitting order: $e');
      return null;
    }
  }

  /// Clear cart after successful order
  Future<void> clearCart() async {
    // Implement this based on your cart management
    // If using provider/bloc, call the clear method
    // For now, this is a placeholder
    print('🗑️ Cart cleared');
  }
}
