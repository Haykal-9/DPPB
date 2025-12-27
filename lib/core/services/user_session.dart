import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Global session manager untuk menyimpan data user yang sedang login
/// Bisa diakses dari mana saja di app menggunakan UserSession.instance
class UserSession {
  // Singleton instance
  static final UserSession _instance = UserSession._internal();
  static UserSession get instance => _instance;

  UserSession._internal();

  // Keys untuk SharedPreferences
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';

  // In-memory cache
  User? _currentUser;
  String? _token;

  /// User yang sedang login (null jika belum login)
  User? get currentUser => _currentUser;

  /// Token auth (null jika belum login)
  String? get token => _token;

  /// Cek apakah user sudah login
  bool get isLoggedIn => _token != null && _currentUser != null;

  /// Inisialisasi session dari SharedPreferences (panggil di main.dart)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString(_keyToken);
    final userJson = prefs.getString(_keyUser);

    if (userJson != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userJson));
      } catch (e) {
        debugPrint('Error parsing stored user: $e');
        _currentUser = null;
      }
    }

    debugPrint('UserSession initialized: isLoggedIn=$isLoggedIn');
  }

  /// Simpan data login (panggil setelah login berhasil)
  Future<void> saveSession({required String token, required User user}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));

    _token = token;
    _currentUser = user;

    debugPrint('Session saved: ${user.username}');
  }

  /// Update data user (tanpa mengubah token)
  Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    _currentUser = user;
  }

  /// Hapus session (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);

    _token = null;
    _currentUser = null;

    debugPrint('Session cleared');
  }
}
