import 'package:driving_test_prep/features/practice/widgets/info_row.dart';
import 'package:driving_test_prep/features/practice/widgets/start_button.dart';
import 'package:flutter/material.dart';

class ExamDetailScreen extends StatelessWidget {
  const ExamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thi thử lý thuyết - hạng B',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Box thông tin
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  InfoRow(label: 'Số lượng câu hỏi:', value: '30 câu'),
                  InfoRow(label: 'Thời gian làm bài:', value: '20 phút'),
                  InfoRow(label: 'Điểm đậu tối thiểu:', value: '27/30 câu'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  InfoRow(
                    label: 'Chấm điểm sau khi nộp bài',
                    value: '✓',
                  ),
                  InfoRow(
                    label: 'Chấm điểm nhanh khi chọn đáp án',
                    value: '',
                  ),
                ],
              ),
            ),

            const Spacer(),

            StartButton(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bắt đầu làm bài')),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}