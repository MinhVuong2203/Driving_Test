import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../features/social_network/models/notification_model.dart';

class NotificationApiService {
  final String baseUrl;

  NotificationApiService(this.baseUrl);

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/Notification/user/$userId'),
    );

    if (res.statusCode != 200) {
      throw Exception('Không thể tải thông báo: ${res.body}');
    }

    final List data = jsonDecode(res.body) as List;

    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await http.put(
      Uri.parse('$baseUrl/api/Notification/$notificationId/read'),
    );
  }
}