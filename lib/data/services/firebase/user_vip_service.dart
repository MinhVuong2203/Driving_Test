import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/data/models/user_vip_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserVipService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserVipService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserVipModel?> getCurrentUserVip() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data == null) return null;

    final rawVip = data['vipUser'];
    if (rawVip is! Map) return null;

    final vip = UserVipModel.fromMap(Map<String, dynamic>.from(rawVip));
    return vip.isActive ? vip : null;
  }
}
