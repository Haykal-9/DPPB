import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_session.dart';
import '../models/order.dart';

class OrderService {
  final String baseUrl = ApiConfig.baseUrl;

  // Get all orders for the current user
  Future<List<Order>> getOrders() async {
    try {
      final token = UserSession.instance.token;
      final user = UserSession.instance.currentUser;

      print('👤 Current user: ${user?.username} (ID: ${user?.id})');
      print('🔑 Token: ${token?.substring(0, 20)}...');

      if (token == null) {
        print('❌ No token found - user not logged in');
        throw Exception('Not authenticated');
      }

      // Use correct endpoint: /api/profile/orders
      print('📤 Fetching orders from: ${baseUrl}profile/orders');

      final response = await http.get(
        Uri.parse('${baseUrl}profile/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📥 Orders response status: ${response.statusCode}');
      print('📥 Orders response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('📊 Response keys: ${data.keys.toList()}');

        final List<dynamic> ordersJson = data['data'] ?? data['orders'] ?? [];
        print('✅ Found ${ordersJson.length} orders');

        if (ordersJson.isNotEmpty) {
          print('📦 First order sample: ${ordersJson[0]}');
        } else {
          print('⚠️ No orders returned from API');
        }

        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - token invalid');
        throw Exception('Unauthorized');
      } else {
        print('❌ Failed to load orders: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('❌ Error getting orders: $e');
      return [];
    }
  }

  // Cancel an order
  Future<String?> cancelOrder(int orderId) async {
    try {
      final token = UserSession.instance.token;
      if (token == null) {
        return 'Not authenticated';
      }

      // Use correct endpoint: /api/profile/orders/{id}/cancel
      final response = await http.post(
        Uri.parse('${baseUrl}profile/orders/$orderId/cancel'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return null; // Success
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? 'Failed to cancel order';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Get order detail
  Future<Order?> getOrderDetail(int orderId) async {
    try {
      final token = UserSession.instance.token;
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Use endpoint: /api/profile/orders/{id}
      final response = await http.get(
        Uri.parse('${baseUrl}profile/orders/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final orderJson = data['data'] ?? data['order'];
        return Order.fromJson(orderJson);
      }
      return null;
    } catch (e) {
      print('Error getting order detail: $e');
      return null;
    }
  }
}
