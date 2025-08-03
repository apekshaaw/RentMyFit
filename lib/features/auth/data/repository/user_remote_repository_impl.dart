// lib/features/auth/data/repository/user_remote_repository_impl.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rent_my_fit/app/service_locator.dart';
import 'package:rent_my_fit/core/network/api_config.dart';
import 'package:rent_my_fit/features/auth/domain/entity/user_entity.dart'
    as user_entity;
import 'package:rent_my_fit/features/auth/domain/repository/user_repository.dart';
import 'package:rent_my_fit/features/profile/domain/entity/profile_entity.dart'
    as profile_entity;

class UserRemoteRepositoryImpl implements UserRepository {
  final http.Client client;

  UserRemoteRepositoryImpl(this.client);

  @override
  Future<void> registerUser(user_entity.UserEntity user) async {
    // 1️⃣ Fetch dynamic base URL
    final base = await ApiConfig.baseUrl;
    // 2️⃣ Build URI
    final uri = Uri.parse('$base/auth/register');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<user_entity.UserEntity> loginUser(
    String email,
    String password,
  ) async {
    // preserve your existing admin-login logic
    final isAdminLogin =
        email == 'admin@rentmyfit.com' && password == 'admin1234';

    // fetch base & pick correct path
    final base = await ApiConfig.baseUrl;
    final path = isAdminLogin ? '/auth/admin-login' : '/auth/login';
    final uri = Uri.parse('$base$path');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final u = data['user'];
      return user_entity.UserEntity(
        id:      u['id']    ?? u['_id'],
        name:    u['name'],
        email:   u['email'],
        password:'',
        isAdmin: u['isAdmin'] ?? false,
        token:   data['token'],
      );
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<profile_entity.ProfileEntity?> getProfile() async {
    final token = authToken;
    if (token == null) {
      throw Exception('No token, authorization denied');
    }

    // fetch base & build profile URI
    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base/auth/profile');

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body)['message'];
      throw Exception(err ?? 'Failed to fetch profile');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final raw = body['profileImage'] as String?;
    final photoUrl = (raw != null && raw.isNotEmpty)
        ? '$base$raw'
        : null;

    return profile_entity.ProfileEntity(
      name:     body['name']        as String,
      email:    body['email']       as String,
      address:  body['address']     as String?,
      phone:    body['phoneNumber'] as String?,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> updateProfile(profile_entity.ProfileEntity profile) async {
    final token = authToken;
    if (token == null) {
      throw Exception('No token, authorization denied');
    }

    // fetch base & build profile URI
    final base = await ApiConfig.baseUrl;
    final uri  = Uri.parse('$base/auth/profile');

    // If user selected a new local image, use multipart
    if (profile.photoUrl != null &&
        profile.photoUrl!.isNotEmpty &&
        !profile.photoUrl!.startsWith('http')) {
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name']       = profile.name
        ..fields['email']      = profile.email;

      if (profile.address != null) {
        request.fields['address'] = profile.address!;
      }
      if (profile.phone != null) {
        request.fields['phoneNumber'] = profile.phone!;
      }

      // attach file
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        profile.photoUrl!, // local filesystem path
      ));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode != 200) {
        String message;
        try {
          message = jsonDecode(response.body)['message'];
        } catch (_) {
          message = 'status ${response.statusCode}';
        }
        throw Exception('Failed to update profile ($message)');
      }
      return;
    }

    // Otherwise, do a simple PUT with JSON
    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name':        profile.name,
        'email':       profile.email,
        'address':     profile.address,
        'phoneNumber': profile.phone,
      }),
    );

    if (response.statusCode != 200) {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (_) {
        message = 'status ${response.statusCode}';
      }
      throw Exception('Failed to update profile ($message)');
    }
  }
}
