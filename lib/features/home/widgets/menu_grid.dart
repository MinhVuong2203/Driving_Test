import 'package:driving_test_prep/features/practice/screens/exam_list_screens.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:driving_test_prep/features/practice/screens/exam_topic_quets_screen.dart';
import 'package:driving_test_prep/features/home/screens/tips_screen.dart';
import '../screens/traffic_sign_screen.dart';

class MenuGrid extends StatelessWidget {

  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icons': Icons.description,
        'text': 'Thi thử',
        'color': Color.fromRGBO(8, 102, 255, 1),
        'route': const ExamListScreen()
      },
      {
        'icons': Icons.close,
        'text': 'Câu sai',
        'color': Color.fromRGBO(255, 0, 0, 0.8),
        'route': const ExamTopicQuetsScreen(topicId: -1, mode: 4, topicTitle: 'Câu làm sai'),
      },
      {
        'icons': Icons.bookmark, 
        'text': 'Đã lưu', 
        'color': Color.fromRGBO(252, 227, 3, 0.7),
        'route': const ExamTopicQuetsScreen(topicId: -1, mode: 3, topicTitle: 'Câu đã lưu'),
      },
      {
        'icons': Icons.menu_book, 
        'text': 'Câu khó', 
        'color': Color.fromRGBO(3, 252, 69,0.6),
        'route': const ExamTopicQuetsScreen(topicId: -1, mode: 2, topicTitle: 'Câu hỏi điểm liệt'),
      },
      {
        'icons': Icons.change_history, 
        'text': 'Sa hình', 
        'color': Color.fromRGBO(3, 252, 69,0.6),
        'route': const ExamTopicQuetsScreen(topicId: 6, mode: 0),
      },
      {
        'icons': Icons.lightbulb, 
        'text': 'Mẹo', 
        'color': Color.fromRGBO(252, 227, 3, 0.7),
        'route': const TipsScreen(),
      },
      {
        'icons': Icons.remove,
        'text': 'Biển báo',
        'color': Color.fromRGBO(255, 0, 0, 0.8),
        'route': const TrafficSignsScreen() // Đặt vào đây nha Minh
      },
      {'icons': Icons.facebook, 'text': 'Hỏi đáp', 'color': Color.fromRGBO(8, 102, 255, 1)},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (items[index]['route'] != null){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => items[index]['route'] as Widget )
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: items[index]['color'] as Color,
                  child: Icon(items[index]['icons'] as IconData, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(items[index]['text'] as String, style: const TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }



}