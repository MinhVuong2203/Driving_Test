import 'package:driving_test_prep/features/practice/screens/exam_list_screens.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuGrid extends StatelessWidget {

  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.description,
        'text': 'Thi thử',
        'color': Color.fromRGBO(8, 102, 255, 1),
        'route': const ExamListScreen()
      },
      {
        'icon': Icons.close,
        'text': 'Câu sai',
        'color': Color.fromRGBO(255, 0, 0, 0.8),
      },
      {'icon': Icons.bookmark, 'text': 'Đã lưu', 'color': Color.fromRGBO(252, 227, 3, 0.7)},
      {'icon': Icons.menu_book, 'text': 'Câu khó', 'color': Color.fromRGBO(3, 252, 69,0.6)},
      {'icon': Icons.change_history, 'text': 'Sa hình', 'color': Color.fromRGBO(3, 252, 69,0.6)},
      {'icon': Icons.lightbulb, 'text': 'Mẹo', 'color': Color.fromRGBO(252, 227, 3, 0.7)},
      {
        'icon': Icons.remove,
        'text': 'Biển báo',
        'color': Color.fromRGBO(255, 0, 0, 0.8),
        'route': "" // Đặt vào đây nha Minh
      },
      {'icon': Icons.facebook, 'text': 'Hỏi đáp', 'color': Color.fromRGBO(8, 102, 255, 1)},
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
                  child: Icon(items[index]['icon'] as IconData, color: Colors.white),
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