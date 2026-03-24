import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/topic_dao.dart';
import 'package:driving_test_prep/data/repository/topic_repository.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  // var ex =  await db.select(db.examSets).get();
  //
  // final topic_repo = TopicRepository(TopicDao(db));
  // final topics = await topic_repo.getTopics();
  // print(topics);
  // print("\n------------------------------");
  // final topic3 = await topic_repo.getTopicById(3);
  // print(topic3);




  runApp(const MyApp());
}