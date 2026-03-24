import 'package:driving_test_prep/features/home/widgets/menu_grid.dart';
import 'package:driving_test_prep/features/home/widgets/pro_banner.dart';
import 'package:driving_test_prep/features/home/widgets/progress_card.dart';
import 'package:driving_test_prep/features/home/widgets/topic_card.dart';
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
        leading: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          child: const Text('Cài đặt', style: TextStyle(color: Colors.blue)),
        ),
        title: const Text('Ôn luyện GPLX'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Tìm kiếm', style: TextStyle(color: Colors.blue)),
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
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            TopicCard(title: 'Khái niệm và quy tắc', done: 38, total: 180, correct: 9, wrong: 29),
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            TopicCard(title: 'Khái niệm và quy tắc', done: 38, total: 180, correct: 9, wrong: 29),
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            TopicCard(title: 'Khái niệm và quy tắc', done: 38, total: 180, correct: 9, wrong: 29),
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            TopicCard(title: 'Khái niệm và quy tắc', done: 38, total: 180, correct: 9, wrong: 29),
            TopicCard(title: 'Câu hỏi điểm liệt', done: 14, total: 60, correct: 1, wrong: 13),
            TopicCard(title: 'Khái niệm và quy tắc', done: 38, total: 180, correct: 9, wrong: 29),
          ],
        ),
      ),
    );
  }

}