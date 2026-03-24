import 'package:flutter/material.dart';

class ExamVersionSection extends StatelessWidget {
  const ExamVersionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFF3A3A3C), width: 3),
        ),
      ),
      child: Container(
        color: const Color(0xFF2C2C2E),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'PHIÊN BẢN BỘ ĐỀ THI',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Bộ đề thi theo luật mới được áp dụng thống nhất từ ngày 1/9/2025.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}