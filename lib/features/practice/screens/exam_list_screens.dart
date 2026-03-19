import 'package:driving_test_prep/features/practice/screens/exam_detail_screen.dart';
import 'package:driving_test_prep/features/practice/widgets/exam_card.dart';
import 'package:flutter/material.dart';


class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTOMOTO - B'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 17,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ExamCard(
            title: 'Đề ${index + 1}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExamDetailScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}