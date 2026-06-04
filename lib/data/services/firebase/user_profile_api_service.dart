import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'auth_api_headers.dart';

class UserProfileApiService {
  UserProfileApiService(this.baseUrl);

  final String baseUrl;

  Future<String> uploadAvatar(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/Profile/avatar'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.headers.addAll(await AuthApiHeaders.bearer());

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Upload avatar failed: $body');
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    final photoUrl = data['photoURL']?.toString();
    if (photoUrl == null || photoUrl.isEmpty) {
      throw Exception('Upload avatar response does not contain photoURL.');
    }

    return photoUrl;
  }

  Future<String> updateDisplayName(String displayName) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/Profile/display-name'),
      headers: await AuthApiHeaders.json(),
      body: jsonEncode({'displayName': displayName}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Update display name failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final updatedName = data['displayName']?.toString();
    if (updatedName == null || updatedName.isEmpty) {
      throw Exception(
        'Update display name response does not contain displayName.',
      );
    }

    return updatedName;
  }
}
