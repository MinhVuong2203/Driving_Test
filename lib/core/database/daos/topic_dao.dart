import 'package:driving_test_prep/core/database/app_database.dart';

class TopicDao{
  final AppDatabase db;
  TopicDao(this.db);

  // Lấy tất cả topic
  Future<List<Topic>> getAllTopics(){
    return db.select(db.topics).get();
  }

  // Lấy topic theo id
  Future<Topic?> getTopicById(int id){
    return (db.select(db.topics)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

}