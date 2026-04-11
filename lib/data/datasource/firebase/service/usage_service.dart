import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<bool> canUseRecognition() async {
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      print(doc.data());
      final user = doc.data() ?? {};
      // 1. CHECK VIP
      final vip = user['vip'];
      if (vip != null) {
        final endDate = vip['endDate'];
        // lifetime (không có endDate)
        if (endDate == null) return true;
        // còn hạn
        if (DateTime.now().isBefore(endDate.toDate())) return true;
      }

      // 2. USER THƯỜNG (giới hạn 3 lần)
      final data = user['usage']?['trafficSignRecognition'] ?? {};
      final today = DateTime.now().toString().split(' ')[0];
      int count = (data['date'] == today) ? (data['count'] ?? 0) : 0;
      if (count >= 3) return false;
      // 3. UPDATE COUNT

      print(' ✅ Update document user trong usage -> trafficSignRecognition: $today, ${count + 1}');
      await _db.collection('users').doc(_uid).set({
        'usage': {
          'trafficSignRecognition': {
            'date': today,
            'count': count + 1,
          }
        }
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi: $e');
      return false;
    }
  }

  // Lấy số lượt truy caph nhận diện bien báo đã sử dụng trong ngày
  Future<int> getRemainingRecognition() async {
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      final user = doc.data() ?? {};

      // 🔥 1. CHECK VIP
      final vip = user['vip'];

      if (vip != null) {
        final endDate = vip['endDate'];

        // 💎 lifetime
        if (endDate == null) return -1;

        // 💎 còn hạn
        if (DateTime.now().isBefore(endDate.toDate())) return -1;
      }

      // 🔥 2. USER THƯỜNG
      final data = user['usage']?['trafficSignRecognition'] ?? {};
      final today = DateTime.now().toString().split(' ')[0];

      int used = (data['date'] == today) ? (data['count'] ?? 0) : 0;

      return (3 - used) > 0 ? (3 - used) : 0;
    } catch (e) {
      print('Lỗi getRemaining: $e');
      return 0;
    }
  }

}
