import 'package:flutter/material.dart';

class ScoringModeSection extends StatelessWidget {
  final bool scoringAfterSubmit;
  final ValueChanged<bool> onChanged;

  const ScoringModeSection({
    super.key,
    required this.scoringAfterSubmit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScoringOptionTile(
          title: 'Chấm điểm sau khi nộp bài',
          isSelected: scoringAfterSubmit,
          onTap: () => onChanged(true),
        ),
        const Divider(height: 1, color: Color(0xFF3A3A3C), indent: 16),
        _ScoringOptionTile(
          title: 'Chấm điểm nhanh khi chọn đáp án',
          isSelected: !scoringAfterSubmit,
          onTap: () => onChanged(false),
        ),
        Container(
          color: const Color(0xFF2C2C2E),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '• Ứng dụng sẽ chấm điểm và hiển thị kết quả sau khi bạn nộp bài thi.',
                style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
              ),
              SizedBox(height: 4),
              Text(
                '• Chế độ này tương tự khi thi sát hạch và phù hợp để luyện tập thi thử.',
                style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoringOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScoringOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF2C2C2E),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blue, size: 22),
          ],
        ),
      ),
    );
  }
}