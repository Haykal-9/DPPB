import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../models/reservation.dart';

class ReservationService {
  Future<bool> createReservation(Reservation reservation) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/reservations');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(reservation.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to create reservation: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error creating reservation: $e');
      return false;
    }
  }
}
