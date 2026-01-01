import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/user_session.dart';

/// Model untuk data gender
class Gender {
  final int id;
  final String name;

  Gender({required this.id, required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(id: json['id'], name: json['name']);
  }
}

class AuthService {
  /// Get daftar gender untuk form register
  Future<List<Gender>> getGenders() async {
    final url = Uri.parse('${ApiConfig.baseUrl}genders');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List genders = data['data'];
        return genders.map((g) => Gender.fromJson(g)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching genders: $e');
      return [];
    }
  }

  /// Login dengan username ATAU email
  /// Return true jika sukses, false jika gagal
  Future<bool> login(String loginInput, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'login': loginInput, // bisa username atau email
          'password': password,
        }),
      );

      debugPrint('Login response status: ${response.statusCode}');
      debugPrint('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Simpan session
        final token = data['data']['token'];
        final userData = data['data']['user'];
        final user = User.fromJson(userData);

        await UserSession.instance.saveSession(token: token, user: user);

        return true;
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('Login failed: ${errorData['message'] ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  /// Register user baru dengan semua field
  /// Return true jika sukses, false jika gagal
  Future<bool> register({
    required String username,
    required String nama,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? noTelp,
    int? genderId,
    String? alamat,
    XFile? profilePicture,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}register');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';

      // Add text fields
      request.fields['username'] = username;
      request.fields['nama'] = nama;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['password_confirmation'] = passwordConfirmation;

      if (noTelp != null && noTelp.isNotEmpty) {
        request.fields['no_telp'] = noTelp;
      }
      if (genderId != null) {
        request.fields['gender_id'] = genderId.toString();
      }
      if (alamat != null && alamat.isNotEmpty) {
        request.fields['alamat'] = alamat;
      }

      // Add profile picture if exists
      if (profilePicture != null) {
        if (kIsWeb) {
          final bytes = await profilePicture.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_picture',
              bytes,
              filename: profilePicture.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_picture',
              profilePicture.path,
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Register response status: ${response.statusCode}');
      debugPrint('Register response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(
          'Register failed: ${errorData['message'] ?? 'Unknown error'}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error during register: $e');
      return false;
    }
  }

  /// Logout user
  Future<bool> logout() async {
    final token = UserSession.instance.token;
    if (token == null) return true;

    final url = Uri.parse('${ApiConfig.baseUrl}logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Clear session baik berhasil atau tidak
      await UserSession.instance.clearSession();

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Tetap clear session meski error
      await UserSession.instance.clearSession();
      return false;
    }
  }

  /// Fetch data user terbaru dari API /me
  Future<User?> fetchCurrentUser() async {
    final token = UserSession.instance.token;
    if (token == null) return null;

    final url = Uri.parse('${ApiConfig.baseUrl}me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['data']);

        // Update session dengan data terbaru
        await UserSession.instance.updateUser(user);

        debugPrint('Fetched User Profile Picture: ${user.profilePicture}');

        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  Future<String?> updateProfile({
    required String nama,
    required String username, // Username harus dikirim
    required String email, // Email harus dikirim
    String? noTelp,
    String? alamat,
    XFile? profilePicture,
  }) async {
    final token = UserSession.instance.token;
    if (token == null) return "Session expired";

    final url = Uri.parse('${ApiConfig.baseUrl}profile');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Method spoofing untuk Laravel
      request.fields['_method'] = 'PUT';

      request.fields['nama'] = nama;
      request.fields['username'] = username;
      request.fields['email'] = email;

      if (noTelp != null) {
        request.fields['no_telp'] = noTelp;
      }
      if (alamat != null) {
        request.fields['alamat'] = alamat;
      }

      if (profilePicture != null) {
        // Determine MIME type
        final String extension = profilePicture.name
            .split('.')
            .last
            .toLowerCase();
        MediaType contentType;

        switch (extension) {
          case 'jpg':
          case 'jpeg':
            contentType = MediaType('image', 'jpeg');
            break;
          case 'png':
            contentType = MediaType('image', 'png');
            break;
          case 'gif':
            contentType = MediaType('image', 'gif');
            break;
          case 'webp':
            contentType = MediaType('image', 'webp');
            break;
          default:
            contentType = MediaType('image', 'jpeg'); // Default fallback
        }

        // Ensure filename has extension
        String fileName = profilePicture.name;
        if (!fileName.toLowerCase().endsWith('.$extension')) {
          fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
        }

        debugPrint('Uploading file: $fileName');
        final bytes = await profilePicture.readAsBytes();
        debugPrint('File size: ${bytes.lengthInBytes} bytes');
        debugPrint('Detected MIME: $contentType');

        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              bytes,
              filename: fileName,
              contentType: contentType,
            ),
          );
        } else {
          final fileLength = await profilePicture.length();
          debugPrint('File size (path): $fileLength bytes');
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto',
              profilePicture.path,
              filename: fileName,
              contentType: contentType,
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update Profile Status: ${response.statusCode}');
      debugPrint('Update Profile Headers: ${response.headers}');
      debugPrint('Update Profile Body: ${response.body}');

      if (response.statusCode == 200) {
        // Fetch ulang data user terbaru agar session sync
        await fetchCurrentUser();
        return null; // Success
      } else {
        // Log detailed error and return it
        final error = jsonDecode(response.body);
        final errorMessage = error['message'] ?? 'Failed to update profile';
        debugPrint('Failed to update: $errorMessage');
        return errorMessage;
      }
    } catch (e) {
      debugPrint('Error update profile: $e');
      return 'Connection error: $e';
    }
  }
}
