import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_session.dart';
import '../models/api_product.dart';
import '../models/api_category.dart';

class HomeService {
  /// Fetch semua menu dari API
  /// Endpoint: GET /api/menus
  Future<List<ApiProduct>> getMenus({String? category, String? search}) async {
    String url = '${ApiConfig.baseUrl}menus';

    // Add query parameters
    List<String> params = [];
    if (category != null && category != 'all') {
      params.add('category=$category');
    }
    if (search != null && search.isNotEmpty) {
      params.add('search=$search');
    }
    params.add('available_only=1'); // Only show available items

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    final token = UserSession.instance.token;

    try {
      debugPrint('Fetching menus from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Menus API Status: ${response.statusCode}');
      debugPrint('Menus API Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        if (body['success'] == true) {
          final List<dynamic> data = body['data'] ?? [];
          return data.map((json) => ApiProduct.fromJson(json)).toList();
        }
        return [];
      } else {
        debugPrint('Failed to load menus: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting menus: $e');
      return [];
    }
  }

  /// Fetch menu untuk home (featured/semua)
  Future<List<ApiProduct>> getProducts({int? limit, bool? featured}) async {
    final menus = await getMenus();

    // Limit results if specified
    if (limit != null && menus.length > limit) {
      return menus.take(limit).toList();
    }
    return menus;
  }

  /// Fetch produk terbaru (same as getMenus for now)
  Future<List<ApiProduct>> getLatestProducts({int limit = 6}) async {
    final menus = await getMenus();

    // Take last N items as "latest"
    if (menus.length > limit) {
      return menus.reversed.take(limit).toList();
    }
    return menus;
  }

  /// Get unique categories from menus
  Future<List<ApiCategory>> getCategories() async {
    final menus = await getMenus();

    // Extract unique categories from menus
    final Map<String, ApiCategory> categoryMap = {};
    int id = 1;

    for (final menu in menus) {
      if (menu.kategoriNama != null &&
          !categoryMap.containsKey(menu.kategoriNama)) {
        categoryMap[menu.kategoriNama!] = ApiCategory(
          id: id++,
          nama: menu.kategoriNama!,
        );
      }
    }

    return categoryMap.values.toList();
  }

  /// Fetch produk berdasarkan kategori
  Future<List<ApiProduct>> getProductsByCategory(String category) async {
    return await getMenus(category: category);
  }
}
