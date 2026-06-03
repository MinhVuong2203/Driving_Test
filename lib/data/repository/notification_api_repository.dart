import '../../features/social_network/models/notification_model.dart';
import '../services/firebase/notification_api_service.dart';

class NotificationApiRepository {
  final NotificationApiService _service;

  NotificationApiRepository._(this._service);

  factory NotificationApiRepository.instance(String baseUrl) {
    return NotificationApiRepository._(
      NotificationApiService(baseUrl),
    );
  }

  Future<List<NotificationModel>> getUserNotifications(String userId) {
    return _service.getUserNotifications(userId);
  }

  Future<void> markAsRead(String notificationId) {
    return _service.markAsRead(notificationId);
  }
}