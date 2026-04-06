import 'package:driving_test_prep/features/home/widgets/menu_grid.dart';
import 'package:driving_test_prep/features/home/widgets/pro_banner.dart';
import 'package:driving_test_prep/features/home/widgets/progress_card.dart';
import 'package:driving_test_prep/features/home/widgets/topic_card.dart';
import 'package:driving_test_prep/features/practice/screens/exam_topic_screen.dart';
import 'package:driving_test_prep/features/settings/screens/settings_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: Icon(
              Icons.settings,
              color: Colors.blue,
          ),
        ),
        title: const Text('Ôn luyện GPLX'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProBanner(),
            const SizedBox(height: 12),
            MenuGrid(),
            const SizedBox(height: 16),
            ProgressCard(),
            const SizedBox(height: 50),
            const Text('Ôn tập theo chủ đề', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TopicCard(
              title: 'Quy định chung và quy tắc giao thông đường bộ',
              done: 14, total: 60, correct: 1, wrong: 13,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 1)),
                );
              },
            ),
            TopicCard(
              title: 'Văn hóa giao thông, đạo đức người lái xe, kỹ năng phòng cháy, chữa cháy và cứu hộ, cứu nạn',
              done: 38, total: 180, correct: 9, wrong: 29,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 2)),
                );
              },
            ),
            TopicCard(
              title: 'Kỹ thuật lái xe',
              done: 14, total: 60, correct: 1, wrong: 13,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 3)),
                );
              },
            ),
            TopicCard(
              title: 'Cấu tạo và sửa chữa',
              done: 38, total: 180, correct: 9, wrong: 29,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 4)),
                );
              },
            ),
            TopicCard(
              title: 'Báo hiệu đường bộ',
              done: 14, total: 60, correct: 1, wrong: 13,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 5)),
                );
              },
            ),
            TopicCard(
              title: 'Sa hình và kỹ năng xử lý tình huống giao thông',
              done: 38, total: 180, correct: 9, wrong: 29,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExamTopicScreen(topicId: 6)),
                );
              },
            ),
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

}