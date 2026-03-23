import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/topic_dao.dart';

class TopicRepository {
  final TopicDao dao;
  TopicRepository(this.dao);

  // Lấy tất cả topics (từ DB)
  Future<List<Topic>> getTopics() {
    return dao.getAllTopics();
  }

  // Lấy theo id
  Future<Topic?> getTopicById(int id) {
    return dao.getTopicById(id);
  }

}