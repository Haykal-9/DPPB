import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_session.dart';
import '../models/reservation.dart';

class ReservationService {
  Future<List<Reservation>> getReservations() async {
    final url = Uri.parse('${ApiConfig.baseUrl}reservations');
    final token = UserSession.instance.token;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load reservations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error getting reservations: $e');
      return [];
    }
  }

  Future<String?> createReservation(Reservation reservation) async {
    final url = Uri.parse('${ApiConfig.baseUrl}reservations');
    final token = UserSession.instance.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reservation.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return null; // Success (no error)
      } else {
        debugPrint('Failed to create reservation: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        try {
          final body = jsonDecode(response.body);
          String message =
              body['message'] ?? 'Failed with status ${response.statusCode}';

          // Parse Laravel validation errors
          if (body['errors'] != null && body['errors'] is Map) {
            final errors = body['errors'] as Map<String, dynamic>;
            final errorMessages = errors.values
                .map((e) => (e as List).join(', '))
                .join('\n');
            message += '\n$errorMessages';
          }

          return message;
        } catch (_) {
          return 'Failed with status ${response.statusCode}';
        }
      }
    } catch (e) {
      debugPrint('Error creating reservation: $e');
      return 'Connection error: $e';
    }
  }
}
